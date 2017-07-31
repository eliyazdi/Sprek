//
//  Course.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/20/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import Foundation
import RealmSwift

class Course: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var name = ""
    dynamic var lang = ""
    dynamic var noSpaces = false
    dynamic var backwards = false
    
}
