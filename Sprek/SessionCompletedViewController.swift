//
//  SessionCompletedViewController.swift
//  Sprek
//
//  Created by Eli Yazdi on 8/6/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit

class SessionCompletedViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var streakLabel: UILabel!
    
    var delegate: ExerciseDelegate?
    var points: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton.layer.cornerRadius = 20
        self.doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.delegate?.setInstructions("")
        if(points != nil){
            let pointString = String(describing: points!)
            pointsLabel.text = "🏆 +\(pointString) points"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func done(){
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
