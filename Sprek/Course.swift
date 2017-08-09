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
    dynamic var id = UUID().uuidString
    override static func primaryKey() -> String? {
        return "id"
    }
    func delete(){
        let realm = try! Realm(configuration: MyRealm.config)
        let units = realm.objects(Unit.self).filter("course == %@", self)
        for unit in units{
            unit.delete()
        }
        try! realm.write {
            realm.delete(self)
        }
    }
    
    /// Returns the average strength of all units in a course
    var strength: Int{
        let realm = try! Realm(configuration: MyRealm.config)
        let units = realm.objects(Unit.self).filter("course == %@", self)
        var strengths: [Int] = []
        for unit in units{
            strengths.append(unit.strength)
        }
        return strengths.roundAverage
    }
    
}
