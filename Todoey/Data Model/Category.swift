//
//  Category.swift
//  Todoey
//
//  Created by John Adriel Benolirao on 15/03/2018.
//  Copyright © 2018 John Adriel Benolirao. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>() //forward relationship
}
