//
//  TranslationExerciseViewController.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/30/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit

class TranslationExerciseViewController: ExerciseViewController, UITextViewDelegate {

    @IBOutlet weak var inputBox: UITextView!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputBox.delegate = self
        inputBox.layer.borderWidth = 0.25
        inputBox.layer.borderColor = UIColor.lightGray.cgColor
        inputBox.layer.cornerRadius = 5
        inputBox.resignFirstResponder()
        checkButton.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            inputBox.resignFirstResponder()
            return false
        }
        return true
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
