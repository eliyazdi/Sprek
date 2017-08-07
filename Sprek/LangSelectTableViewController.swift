//
//  LangSelectTableViewController.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/21/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit

class LangSelectTableViewController: UITableViewController, UISearchBarDelegate {

    var langs = [Lang]()
    var filteredLangs = [Lang]()
    let searchController = UISearchController(searchResultsController: nil)
    
    var delegate: SelectLangDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        langs = Langs().arr
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.tabBarController?.tabBar.isHidden = true
        
        searchController.searchBar.barTintColor = Colors().primary
        searchController.searchBar.isTranslucent = true
        searchController.searchBar.layer.borderWidth = 1.0
        searchController.searchBar.layer.borderColor = Colors().primary.cgColor
        searchController.searchBar.tintColor = UIColor.white
        
        searchController.searchBar.searchBarStyle = .default
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        automaticallyAdjustsScrollViewInsets = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredLangs = langs.filter { lang in
            return (lang.name.lowercased().contains(searchText.lowercased()) || lang.nativeName.lowercased().contains(searchText.lowercased()))
        }
        
        tableView.reloadData()
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
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredLangs.count
        }
        return langs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LangCell", for: indexPath) as! LangCell

//         Configure the cell...
        let lang: Lang
        if searchController.isActive && searchController.searchBar.text != "" {
            lang = filteredLangs[indexPath.row]
        } else {
            lang = langs[indexPath.row]
        }
        
        cell.langNameLabel.text = lang.name
        cell.flagImage.image = UIImage(named: "\(lang.flag).png")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectLang(langs[indexPath.row].key)
        self.navigationController?.popViewController(animated: true)
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
        if segue.identifier == "selectLang" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let candy: Lang
                if searchController.isActive && searchController.searchBar.text != "" {
                    candy = filteredLangs[indexPath.row]
                } else {
                    candy = langs[indexPath.row]
                }
                
                let controller = segue.destination as! NewCourseViewController
                controller.lang = candy.key
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
 

}

extension LangSelectTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}



