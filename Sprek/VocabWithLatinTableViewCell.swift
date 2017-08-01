//
//  VocabWithLatinTableViewCell.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/30/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit

class VocabWithLatinTableViewCell: CardTableViewCell {

    @IBOutlet weak var targetWordLabel: UILabel!
    @IBOutlet weak var translationWordLabel: UILabel!
    @IBOutlet weak var latinLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var strengthLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        targetWordLabel.text = self.card.sentence
        translationWordLabel.text = self.card.translation
        latinLabel.text = self.card.latin
        strengthLabel.text = Strength(emojiFrom: self.card.strength).emoji
        if(self.card.audio == nil){
//            self.playButton.isHidden = true
            self.playButton.hideView()
            let noAudioConstraint = NSLayoutConstraint(
                item: targetWordLabel,
                attribute: .left,
                relatedBy: .equal,
                toItem: self,
                attribute: .left,
                multiplier: 1,
                constant: 25)
            self.addConstraint(noAudioConstraint)
        }else{
            self.playButton.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
