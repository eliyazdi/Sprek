//
//  MyCoursesViewController.swift
//  Sprek
//
//  Created by Eli Yazdi on 8/17/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit
//import GoogleMobileAds
import RealmSwift

class MyCoursesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var coursesTable: UITableView!
    @IBOutlet weak var adBox: UIView!
    
    
    var courses: Results<Course>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coursesTable.delegate = self
        coursesTable.dataSource = self
        
        let realm = try! Realm(configuration: MyRealm.config)
        courses = realm.objects(Course.self)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .primary
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
//        let adView = GADBannerView()
//        adView.adUnitID = Keys.MainBannerAdUnit
//        adView.rootViewController = self
//        let request = URLRequest()
//        request.testDevices = Keys.AdTestDevices
//        adView.load(request)
//        adView.frame = adBox.frame
//        adBox.addSubview(adView)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm(configuration: MyRealm.config)
        courses = realm.objects(Course.self)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "🔥\(Streak.days)",
            style: .plain,
            target: self,
            action: #selector(openActivities))
        self.coursesTable.reloadData()
    }
    
    @objc func openActivities(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courses!.count
    }
    
    //    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 20
    //    }
    //
    //    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "seperatorCell")
    //        return cell?.contentView
    //    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! CourseTableViewCell
        
        // Configure the cell...
        let course = courses![indexPath.row]
        let lang = Langs().arr.filter { $0.key == course.lang }
        if(lang.count > 0){
            cell.FlagImage.image = UIImage(named: "\(lang[0].flag).png")
        }
        cell.TitleLabel.text = course.name
        let strength = Strength(emojiFrom: course.strength).emoji
        cell.StrengthLabel.text = "Strength: \(strength!)"
        //        cell.layer.cornerRadius = 20
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            
            let alert = UIAlertController(
                title: "Delete course?",
                message: "",
                preferredStyle: .alert)
            
            alert.addAction(
                UIAlertAction(
                    title: "Cancel",
                    style: .cancel) { (_) in
                        self.dismiss(animated: true, completion: nil)
                })
            alert.addAction(
                UIAlertAction(
                    title: "Delete",
                    style: .destructive) { (_) in
                        //                let realm = try! Realm()
                        //                try! realm.write {
                        //                    realm.delete((self.courses?[indexPath.row])!)
                        //                }
                        (self.courses?[indexPath.row])!.delete()
                        self.dismiss(animated: true, completion: nil)
                        self.coursesTable.deleteRows(at: [indexPath], with: .left)
                })
            self.present(alert, animated: true)
        }
        deleteAction.backgroundColor = .red
        
        let editAction = UITableViewRowAction(
            style: .normal,
            title: "Edit"){ (rowAction, indexPath) in
                let editVC = self.storyboard?.instantiateViewController(withIdentifier: "editCourseVC") as! NewCourseViewController
                editVC.forEditing = true
                editVC.editCourse = self.courses?[indexPath.row]
                self.navigationController?.pushViewController(editVC, animated: true)
        }
        editAction.backgroundColor = .dark
        
        return [deleteAction, editAction]
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cell = sender as? UITableViewCell{
            if segue.identifier == "toUnitsView" {
                if let indexPath = self.coursesTable.indexPath(for: cell) {
                    let candy = courses?[indexPath.row]
                    let controller = segue.destination as! UnitsViewController
                    controller.course = candy
                    controller.navigationItem.title = candy!.name
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
    }
 

}
