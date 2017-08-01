//
//  SentenceTableViewCell.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/30/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit

class SentenceTableViewCell: CardTableViewCell {

    @IBOutlet weak var targetSentenceLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var strengthLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        targetSentenceLabel.text = self.card.sentence
        strengthLabel.text = Strength(emojiFrom: self.card.strength).emoji
        if(self.card.audio == nil){
            self.playButton.isHidden = true
        }else{
            self.playButton.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
