//
//  UnitTableViewCell.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/28/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit

class UnitTableViewCell: UITableViewCell {

    @IBOutlet weak var unitNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.backgroundColor = Colors().dark
//        self.layer.cornerRadius = 20.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
