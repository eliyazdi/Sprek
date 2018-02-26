//
//  TTS.swift
//  Sprek
//
//  Created by Eli Yazdi on 8/13/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import Foundation
import AVFoundation

class AudioOrTTS{
    var player: AVAudioPlayer?
    var card: Card
    init(for card: Card){
        self.card = card
    }
    func playTTS(){
        let AppleVoices = AVSpeechSynthesisVoice.speechVoices().filter { $0.language.hasPrefix((self.card.unit?.course?.lang)!) }
        if(self.hasTTS){
            let voice = AppleVoices[0]
            let utterance = AVSpeechUtterance(string: self.card.sentence)
            let speaker = AVSpeechSynthesizer()
            utterance.voice = voice
            speaker.speak(utterance)
        }
    }
    var exists: Bool{
        get{
            return (self.card.audio != nil) || self.hasTTS
        }
    }
    var hasTTS: Bool{
        get{
            let AppleVoices = AVSpeechSynthesisVoice.speechVoices().filter { $0.language.hasPrefix((self.card.unit?.course?.lang)!) }
            return AppleVoices.count > 0
        }
    }
}
