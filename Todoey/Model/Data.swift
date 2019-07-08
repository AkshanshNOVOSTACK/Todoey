//
//  Data.swift
//  Todoey
//
//  Created by Akshansh Gusain on 08/07/19.
//  Copyright © 2019 Akshansh Gusain. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object{
   @objc dynamic var name: String = ""
   @objc dynamic var age: Int = 0
}
