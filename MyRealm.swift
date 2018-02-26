//
//  MyRealm.swift
//  Sprek
//
//  Created by Eli Yazdi on 8/8/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import Foundation
import RealmSwift

class MyRealm{
    static var config: Realm.Configuration{
        get{
            if SyncUser.current != nil{
                let serverURL = URL(string: "realm://45.55.220.254:9080/~/userdata")
                let syncConf = SyncConfiguration(user: SyncUser.current!, realmURL: serverURL!)
                return Realm.Configuration(syncConfiguration: syncConf)
            }else{
                return Realm.Configuration()
            }
        }
    }
    
    static func copyToSyncedRealm(){
        if SyncUser.current != nil{
            let serverURL = URL(string: "realm://45.55.220.254:9080/~/userdata")
            let syncConf = SyncConfiguration(user: SyncUser.current!, realmURL: serverURL!)
            let conf = Realm.Configuration(syncConfiguration: syncConf)
            let localRealm = try! Realm(configuration: .defaultConfiguration)
            let syncedRealm = try! Realm(configuration: conf)
            
            let localCourses = localRealm.objects(Course.self)
            for course in localCourses{
                try! syncedRealm.write {
                    syncedRealm.create(Course.self, value: course, update: true)
                }
            }
            
            let localUnits = localRealm.objects(Unit.self)
            for unit in localUnits{
                try! syncedRealm.write {
                    syncedRealm.create(Unit.self, value: unit, update: true)
                }
            }
            
            let localCards = localRealm.objects(Card.self)
            for card in localCards{
                try! syncedRealm.write {
                    syncedRealm.create(Card.self, value: card, update: true)
                }
            }
            
            let localActivities = localRealm.objects(Activity.self)
            for activity in localActivities{
                try! syncedRealm.write {
                    syncedRealm.create(Activity.self, value: activity, update: true)
                }
            }
        }
    }
    
    static func copyFromSyncedRealm(){
        if SyncUser.current != nil{
            let serverURL = URL(string: "realm://45.55.220.254:9080/~/userdata")
            let syncConf = SyncConfiguration(user: SyncUser.current!, realmURL: serverURL!)
            let conf = Realm.Configuration(syncConfiguration: syncConf)
            let localRealm = try! Realm(configuration: .defaultConfiguration)
            let syncedRealm = try! Realm(configuration: conf)
            
            let syncedCourses = syncedRealm.objects(Course.self)
            for course in syncedCourses{
                try! syncedRealm.write {
                    localRealm.create(Course.self, value: course, update: true)
                }
            }
            
            let syncedUnits = syncedRealm.objects(Unit.self)
            for unit in syncedUnits{
                try! syncedRealm.write {
                    localRealm.create(Unit.self, value: unit, update: true)
                }
            }
            
            let syncedCards = syncedRealm.objects(Card.self)
            for card in syncedCards{
                try! syncedRealm.write {
                    localRealm.create(Card.self, value: card, update: true)
                }
            }
            
            let syncedActivities = syncedRealm.objects(Activity.self)
            for activity in syncedActivities{
                try! syncedRealm.write {
                    localRealm.create(Activity.self, value: activity, update: true)
                }
            }
        }
    }
}
