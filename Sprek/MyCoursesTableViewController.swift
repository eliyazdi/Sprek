//
//  MyCoursesTableViewController.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/27/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit
import RealmSwift

class MyCoursesTableViewController: UITableViewController {
    
    var courses: Results<Course>?

    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        courses = realm.objects(Course.self)
        var shortcutItems: [UIApplicationShortcutItem] = []
        for course in (courses?.prefix(3))!{
            let icon = UIApplicationShortcutIcon(type: .favorite)
            let shortcutItem = UIApplicationShortcutItem(type: "openCourse", localizedTitle: course.name, localizedSubtitle: "Strength: 👍", icon: icon)
            shortcutItems.append(shortcutItem)
        }
        let addIcon = UIApplicationShortcutIcon(type: .add)
        let item = UIApplicationShortcutItem(type: "newCourse", localizedTitle: "New Course", localizedSubtitle: "", icon: addIcon)
        shortcutItems.append(item)
        UIApplication.shared.shortcutItems = shortcutItems
        
        
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = Colors().primary
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(openNewCourseView))
        
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courses!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! CourseTableViewCell

        // Configure the cell...
        let course = courses![indexPath.row]
        let lang = Langs().arr.filter { $0.key == course.lang }
        cell.FlagImage.image = UIImage(named: "\(lang[0].flag).png")
        cell.TitleLabel.text = course.name
        cell.StrengthLabel.text = "Strength: 👍"

        return cell
    }
    
    func openNewCourseView(){
        self.performSegue(withIdentifier: "goToSelectLang", sender: self)
    }
 
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            let alert = UIAlertController(title: "Delete course?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
//                let realm = try! Realm()
//                try! realm.write {
//                    realm.delete((self.courses?[indexPath.row])!)
//                }
                (self.courses?[indexPath.row])!.delete()
                self.dismiss(animated: true, completion: nil)
                self.tableView.deleteRows(at: [indexPath], with: .left)
            }))
            self.present(alert, animated: true)
        }
        deleteAction.backgroundColor = UIColor.red
        let editAction = UITableViewRowAction(style: .normal, title: "Edit"){ (rowAction, indexPath) in
            print("Edited")
        }
        editAction.backgroundColor = Colors().dark
        return [deleteAction, editAction]
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cell = sender as? UITableViewCell{
            if segue.identifier == "toUnitsView" {
                if let indexPath = tableView.indexPath(for: cell) {
                    let candy = courses?[indexPath.row]
                    let controller = segue.destination as! UnitsTableViewController
                    controller.course = candy
                    controller.navigationItem.title = candy!.name
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
    }
 

}
