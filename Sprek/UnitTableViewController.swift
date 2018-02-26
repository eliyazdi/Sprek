//
//  UnitTableViewController.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/30/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit
import RealmSwift

class UnitTableViewController: UITableViewController {
    
    var unit: Unit?

    var data = [Results<Card>]()
    var vocabData: Results<Card>?
    var sentenceData: Results<Card>?
    let headers = ["Vocab", "Sentences"]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.loadData()
        let realm = try! Realm(configuration: MyRealm.config)
        data = [
            realm.objects(Card.self).filter("isSentence == false && unit == %@", unit!),
            realm.objects(Card.self).filter("isSentence == true && unit == %@", unit!)
        ]
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(studySession))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadData(){
        let realm = try! Realm(configuration: MyRealm.config)
        self.vocabData = realm.objects(Card.self).filter("isSentence == false && unit == %@", unit!)
        self.sentenceData = realm.objects(Card.self).filter("isSentence == true && unit == %@", unit!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.loadData() 
        self.tableView.reloadData()
    }
    
    
    @objc func studySession(){
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "sessionViewController") as! SessionViewController
        newVC.unit = self.unit
        self.present(newVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
//        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
//            let alert = UIAlertController(title: "Delete card?", message: "", preferredStyle: .alert)
//            alert.addAction(
//                UIAlertAction(
//                    title: "Cancel",
//                    style: .cancel) { (_) in
//                        self.dismiss(animated: true, completion: nil)
//            })
//            alert.addAction(
//                UIAlertAction(
//                    title: "Delete",
//                    style: .destructive) { (_) in
//                        let realm = try! Realm(configuration: MyRealm.config)
//                        try! realm.write {
//                            realm.delete(self.data[indexPath.section][indexPath.row])
//                        }
//                        DispatchQueue.main.async {
//                            self.data = [
//                                realm.objects(Card.self).filter("isSentence == false && unit == %@", self.unit!),
//                                realm.objects(Card.self).filter("isSentence == true && unit == %@", self.unit!)
//                            ]
//                            self.tableView.reloadData()
//                            self.tableView.deleteRows(at: [indexPath], with: .left)
//                        }
//
//            })
//            self.present(alert, animated: true)
//        }
//        deleteAction.backgroundColor = UIColor.red
        let editAction = UITableViewRowAction(style: .normal, title: "Edit"){ (rowAction, indexPath) in
            //TODO: Fix this
            let card: Card = self.data[indexPath.section][indexPath.row]
            let editVC = self.storyboard?.instantiateViewController(withIdentifier: "newCardView") as! NewCardViewController
            editVC.forEditing = true
            editVC.editCard = card
            editVC.forSentence = card.isSentence
            editVC.audio = card.audio
            self.navigationController?.pushViewController(editVC, animated: true)
        }
        editAction.backgroundColor = Colors().dark
        return [editAction]
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = [
            tableView.dequeueReusableCell(withIdentifier: "vocabHeaderCell") as! HeaderTableViewCell,
            tableView.dequeueReusableCell(withIdentifier: "sentencesHeaderCell")
            ]
        
        return headerCell[section]?.contentView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        if(data[section].count == 0){
//            return 1
//        }
        return data[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CardTableViewCell
        let card = self.data[indexPath.section][indexPath.row]
        if(card.isSentence == false){
            cell = tableView.dequeueReusableCell(withIdentifier: "vocabCellWithLatin", for: indexPath) as! VocabWithLatinTableViewCell
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "sentenceCell", for: indexPath) as! SentenceTableViewCell
        }
        cell.card = card
 
        // Configure the cell...
//        cell = tableView.dequeueReusableCell(withIdentifier: "vocabCell", for: indexPath)
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
        if(segue.identifier == "newVocabCard"){
            let newCardView = segue.destination as! NewCardViewController
            newCardView.forSentence = false
            newCardView.unit = self.unit
        }else if(segue.identifier == "newSentenceCard"){
            let newCardView = segue.destination as! NewCardViewController
            newCardView.forSentence = true
            newCardView.unit = self.unit
        }else if(segue.identifier == "beginSessionWithUnit"){
            let sessionView = segue.destination as! SessionViewController
            sessionView.unit = self.unit
        }
    }
    

}

//protocol HeaderViewCellDelegator {
//    func callSegueFromCell()
//}
