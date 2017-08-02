//
//  UnitsTableViewController.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/28/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit
import RealmSwift

class UnitsTableViewController: UITableViewController {
    
    var course: Course?
    var units: Results<Unit>?

    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        units = realm.objects(Unit.self).filter("course == %@", course!)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(newUnit))
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
        return (units?.count)!
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            let alert = UIAlertController(title: "Delete course?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
                (self.units?[indexPath.row])!.delete()
                self.dismiss(animated: true, completion: nil)
                self.tableView.deleteRows(at: [indexPath], with: .left)
            }))
            self.present(alert, animated: true)
        }
        deleteAction.backgroundColor = UIColor.red
        let editAction = UITableViewRowAction(style: .normal, title: "Rename"){ (rowAction, indexPath) in
            let alert = UIAlertController(title: "Rename Unit", message: "", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = self.units?[indexPath.row].name
                textField.autocapitalizationType = .words
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                let realm = try! Realm()
                try! realm.write {
                    self.units?[indexPath.row].name = (textField?.text)!
                }
                self.tableView.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        editAction.backgroundColor = Colors().dark
        return [deleteAction, editAction]
    }
    
    func newUnit(){
        let alert = UIAlertController(title: "New Unit", message: "Create a new unit", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Unit name"
            textField.autocapitalizationType = .words
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let newUnit = Unit()
            newUnit.name = (textField?.text)!
            newUnit.course = self.course
            let realm = try! Realm()
            try! realm.write {
                realm.add(newUnit)
            }
            self.tableView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unitCell", for: indexPath) as! UnitTableViewCell

        // Configure the cell...
        let unit = units![indexPath.row]
        cell.unitNameLabel.text = unit.name
        let strength = Strength(emojiFrom: unit.getStrength()).emoji
        cell.strengthLabel.text = strength!
        
        return cell
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
        let cell = sender as! UITableViewCell
        if (segue.identifier == "goToUnit"){
            if let indexPath = tableView.indexPath(for: cell) {
                let candy = self.units?[indexPath.row]
                
                let controller = segue.destination as! UnitTableViewController
                controller.navigationItem.title = candy?.name
                controller.unit = candy
            }
        }
    }
    

}
