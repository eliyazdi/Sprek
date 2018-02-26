//
//  MainSplitVC.swift
//  Sprek
//
//  Created by Eli Yazdi on 8/25/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import Cocoa

class MainSplitVC: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let selectCourseVC = self.splitViewItem(for: self.storyboard?.instantiateController(withIdentifier: "SelectCourseVC") as! NSViewController)
        let unitsVC = self.splitViewItem(for: self.storyboard?.instantiateController(withIdentifier: "UnitsVC") as! NSViewController)
        unitsVC?.isCollapsed = false
        selectCourseVC?.isCollapsed = true
    }
    
}
