//
//  TranslationExerciseViewController.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/30/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit
//import Regex
import RealmSwift

class TranslationExerciseViewController: ExerciseViewController, UITextViewDelegate{

    @IBOutlet weak var inputBox: UITextView!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var showLatinButton: UIButton!
//    @IBOutlet weak var sentenceCollection: UICollectionView!
    
//    let backwardsCheck = Regex("[\u{0600}-\u{06FF}\u{0590}-\u{05FF}\u{0700}-\u{074F}\u{0780}-\u{07BF}\u{0800}-\u{083F}\u{0840}-\u{085F}]")
    
    var sentenceData: [String] = []
//    var popup: DefinitionsTableViewController?
    
    private var _showLatin: Bool = false
    
    
    var showLatin: Bool {
        get{
            return _showLatin
        }
        set{
            _showLatin = newValue
            if(newValue){
                self.loadSentence(.latin)
                self.showLatinButton.backgroundColor = .primary
                self.showLatinButton.setTitleColor(.white, for: .normal)
            }else{
                self.showLatinButton.backgroundColor = .white
                self.showLatinButton.setTitleColor(.primary, for: .normal)
                self.loadSentence(.sentence)
            }
        }
    }
    
    enum showType{
        case sentence
        case translation
        case latin
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.sentenceLabel.numberOfLines = 0
//        self.sentenceLabel.lineBreakMode = .byWordWrapping
//        self.sentenceLabel.sizeToFit()
        
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
        self.showLatinButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.reversed = self.randomBool()
        
//        sentenceCollection.delegate = self
//        sentenceCollection.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.delegate?.setInstructions("Translate this text")
        
        if(self.reversed){
            self.loadSentence(.translation)
        }else{
            self.loadSentence(.sentence)
        }
        
        if(((self.card?.latin?.count)! > 0) && self.reversed == false){
            self.showLatinButton.isHidden = false
        }else{
            self.showLatinButton.isHidden = true
        }
        
        if(!AudioOrTTS(for: self.card!).exists || self.reversed){
            self.playButton.isHidden = true
            self.playButton.removeFromSuperview()
            self.view.addConstraint(NSLayoutConstraint(item: self.sentenceLabel, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 20))
        }else{
            self.playButton.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
            self.playAudio()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func toggleLatin(){
        self.showLatin = !_showLatin
    }
    
    override func checkAnswer(){
        // Fix all of this
        let comp1 = (self.reversed ? (self.card?.sentence)!.lowercased().folding(options: .diacriticInsensitive, locale: .current) : (self.card?.translation)!.lowercased().folding(options: .diacriticInsensitive, locale: .current)).removingCharacters(inCharacterSet: .punctuationCharacters)
        let comp2 = self.inputBox.text.lowercased().folding(options: .diacriticInsensitive, locale: .current).removingCharacters(inCharacterSet: .punctuationCharacters)
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sentenceData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "word", for: indexPath) as! SentenceWordCollectionViewCell
        let word = self.sentenceData[indexPath.item]
        cell.label.text = word
//        if(getWordTranslations(word: word).count > 0){
//            cell.label.attributedText = NSAttributedString(string: word, attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleThick.rawValue])
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if(getWordTranslations(word: sentenceData[indexPath.item]).count > 0){
//            return self.sentenceData[indexPath.item].size(attributes:[
//                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
//                NSUnderlineStyleAttributeName: NSUnderlineStyle.styleThick.rawValue
//            ])
//        }
        return self.sentenceData[indexPath.item].size(attributes:[NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)]
        )
    }
    
    func getWordTranslations(word: String) -> Results<Card>{
        let type: String
        if(self.reversed){
            type = "translation"
        }else if(self.showLatin){
            type = "latin"
        }else{
            type = "sentence"
        }
        let realm = try! Realm(configuration: MyRealm.config)
        return realm.objects(Card.self).filter("isSentence == false AND unit.course == %@ AND \(type) LIKE[c] %@", (self.card?.unit?.course)!, word)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(self.popup != nil){
            self.popup?.view.removeFromSuperview()
            self.popup?.removeFromParentViewController()
        }
        let cell = self.sentenceCollection.cellForItem(at: indexPath)
        let location = cell?.frame
        let word = self.sentenceData[indexPath.item].removingCharacters(inCharacterSet: .punctuationCharacters)
        
        let defs = getWordTranslations(word: word)
        
        if(defs.count > 0){
            self.popup = self.storyboard?.instantiateViewController(withIdentifier: "definitionTable") as? DefinitionsTableViewController
            popup?.defs = defs
            popup?.word = word
            popup?.course = self.card?.unit?.course
            popup?.type = self.reversed ? "translation" : "sentence"
            
            var wide: CGFloat
            
            if(self.reversed){
                wide = defs[0].translation.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)]).width
            }else{
                wide = defs[0].sentence.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)]).width
            }
            wide += 80
            
            popup?.view.frame = CGRect(x: Int((location?.origin.x)! + 50), y: (Int((location?.maxY)! + 15)), width: Int(wide), height: (defs.count * 30))
//            popup?.view.center.x = ((location?.maxX)! + 20)
            
//            popup?.view.layer.borderColor = UIColor.lightGray.cgColor
//            popup?.view.layer.borderWidth = 1.0
            popup?.view.layer.cornerRadius = 20
            
            
            popup?.view.dropShadow()
            
            self.addChildViewController(popup!)
            
            self.view.addSubview((popup?.view)!)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.popup != nil){
            self.popup?.view.removeFromSuperview()
            self.popup?.removeFromParentViewController()
        }
    }
    */
    func loadSentence(_ type: showType){
        let sentence: String
//        let data: [String]
        switch type{
        case .sentence:
            sentence = (self.card?.sentence)!
        case .translation:
            sentence = (self.card?.translation)!
        case .latin:
            sentence = (self.card?.latin)!
        }
        self.sentenceLabel.text = sentence
//        if(backwardsCheck.matches(sentence)){
//            data = sentence.components(separatedBy: " ").reversed()
//        }else{
//            data = sentence.components(separatedBy: " ")
//        }
//        self.sentenceData = data
//        self.sentenceCollection.reloadData()
//        self.sentenceCollection.translatesAutoresizingMaskIntoConstraints = true
//        self.sentenceCollection.frame.size.height = self.sentenceCollection.collectionViewLayout.collectionViewContentSize.height
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

extension String {
    func removingCharacters(inCharacterSet forbiddenCharacters:CharacterSet) -> String{
        var filteredString = self
        while true {
            if let forbiddenCharRange = filteredString.rangeOfCharacter(from: forbiddenCharacters)  {
                filteredString.removeSubrange(forbiddenCharRange)
            }
            else {
                break
            }
        }
        
        return filteredString
    }
}

extension UIView {
    
    func dropShadow(scale: Bool = true) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
