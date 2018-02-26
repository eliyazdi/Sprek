//
//  NoCardsViewController.swift
//  Sprek
//
//  Created by Eli Yazdi on 8/6/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit

class NoCardsViewController: UIViewController {

    @IBOutlet weak var okButton: UIButton!
    
    var delegate: ExerciseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello")
        self.okButton.layer.cornerRadius = 20
        self.okButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.delegate?.setInstructions("")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func done(){
        self.delegate?.dismissSession()
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
