//
//  SessionViewController.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/30/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit
import RealmSwift

class SessionViewController: UIViewController, ExerciseDelegate {

    @IBOutlet weak var sessionProgress: UIProgressView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var unit: Unit?
    var course: Course?
    var cards: Results<Card>?
    var cardsCompleted: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let translationView = self.storyboard?.instantiateViewController(withIdentifier: "translationView") as! TranslationExerciseViewController
        self.addChildViewController(translationView)
        translationView.view.frame = containerView.bounds
        translationView.delegate = self
        containerView.addSubview((translationView.view)!)
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = Colors().primary
        UIApplication.shared.isStatusBarHidden = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(popBack))
        self.sessionProgress.clipsToBounds = true
        self.sessionProgress.progressTintColor = Colors().dark
        self.sessionProgress.layer.cornerRadius = 2
        
        loadCards()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCards(){
        let realm = try! Realm()
        self.cards = realm.objects(Card.self)
            .filter("nextPractice <= %@ AND unit == %@", Date(), self.unit!)
    }
    
    func popBack(){
        let alert = UIAlertController(title: "End Session?", message: "Are you sure you want to end this study session?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            self.navigationController?.navigationBar.barTintColor = Colors().primary
            self.navigationController?.navigationBar.tintColor = UIColor.white
            UIApplication.shared.isStatusBarHidden = false
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    func answeredCorrectly(_ correct: Bool) {
        
    }
    
    enum AnswerType{
        case correct
        case incorrect
        case almost
    }
    
    func showAnswer(type: AnswerType){
        let correctLabel = ["👌", "👍", "💯", "💪"].randomItem()
        let incorrectLabel = ["👎", "😣", "😢"].randomItem()
        let almostLabel = "😏"
        switch type{
            case .correct:
                answerLabel.text = correctLabel
            case .incorrect:
                answerLabel.text = incorrectLabel
            case .almost:
                answerLabel.text = almostLabel
        }
        answerLabel.isHidden = false
        answerLabel.alpha = 1.0
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.answerLabel.alpha = 0.0
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
    func answeredCorrectly(_ correct: Bool)
}

extension Array {
    /// Get random item from array
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
