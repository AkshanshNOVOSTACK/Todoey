//
//  item.swift
//  Todoey
//
//  Created by Akshansh Gusain on 05/07/19.
//  Copyright © 2019 Akshansh Gusain. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable{
    
    var title: String = ""
    var done: Bool = false
}
