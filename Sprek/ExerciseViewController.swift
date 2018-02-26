//
//  ExerciseViewController.swift
//  Sprek
//
//  Created by Eli Yazdi on 8/2/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit
import AVFoundation

class ExerciseViewController: UIViewController {

    
    var delegate: ExerciseDelegate?
    var card: Card?
    var player: AVAudioPlayer?
    var reversed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    func checkAnswer(){
        
    }
    
    func playAudio(){
        if(self.card?.audio != nil){
            self.player = try! AVAudioPlayer(data: (self.card?.audio)!)
            player?.volume = 1.0
            player?.play()
        }else if(AudioOrTTS(for: self.card!).hasTTS){
            AudioOrTTS(for: self.card!).playTTS()
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
