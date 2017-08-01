//
//  StrengthEmoji.swift
//  Sprek
//
//  Created by Eli Yazdi on 8/1/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import Foundation

class Strength{
    var emoji: String?
    convenience init(emojiFrom strength: Int){
        self.init()
        switch strength{
        case 0:
            self.emoji = "👍"
        case 1:
            self.emoji = "😰"
        case 2:
            self.emoji = "☹️"
        case 3:
            self.emoji = "🙂"
        case 4:
            self.emoji = "💪"
        case 5:
            self.emoji = "👌"
        default:
            self.emoji = "👍"
        }
    }
}
