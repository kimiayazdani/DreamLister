//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Kimia Yazdani on 7/7/23.
//
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}

extension ItemType : Identifiable {

}
