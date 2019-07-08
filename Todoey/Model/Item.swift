//
//  Item.swift
//  Todoey
//
//  Created by Akshansh Gusain on 08/07/19.
//  Copyright © 2019 Akshansh Gusain. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic  var done: Bool = false
    @objc dynamic var date: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
