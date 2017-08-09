//
//  Activity.swift
//  Sprek
//
//  Created by Eli Yazdi on 8/7/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import Foundation
import RealmSwift

class Activity: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var date = Date()
    dynamic var points = 0
    dynamic var course: Course?
    
    dynamic var id = UUID().uuidString
    override static func primaryKey() -> String? {
        return "id"
    }
}
