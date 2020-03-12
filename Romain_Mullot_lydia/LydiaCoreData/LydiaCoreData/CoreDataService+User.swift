//
//  CoreDataService+User.swift
//  LydiaCoreData
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import LydiaAPI
import CoreData

public protocol UsersCoreDataServiceProtocol: AnyObject {
    func saveUsers(_ users: [UserJSON])
}

private enum UserImageSize: String {
    case thumbnail
    case medium
    case large
}

extension CoreDataService: UsersCoreDataServiceProtocol {

    public func saveUsers(_ users: [UserJSON]) {
        var errorMessage = ""

        users.forEach {
            convertToUserCoreData($0, completionHandler: { result in
                switch result {
                case .failure(let message):
                    errorMessage = message.localizedDescription
                default:
                    break
                }
            })
        }

        guard errorMessage.isEmpty else {
            print(errorMessage)
            return
        }
        saveContext()
    }
}

// MARK: - Private methods

private extension CoreDataService {

    func convertToUserCoreData(_ user: UserJSON, completionHandler: CoreDataCallback<UserCoreData>? = nil) {

        //check if object exists already or create new one

        let predicate = NSPredicate(format: "%@ == %@", argumentArray: [ \UserCoreData.email, user.email])

        get(value: UserCoreData.self, isMaincontext: false, predicate: predicate, sortParameters: nil) { (result) in
            switch result {
            case .success(let objectsCoreData):
                // more than 1 object with same id problem ?
                guard let objectsCoreData = objectsCoreData, objectsCoreData.count <= 1 else {
                    completionHandler?(.failure(.duplicateObject("already in the coredata cache")))
                    return
                }
                // check object already in cache
                guard let resultObject: UserCoreData = objectsCoreData.count == 1 ? objectsCoreData[0] : NSEntityDescription.insertNewObject(forEntityName: String(describing: UserCoreData.self), into: backgroundManagedObjectContext) as? UserCoreData else {
                    completionHandler?(.failure(.genericError("Error: Cannot create UserCoreData")))
                    return
                }

                resultObject.birthdayDate = user.birthdayDate
                resultObject.registeredDate = user.registeredDate
                resultObject.email = user.email
                resultObject.phone = user.phone
                resultObject.cell = user.cell
                resultObject.nationality = user.nationality
                resultObject.identity = user.identity
                resultObject.gender = user.gender

               setImages(resultObject: resultObject, user: user)

                if let locationResultObject = NSEntityDescription.insertNewObject(forEntityName: String(describing: LocationCoreData.self), into: backgroundManagedObjectContext) as? LocationCoreData {
                    let location = user.location
                    locationResultObject.longitude = location.longitude
                    locationResultObject.latitude = location.latitude
                    locationResultObject.street = location.street
                    locationResultObject.postcode = location.postcode
                    locationResultObject.city = location.city
                    locationResultObject.state = location.state
                    locationResultObject.country = location.country
                    locationResultObject.timezone = location.timezone
                    resultObject.location = locationResultObject
                }

                completionHandler?(.success([resultObject]))
            case .failure(let error):
                completionHandler?(.failure(.genericError("Error fetch object : \(error)")))
            }
        }
    }

    func setImages(resultObject: UserCoreData, user: UserJSON) {
        var imagesCoreData: Set<ImageCoreData> = Set<ImageCoreData>()

        if let imageResultObject = NSEntityDescription.insertNewObject(forEntityName: String(describing: ImageCoreData.self), into: backgroundManagedObjectContext) as? ImageCoreData {
            let imageThumb = user.imageUrls.thumbnail
            imageResultObject.type = UserImageSize.thumbnail.rawValue
            imageResultObject.url = imageThumb
            imagesCoreData.insert(imageResultObject)
        }

        if let imageResultObject = NSEntityDescription.insertNewObject(forEntityName: String(describing: ImageCoreData.self), into: backgroundManagedObjectContext) as? ImageCoreData {
            let imageMedium = user.imageUrls.medium
            imageResultObject.type = UserImageSize.medium.rawValue
            imageResultObject.url = imageMedium
            imagesCoreData.insert(imageResultObject)
        }

        if let imageResultObject = NSEntityDescription.insertNewObject(forEntityName: String(describing: ImageCoreData.self), into: backgroundManagedObjectContext) as? ImageCoreData {
            let imageLarge = user.imageUrls.large
            imageResultObject.type = UserImageSize.large.rawValue
            imageResultObject.url = imageLarge
            imagesCoreData.insert(imageResultObject)
        }
        resultObject.images = imagesCoreData
    }

}
