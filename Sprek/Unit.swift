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
    
    dynamic var id = UUID().uuidString
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /// Deletes course as well as all units and cards associated with it
    func delete(){
        let realm = try! Realm(configuration: MyRealm.config)
        let cards = realm.objects(Card.self).filter("unit == %@", self)
        try! realm.write{
            realm.delete(cards)
            realm.delete(self)
        }
    }
    
    /// Returns the average strength of all cards in a unit
    var strength: Int {
        let realm = try! Realm(configuration: MyRealm.config)
        let cards = realm.objects(Card.self).filter("unit == %@", self)
        var strengths: [Int] = []
        for card in cards{
            strengths.append(card.strength)
        }
        return strengths.roundAverage
    }
}

extension Array where Element == Int {
    /// Returns the sum of all elements in the array
    var total: Element {
        return reduce(0, +)
    }
    /// Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(reduce(0, +)) / Double(count)
    }
    /// Returns rounded average of all elements in the array
    var roundAverage: Int {
        return Int(round(isEmpty ? 0 : Double(reduce(0, +)) / Double(count)))
    }
}
