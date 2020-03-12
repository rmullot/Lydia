//
//  ImageCoreData+CoreDataProperties.swift
//  
//
//  Created by Romain Mullot on 04/03/2020.
//
//

import Foundation
import CoreData

extension ImageCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageCoreData> {
        return NSFetchRequest<ImageCoreData>(entityName: "ImageCoreData")
    }

    @NSManaged public var url: String
    @NSManaged public var type: String
    @NSManaged public var user: UserCoreData?

}
