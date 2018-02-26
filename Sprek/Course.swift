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
    @objc dynamic var name = ""
    @objc dynamic var lang = ""
    @objc dynamic var id = UUID().uuidString
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
    
    /// Returns the average strength of all cards in a course
    var strength: Int{
        let realm = try! Realm(configuration: MyRealm.config)
        let cards = realm.objects(Card.self).filter("unit.course == %@", self)
        var strengths: [Int] = []
        for card in cards{
            strengths.append(card.calcStrength)
        }
        return strengths.roundAverage
    }
    
}
