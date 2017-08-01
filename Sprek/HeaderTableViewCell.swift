//
//  HeaderTableViewCell.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/30/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    
//    var delegate: HeaderViewCellDelegator!
    var For: Int?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        plusButton.tintColor = Colors().primary
//        plusButton.addTarget(self, action: #selector(self.goToNewCardView), for: .touchUpInside)
//        goToNewCardView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func goToNewCardView(){
//        print("hello")
//        self.delegate.callSegueFromCell()
    }

}
