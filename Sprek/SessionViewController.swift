//
//  SessionViewController.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/30/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class SessionViewController: UIViewController, ExerciseDelegate {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var sessionProgress: UIProgressView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var unit: Unit?
    var course: Course?
    var completedCards: Int = 0
    var correctCards: Int = 0
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCards()
        
        
//        let translationView = self.storyboard?.instantiateViewController(withIdentifier: "translationView") as! TranslationExerciseViewController
//        self.addChildViewController(translationView)
//        translationView.view.frame = containerView.bounds
//        translationView.delegate = self
//        containerView.addSubview((translationView.view)!)
        
        // Do any additional setup after loading the view.
        UIApplication.shared.isStatusBarHidden = true
        self.closeButton.setImage(UIImage(named: "stop")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.closeButton.tintColor = .primary
        self.closeButton.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        self.sessionProgress.clipsToBounds = true
        self.sessionProgress.transform = sessionProgress.transform.scaledBy(x: 1, y: 2)
        self.sessionProgress.progressTintColor = Colors().dark
        self.sessionProgress.trackTintColor = .lightGray
//        self.sessionProgress.layer.borderColor = Colors().primary.cgColor
//        self.sessionProgress.layer.borderWidth = 0.25
        self.sessionProgress.layer.cornerRadius = 3
        self.correctAnswerLabel.layer.cornerRadius = 10
        self.correctAnswerLabel.numberOfLines = 3
        self.correctAnswerLabel.lineBreakMode = .byWordWrapping
        self.correctAnswerLabel.sizeToFit()
    }
    
    func loadCards(){
        let realm = try! Realm()
        let myCardsRLM = realm.objects(Card.self)
            .filter("nextPractice <= %@ AND unit == %@", Date(), self.unit!)
            .sorted(byKeyPath: "nextPractice", ascending: false)
        
        var myCards = Array(myCardsRLM)
            .prefix(10 - completedCards)
        
        myCards.shuffle()
        
        let added = Float(myCards.count + correctCards)
        
        let divved = Float(correctCards)/added
        
        if (correctCards == 0 && added == 0){
            self.sessionProgress.setProgress(
                0,
                animated: true)
        }else{
            self.sessionProgress.setProgress(
                divved,
                animated: true)
        }
        
        
        
        for subview in containerView.subviews{
            subview.removeFromSuperview()
        }
        
        if(myCards.count == 0 && completedCards == 0){
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "sessionCompleted") as! SessionCompletedViewController
            self.addChildViewController(newVC)
            newVC.view.frame = containerView.bounds
            newVC.delegate = self
            newVC.mainLabel.text = "No cards due"
            newVC.subLabel.text = ""
            newVC.streakLabel.text = ""
            newVC.pointsLabel.text = ""
            containerView.addSubview(newVC.view)
        }else if(myCards.count == 0 && completedCards > 0){
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "sessionCompleted") as! SessionCompletedViewController
            self.addChildViewController(newVC)
            newVC.view.frame = containerView.bounds
            newVC.delegate = self
            newVC.points = self.correctCards
            containerView.addSubview(newVC.view)
        }else{
            let newCard = myCards[0]
            var newVC: ExerciseViewController
            if(newCard.isSentence){
                newVC = self.storyboard?.instantiateViewController(withIdentifier: "translationView") as! ExerciseViewController
            }else{
                newVC = self.storyboard?.instantiateViewController(withIdentifier: "vocabView") as! ExerciseViewController
            }
            newVC.view.frame = containerView.bounds
            newVC.delegate = self
            newVC.card = newCard
            self.addChildViewController(newVC)
            containerView.addSubview((newVC.view)!)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func popBack(){
        let alert = UIAlertController(title: "End Session?", message: "Are you sure you want to end this study session?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        }))
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            UIApplication.shared.isStatusBarHidden = false
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    func answered(correctly correct: Bool, correctAnswer: String?) {
        showAnswer(correct: correct)
        self.completedCards += 1
        if(correct){
            self.correctCards += 1
            let dingURL = Bundle.main.url(forResource: "chime_done", withExtension: "wav")
            self.player = try! AVAudioPlayer(contentsOf: dingURL!)
            self.player?.volume = 1.0
            self.player?.play()
        }else{
            let zapURL = Bundle.main.url(forResource: "zap_down_quick", withExtension: "wav")
            self.player = try! AVAudioPlayer(contentsOf: zapURL!)
            self.player?.volume = 1.0
            self.player?.play()
        }
        if(correctAnswer != nil){
            self.showCorrectAnswer(correctAnswer!)
        }
        self.loadCards()
    }
    
    func setInstructions(_ instructions: String) {
        self.instructionsLabel.text = instructions
    }
    
    func dismissSession() {
        UIApplication.shared.isStatusBarHidden = false
        self.dismiss(animated: true)
    }
    
    enum AnswerType{
        case correct
        case incorrect
        case almost
    }
    
    func showAnswer(correct: Bool){
        let correctLabel = ["👌", "👍", "💯", "💪"].randomItem()
        let incorrectLabel = ["👎", "😣", "😢"].randomItem()
        switch correct{
            case true:
                answerLabel.text = correctLabel
            case false:
                answerLabel.text = incorrectLabel
        }
        answerLabel.isHidden = false
        answerLabel.alpha = 1.0
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.answerLabel.alpha = 0.0
        })
    }
    
    func showCorrectAnswer(_ answer: String){
        correctAnswerLabel.text = answer
        correctAnswerLabel.alpha = 1.0
        UIView.animate(withDuration: 4.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.correctAnswerLabel.alpha = 0.0
        })
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

protocol ExerciseDelegate: class{
    func setInstructions(_ instructions: String)
    func answered(correctly correct: Bool, correctAnswer: String?)
    func dismissSession()
}

extension Array {
    /// Get random item from array
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
