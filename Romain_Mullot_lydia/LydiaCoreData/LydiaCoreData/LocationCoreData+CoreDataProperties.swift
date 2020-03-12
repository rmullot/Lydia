//
//  LocationCoreData+CoreDataProperties.swift
//  
//
//  Created by Romain Mullot on 09/03/2020.
//
//

import Foundation
import CoreData

extension LocationCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationCoreData> {
        return NSFetchRequest<LocationCoreData>(entityName: "LocationCoreData")
    }

    @NSManaged public var street: String
    @NSManaged public var city: String
    @NSManaged public var state: String
    @NSManaged public var country: String
    @NSManaged public var postcode: String
    @NSManaged public var timezone: String
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var users: Set<UserCoreData>?

}

// MARK: Generated accessors for users
extension LocationCoreData {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: UserCoreData)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: UserCoreData)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}
