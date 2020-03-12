//
//  UserCoreData+CoreDataProperties.swift
//  
//
//  Created by Romain Mullot on 04/03/2020.
//
//

import Foundation
import CoreData

extension UserCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCoreData> {
        return NSFetchRequest<UserCoreData>(entityName: "UserCoreData")
    }

    @NSManaged public var gender: String
    @NSManaged public var email: String
    @NSManaged public var phone: String
    @NSManaged public var cell: String
    @NSManaged public var nationality: String
    @NSManaged public var identity: String
    @NSManaged public var birthdayDate: Date
    @NSManaged public var registeredDate: Date
    @NSManaged public var images: Set<ImageCoreData>?
    @NSManaged public var location: LocationCoreData

}

// MARK: Generated accessors for images
extension UserCoreData {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ImageCoreData)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ImageCoreData)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}
