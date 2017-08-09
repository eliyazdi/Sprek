//
//  ViewController.swift
//  Sprek Mac
//
//  Created by Eli Yazdi on 8/2/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import Cocoa
import RealmSwift

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var myCoursesTable: NSTableView!
    @IBOutlet weak var myCoursesScrollView: NSScrollView!
    @IBOutlet weak var streakLabel: NSTextField!
    @IBOutlet weak var touchBarStreakLabel: NSTextField!
    
    var myCourses: Results<Course>?

    override func viewDidLoad() {
        super.viewDidLoad()

        myCoursesTable.dataSource = self
        myCoursesTable.delegate = self
        
        let realm = try! Realm(configuration: MyRealm.config)
        
        myCourses = realm.objects(Course.self)
        
        myCoursesTable.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window!.title = "Sprek"
        self.view.window?.minSize = NSSize(width: 400, height: 300)
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.titleVisibility = .hidden
        self.view.window?.isOpaque = false
        
        self.myCoursesTable.backgroundColor = .clear
        self.myCoursesTable.headerView = nil
        self.myCoursesTable.layer?.borderWidth = 0
        
        self.myCoursesScrollView.backgroundColor = .clear
        self.myCoursesScrollView.drawsBackground = false
        self.myCoursesScrollView.layer?.borderWidth = 0
        
        self.streakLabel.stringValue = "🔥\(Streak.days)"
        
        if #available(OSX 10.12.2, *) {
            self.touchBarStreakLabel.stringValue = "🔥\(Streak.days)"
        } else {
            // Fallback on earlier versions
        }
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if(myCourses == nil){
            return 0
        }else{
            return (myCourses?.count)!
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let course = myCourses?[row]
        let cell = myCoursesTable.make(withIdentifier: "courseCell", owner: self) as! MyCoursesCell
        cell.courseNameLabel.stringValue = (course?.name)!
        let strengthEmoji = Strength(emojiFrom: (course?.strength)!).emoji
        cell.strengthLabel.stringValue = "Strength: \(strengthEmoji!)"
        let lang = Langs().arr.filter { $0.key == course?.lang }
        print(lang[0].flag)
        cell.flagImage.image = NSImage(named: "\(lang[0].flag).png")
        
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 75
    }


}

