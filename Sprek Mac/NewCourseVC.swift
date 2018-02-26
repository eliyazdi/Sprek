//
//  NewCourseVC.swift
//  Sprek
//
//  Created by Eli Yazdi on 8/26/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import Cocoa

class NewCourseVC: NSViewController {

    @IBOutlet weak var cancelButton: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.window?.styleMask.remove(.resizable)
        let oldFrame = self.view.window?.frame
        print(oldFrame)
        let newSize = CGSize(width: (oldFrame?.width)!, height: 100)
        let newFrame = NSRect(origin: (oldFrame?.origin)!, size: newSize)
        self.view.window?.setFrame(newFrame, display: true, animate: false)
        self.cancelButton.action = #selector(closeWindow)
        // Do view setup here.
    }
    
    func closeWindow(){
        self.dismiss(nil)
    }
    
}
