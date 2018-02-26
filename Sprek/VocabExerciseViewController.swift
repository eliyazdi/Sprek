//
//  VocabExerciseViewController.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/30/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit
import RealmSwift

class VocabExerciseViewController: ExerciseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var wordCollection: UICollectionView!
    @IBOutlet weak var checkButton: UIButton!
    
    var wordsList: ArraySlice<Card> = []
    var selectedWord: Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordCollection.delegate = self
        wordCollection.dataSource = self
        wordCollection.allowsMultipleSelection = false
        // Do any additional setup after loading the view.
        checkButton.layer.cornerRadius = 20
        checkButton.addTarget(self, action: #selector(checkAnswer), for: .touchUpInside)
        self.reversed = self.randomBool()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.wordLabel.text = self.reversed ? self.card?.translation : self.card?.sentence
        self.delegate?.setInstructions("Select the correct translation")
        
        let realm = try! Realm(configuration: MyRealm.config)
        let results = realm.objects(Card.self)
            .filter("isSentence == false AND unit.course == %@ AND sentence != %@", (self.card?.unit?.course)!, (self.card?.sentence)!)
        var shuffledWords = Array(results).prefix(5)
        shuffledWords.append(self.card!)
        shuffledWords.shuffle()
        self.wordsList = shuffledWords
        self.wordCollection.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wordsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wordCell", for: indexPath) as! WordsCollectionViewCell
        cell.wordLabel.text = self.reversed ? wordsList[indexPath.row].sentence : wordsList[indexPath.row].translation
        cell.card = self.card
        cell.layer.borderColor = UIColor.primary.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 5
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! WordsCollectionViewCell
        cell.layer.borderColor = UIColor.dark.cgColor
        cell.layer.borderWidth = 1.24
        self.checkButton.backgroundColor = .dark
        self.checkButton.isEnabled = true
        
        self.selectedWord = wordsList[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! WordsCollectionViewCell
        cell.layer.borderColor = UIColor.primary.cgColor
        cell.layer.borderWidth = 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let str: String = self.reversed ? wordsList[indexPath.item].sentence : wordsList[indexPath.item].translation
//        var size = str.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17)])
//        size.height += 10
//        size.width += 20
        let size = CGSize(width: (self.wordCollection.frame.width - 10), height: 40)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 5)
    }
    
    override func checkAnswer(){
        if(selectedWord == self.card){
            self.card?.answer(isCorrect: true)
            self.delegate?.answered(correctly: true, correctAnswer: nil)
        }else{
            self.card?.answer(isCorrect: false)
            self.delegate?.answered(correctly: false, correctAnswer: (self.reversed ? self.card?.sentence : self.card?.translation))
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

extension Results {
    /// Returns shuffled array
    public func toShuffledArray<T>(ofType: T.Type) -> [T] {
        
        var array = [T]()
        
        for result in self {
            if let result = result as? T {
                array.append(result)
            }
        }
        
        let count = array.count
        
        if count > 1 {
            for i in 0..<(count - 1) {
                let j = Int(arc4random_uniform(UInt32(count - i))) + Int(i)
                array.swapAt(i, j)
            }
        }
        
        return array
    }
}

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            if(firstUnshuffled != i){
                self.swapAt(firstUnshuffled, i)
            }
        }
    }
}
