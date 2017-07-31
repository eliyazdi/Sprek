//
//  Langs.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/19/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import Foundation

struct Lang{
    var key: String
    var name: String
    var flag: String
    var nativeName: String
}

class Langs{
    var dict: [String: Any]
    var arr = [Lang]()
    init(){
        do {
            if let file = Bundle.main.url(forResource: "langs", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    self.dict = object
                    self.arr = []
                    for (key, val) in object{
                        self.arr.append(Lang(
                            key: key,
                            name: (val as! NSDictionary)["name"]! as! String,
                            flag: (val as! NSDictionary)["flag"]! as! String,
                            nativeName: (val as! NSDictionary)["nativeName"]! as! String
                            ))
                    }
                    self.arr = self.arr.sorted { $0.name < $1.name }
                } else if let object = json as? [Any] {
                    // json is an array
                    print("JSON is array \(object)")
                    self.dict = ["error": "array"]
                    self.arr = [Lang(
                        key: "error",
                        name: "error",
                        flag: "error",
                        nativeName: "error"
                        )]
                } else {
                    print("JSON is invalid")
                    self.dict = ["error": "error"]
                    self.arr = [Lang(
                        key: "error",
                        name: "error",
                        flag: "error",
                        nativeName: "error"
                        )]
                }
            } else {
                print("no file")
                self.dict = ["error": "error"]
                self.arr = [Lang(
                    key: "error",
                    name: "error",
                    flag: "error",
                    nativeName: "error"
                    )]
            }
        } catch {
            print(error.localizedDescription)
            self.dict = ["error": "error"]
            self.arr = [Lang(
                key: "error",
                name: "error",
                flag: "error",
                nativeName: "error"
                )]
        }
    }
}
