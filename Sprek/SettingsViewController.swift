//
//  SettingsViewController.swift
//  Sprek
//
//  Created by Eli Yazdi on 8/7/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsViewController: UITableViewController {
    
    var rows: [[String]] = []
    var headers: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        rows = [
            ["loginCell", "signupCell"],
            ["infoCell"]
        ]
        headers = ["Sync (Beta)", "Info"]
//        if(SyncUser.current == nil){
//            
//        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(SyncUser.current != nil){
            rows = [
                ["signoutCell"],
                ["infoCell"]
            ]
        }else{
            rows = [
                ["loginCell", "signupCell"],
                ["infoCell"]
            ]
        }
        
        self.tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rows[indexPath.section][indexPath.row], for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 1){
            return 100
        }
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(rows[indexPath.section][indexPath.row] == "signoutCell"){
//            MyRealm.copyFromSyncedRealm()
            SyncUser.current?.logOut()
            rows = [
                ["loginCell", "signupCell"],
                ["infoCell"]
            ]
            self.tableView.reloadData()
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
