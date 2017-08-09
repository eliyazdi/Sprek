//
//  MyCoursesCell.swift
//  Sprek
//
//  Created by Eli Yazdi on 8/9/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import Cocoa

class MyCoursesCell: NSTableCellView {

    @IBOutlet weak var flagImage: NSImageView!
    @IBOutlet weak var courseNameLabel: NSTextField!
    @IBOutlet weak var strengthLabel: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
