//
//  CoreDataService.swift
//  LydiaCoreData
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import CoreData

public enum CoreDataError: Error {
    case duplicateObject(String)
    case noObject(String)
    case genericError(String)
}

public typealias CoreDataCallback<T> = (Result<[T]?, CoreDataError>) -> Void

public protocol CoreDataServiceProtocol: AnyObject {
    func saveContext()
    func clearData<T: NSManagedObject>(_ type: T.Type)
    func get<T: NSManagedObject>(value: T.Type, isMaincontext: Bool, predicate: NSPredicate?, sortParameters: [[String: Bool]]?, completionHandler: @escaping CoreDataCallback<T>)
    func getFirst<T: NSManagedObject>(value: T.Type, isMaincontext: Bool, predicate: NSPredicate?, sortParameters: [[String: Bool]]?) -> T?
    func getAll<T: NSManagedObject>(value: T.Type, isMaincontext: Bool, predicate: NSPredicate?, sortParameters: [[String: Bool]]?) -> [T]?
}

public final class CoreDataService: CoreDataServiceProtocol {

    public static let sharedInstance = CoreDataService()

    // MARK: - Core Data stack

    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        //...
        NSPersistentContainer.defaultDirectoryURL()
        let momdName = "LydiaCoreData"

        guard let modelURL = Bundle(for: type(of: self)).url(forResource: momdName, withExtension: "momd") else {
                fatalError("Error loading model from bundle")
        }

        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }

        let container = NSPersistentContainer(name: momdName, managedObjectModel: mom)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    internal lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let mainCtx = persistentContainer.viewContext
        mainCtx.name = "Main"
        mainCtx.automaticallyMergesChangesFromParent = true
        mainCtx.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return mainCtx
    }()

    internal lazy var backgroundManagedObjectContext: NSManagedObjectContext = {
        let bckContext = persistentContainer.newBackgroundContext()
        bckContext.name = "Background"
        bckContext.automaticallyMergesChangesFromParent = true
        bckContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return bckContext
    }()

    // MARK: - Core Data Saving support

    public func saveContext () {
        let context = backgroundManagedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror) \(nserror.userInfo)")
            }
        }
    }

    public func clearData<T: NSManagedObject>(_ type: T.Type) {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
            do {
              let objects  = try backgroundManagedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
              objects?.forEach { backgroundManagedObjectContext.delete($0) }
              saveContext()
            } catch let error {
              print("ERROR DELETING : \(error)")
            }
          }
    }

    public func get<T: NSManagedObject>(value: T.Type, isMaincontext: Bool, predicate: NSPredicate? = nil, sortParameters: [[String: Bool]]? = nil, completionHandler: CoreDataCallback<T>) {
        do {
            let context = isMaincontext ? mainManagedObjectContext : backgroundManagedObjectContext
            let request = fetchRequest(type: T.self, context: context, predicate: predicate, sortedBy: sortParameters)
            let fetchResults = try context.fetch(request) as? [T]
            completionHandler(.success(fetchResults))
        } catch let error {
            print("ERROR: no \(T.self) in cache \(error)")
            completionHandler(.failure(.genericError("\(error)")))
        }
    }

    public func getFirst<T: NSManagedObject>(value: T.Type, isMaincontext: Bool, predicate: NSPredicate? = nil, sortParameters: [[String: Bool]]? = nil) -> T? {
        do {
            let context = isMaincontext ? mainManagedObjectContext : backgroundManagedObjectContext
            let request = fetchRequest(type: T.self, context: context, predicate: predicate, sortedBy: sortParameters)
            if let fetchResults = try context.fetch(request) as? [T] {
                return fetchResults.isNotEmpty ? fetchResults[0] : nil
            }
            return nil
        } catch let error {
            print("ERROR: no \(T.self) in cache  \(error)")
            return nil
        }
    }

    public func getAll<T: NSManagedObject>(value: T.Type, isMaincontext: Bool, predicate: NSPredicate? = nil, sortParameters: [[String: Bool]]? = nil) -> [T]? {
        do {
            let context = isMaincontext ? mainManagedObjectContext : backgroundManagedObjectContext
            let request = fetchRequest(type: T.self, context: context, predicate: predicate, sortedBy: sortParameters)
            if let fetchResults = try context.fetch(request) as? [T] {
                return fetchResults
            }
            return nil
        } catch let error {
            print("ERROR: no \(T.self) in cache  \(error)")
            return nil
        }
    }

    private init() {}
}

// MARK: - Private methods

private extension CoreDataService {

    func fetchRequest<T: NSManagedObject>(type: T.Type, context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy: [[String: Bool]]? = nil) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: String(describing: type), in: context)
        request.entity = entity

        if let predicate = predicate {
            request.predicate = predicate
        }

        if let sortedBy = sortedBy {
            var sortDescriptors = [NSSortDescriptor]()
            sortedBy.forEach { (sort) in
                guard let key = sort.keys.first else { return }
                let sort = NSSortDescriptor(key: key, ascending: sort[key] ?? true)
                sortDescriptors.append(sort)
            }

            request.sortDescriptors = sortDescriptors
        }

        return request
    }
}
