//
//  Item.swift
//  Todoey
//
//  Created by John Adriel Benolirao on 11/03/2018.
//  Copyright © 2018 John Adriel Benolirao. All rights reserved.
//

import Foundation

class Item: Codable{
    
    var item: String?
    var isDone: Bool?
    
    init(item:String, isDone:Bool){
        self.item = item
        self.isDone = isDone
    }
    
}
