//
//  NewCourseViewController.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/19/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit
import RealmSwift

class NewCourseViewController: UITableViewController, SelectLangDelegate {

    @IBOutlet weak var langIcon: UIImageView!
    @IBOutlet weak var langLabel: UILabel!
    
    @IBOutlet weak var courseNameField: UITextField!
    
    var lang: String = ""
    
    var forEditing: Bool? = false
    var editCourse: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.i
        self.courseNameField.layer.borderWidth = 0
        if (self.lang != ""){
            let theLang = Langs().arr.filter { $0.key == self.lang }
            langLabel.text = theLang[0].name
            langLabel.textColor = UIColor.black
            langIcon.image = UIImage(named: "\(theLang[0].flag).png")
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addCourse))
        
        if(forEditing! && editCourse != nil){
            self.navigationItem.title = "Edit Course"
            self.courseNameField.text = editCourse?.name
            self.lang = (editCourse?.lang)!
            let theLang = Langs().arr.filter { $0.key == self.lang }
            langLabel.text = theLang[0].name
            langLabel.textColor = UIColor.black
            langIcon.image = UIImage(named: "\(theLang[0].flag).png")
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneEditing))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addCourse(){
        if(self.courseNameField.text == "" || self.lang == ""){
            let alert = UIAlertController(title: "Fields incomplete", message: "Complete all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            let myCourse = Course()
            myCourse.name = courseNameField.text!
            myCourse.lang = self.lang
            
            let realm = try! Realm(configuration: MyRealm.config)
            
            try! realm.write{
                realm.add(myCourse)
            }
            
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func doneEditing(){
        if(self.courseNameField.text == "" || self.lang == ""){
            let alert = UIAlertController(title: "Fields incomplete", message: "Complete all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            let realm = try! Realm(configuration: MyRealm.config)
            
            try! realm.write{
                self.editCourse?.name = self.courseNameField.text!
                self.editCourse?.lang = self.lang
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func selectLang(_ lang: String) {
        self.lang = lang
        if (self.lang != ""){
            let theLang = Langs().arr.filter { $0.key == self.lang }
            langLabel.text = theLang[0].name
            langLabel.textColor = UIColor.black
            langIcon.image = UIImage(named: "\(theLang[0].flag).png")
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "selectLang"){
            let newVC = segue.destination as! LangSelectTableViewController
            newVC.delegate = self
        }
    }
    

}

protocol SelectLangDelegate: class{
    func selectLang(_ lang: String)
}
