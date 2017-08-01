//
//  Unit.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/28/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import Foundation
import RealmSwift

class Unit: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var name = ""
    dynamic var course: Course?
    func delete(){
        let realm = try! Realm()
        let cards = realm.objects(Card.self).filter("unit == %@", self)
        try! realm.write{
            realm.delete(cards)
            realm.delete(self)
        }
    }
    func getStrength(){
        
    }
}
