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
    @objc dynamic var isSentence = false
    @objc dynamic var sentence = ""
    @objc dynamic var translation = ""
    @objc dynamic var strength: Int = 0
    @objc dynamic var latin: String? = nil
    @objc dynamic var audio: Data?
    @objc dynamic var unit: Unit?
    @objc dynamic var nextPractice: Date? = Date()
    
    @objc dynamic var id = UUID().uuidString
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var calcStrength: Int{
        get{
            let hoursSinceLastPracticeDue = Date().hours(from: self.nextPractice!)
            if(hoursSinceLastPracticeDue < 12){
                switch self.strength{
                case 1:
                    return 3
                case 2:
                    return 4
                case 3:
                    return 4
                case 4:
                    return 4
                case 5:
                    return 5
                default:
                    return 0
                }
            }else if(hoursSinceLastPracticeDue < 24){
                switch self.strength{
                case 1:
                    return 3
                case 2:
                    return 3
                case 3:
                    return 3
                case 4:
                    return 4
                case 5:
                    return 5
                default:
                    return 0
                }
            }else if(hoursSinceLastPracticeDue < 48){
                switch self.strength{
                case 1:
                    return 2
                case 2:
                    return 2
                case 3:
                    return 3
                case 4:
                    return 4
                case 5:
                    return 5
                default:
                    return 0
                }
            }
            else if(hoursSinceLastPracticeDue < 48){
                switch self.strength{
                case 1:
                    return 1
                case 2:
                    return 1
                case 3:
                    return 2
                case 4:
                    return 4
                case 5:
                    return 5
                default:
                    return 0
                }
            }else if(hoursSinceLastPracticeDue < 72){
                switch self.strength{
                case 1:
                    return 1
                case 2:
                    return 1
                case 3:
                    return 1
                case 4:
                    return 3
                case 5:
                    return 4
                default:
                    return 0
                }
            }else{
                switch self.strength{
                case 1:
                    return 1
                case 2:
                    return 1
                case 3:
                    return 1
                case 4:
                    return 2
                case 5:
                    return 3
                default:
                    return 0
                }
            }
        }
    }
    
    func answer(isCorrect correct: Bool){
        let realm = try! Realm(configuration: MyRealm.config)
        try! realm.write{
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
    func delete(){
        let realm = try! Realm(configuration: MyRealm.config)
        try! realm.write{
            realm.delete(self)
        }
    }
}

