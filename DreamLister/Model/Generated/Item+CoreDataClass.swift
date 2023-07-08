//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Kimia Yazdani on 7/6/23.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = Date()
    }
}
