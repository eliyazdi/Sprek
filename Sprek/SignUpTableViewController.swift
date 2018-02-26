//
//  SignUpTableViewController.swift
//  Sprek
//
//  Created by Eli Yazdi on 8/7/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit
import RealmSwift

class SignUpTableViewController: UITableViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func signUp(){
        if(usernameField.text == "" || passwordField.text == "" || passwordConfirm.text == ""){
            let alert = UIAlertController(title: "Error", message: "Complete all required fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { void in
                
            }))
            self.present(alert, animated: true)
        }else if(passwordField.text != passwordConfirm.text){
            let alert = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { void in
                
            }))
            self.present(alert, animated: true)
        }else{
            signUpButton.setTitle("Loading...", for: .normal)
            let usernameCredentials = SyncCredentials.usernamePassword(username: usernameField.text!, password: passwordField.text!, register: true)
            let serverURL = URL(string: "http://45.55.220.254:9080")
            SyncUser.logIn(with: usernameCredentials, server: serverURL!){ user, error in
                DispatchQueue.main.async {
                    if let error = error{
                        self.signUpButton.setTitle("Sign up", for: .normal)
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { void in
                            
                        }))
                        self.present(alert, animated: true)
                    }else if user != nil{
                        print("signed in")
                        MyRealm.copyToSyncedRealm()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
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
