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
    @IBOutlet weak var showLatinButton: UIButton!
    
    private var _showLatin: Bool = false
    
    var showLatin: Bool {
        get{
            return _showLatin
        }
        set{
            _showLatin = newValue
            if(newValue){
                self.sentenceLabel.text = self.card?.latin
                self.showLatinButton.backgroundColor = .primary
                self.showLatinButton.setTitleColor(.white, for: .normal)
            }else{
                self.showLatinButton.backgroundColor = .white
                self.showLatinButton.setTitleColor(.primary, for: .normal)
                self.sentenceLabel.text = self.card?.sentence
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sentenceLabel.numberOfLines = 0
        self.sentenceLabel.lineBreakMode = .byWordWrapping
        self.sentenceLabel.sizeToFit()
        
        inputBox.delegate = self
        inputBox.layer.borderWidth = 0.25
        inputBox.layer.borderColor = UIColor.lightGray.cgColor
        inputBox.layer.cornerRadius = 5
        inputBox.resignFirstResponder()
        checkButton.layer.cornerRadius = 20
        
        checkButton.addTarget(self, action: #selector(checkAnswer), for: .touchUpInside)
        
        self.showLatinButton.addTarget(self, action: #selector(toggleLatin), for: .touchUpInside)
        self.showLatinButton.layer.cornerRadius = 10
        self.showLatinButton.layer.borderColor = UIColor.primary.cgColor
        self.showLatinButton.layer.borderWidth = 0.75
        
        self.reversed = self.randomBool()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.delegate?.setInstructions("Translate this text")
        self.sentenceLabel.text = self.reversed ? self.card?.translation : self.card?.sentence
        
        if(((self.card?.latin?.count)! > 0) && self.reversed == false){
            self.showLatinButton.isHidden = false
        }else{
            self.showLatinButton.isHidden = true
        }
        
        if(self.card?.audio == nil || self.reversed){
            self.playButton.isHidden = true
        }else if(self.card?.audio != nil && self.reversed == false){
            self.playAudio()
            self.playButton.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleLatin(){
        self.showLatin = !_showLatin
    }
    
    func checkAnswer(){
        let comp1 = self.reversed ? (self.card?.sentence)!.lowercased().folding(options: .diacriticInsensitive, locale: .current) : (self.card?.translation)!.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        let comp2 = self.inputBox.text.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        let dist = Levenshtein.levDis(comp1, comp2)
        if(dist <= 3){
            self.card?.answer(isCorrect: true)
            self.delegate?.answered(correctly: true, correctAnswer: nil)
        }else{
            self.card?.answer(isCorrect: false)
            self.delegate?.answered(correctly: false, correctAnswer: self.reversed ? self.card?.sentence : self.card?.translation)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            self.checkAnswer()
            textView.resignFirstResponder()
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
