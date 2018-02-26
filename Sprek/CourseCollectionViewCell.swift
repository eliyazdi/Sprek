//
//  CourseCollectionViewCell.swift
//  Sprek
//
//  Created by Eli Yazdi on 8/17/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit

class CourseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var FlagImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    override func awakeFromNib() {
        self.layer.cornerRadius = 20
        self.layer.borderColor = UIColor.dark.cgColor
        self.layer.borderWidth = 1.5
    }
    
}
