//
//  ViewController.swift
//  Sprek Mac
//
//  Created by Eli Yazdi on 8/2/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window!.title = "Sprek"
        self.view.window?.minSize = NSSize(width: 400, height: 300)
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.titleVisibility = .hidden
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

