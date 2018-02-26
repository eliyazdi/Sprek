//
//  LexemeTag.swift
//  Sprek
//
//  Created by Eli Yazdi on 8/11/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import Foundation

class LexemeTag{
    
    enum WordType{
        case noun
        case verb
        case adjective
        case adverb
        case determiner
        case pronoun
        case particle
        case preposition
        case interjection
    }
    
    var base: String
    
    init(_ base: String){
        self.base = base
    }
}
