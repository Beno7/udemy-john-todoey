//
//  Item.swift
//  Todoey
//
//  Created by John Adriel Benolirao on 15/03/2018.
//  Copyright © 2018 John Adriel Benolirao. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //reverse relationship
}
