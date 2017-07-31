//
//  Sentence.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/28/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import Foundation
import RealmSwift

class Card: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var isSentence = false
    dynamic var sentence = ""
    dynamic var translation = ""
    dynamic var strength: Int = 0
    dynamic var latin: String? = nil
    dynamic var audio: Data?
    dynamic var unit: Unit?
    dynamic var nextPractice: Date? = nil
    func answer(_ correct: Bool){
        if(correct){
            let cal = Calendar(identifier: .gregorian)
            switch strength{
            case 1:
                self.nextPractice = cal.date(byAdding: .day, value: 1, to: Date())
                self.strength += 1
            case 2:
                self.nextPractice = cal.date(byAdding: .day, value: 2, to: Date())
                self.strength += 1
            case 3:
                self.nextPractice = cal.date(byAdding: .day, value: 4, to: Date())
                self.strength += 1
            case 4:
                self.nextPractice = cal.date(byAdding: .day, value: 7, to: Date())
                self.strength += 1
            case 5:
                self.nextPractice = cal.date(byAdding: .day, value: 10, to: Date())
            default:
                self.nextPractice = cal.date(byAdding: .day, value: 1, to: Date())
                self.strength += 1
            }
        }else{
            if(self.strength > 0){
                self.strength -= 1
                self.nextPractice = Date()
            }
        }
    }
}
