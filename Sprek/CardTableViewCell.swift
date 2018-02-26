//
//  CardTableViewCell.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/30/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit
import AVFoundation

class CardTableViewCell: UITableViewCell {

    var audioPlayer: AVAudioPlayer!
    var card = Card()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func playAudio(){
        if(self.card.audio != nil){
            self.audioPlayer = try! AVAudioPlayer(data: (self.card.audio)!)
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
        }else if(AudioOrTTS(for: self.card).hasTTS){
            AudioOrTTS(for: self.card).playTTS()
        }
    }

}
