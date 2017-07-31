//
//  LangCell.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/21/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit

class LangCell: UITableViewCell {

    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var langNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
