//
//  NewCardViewController.swift
//  Sprek
//
//  Created by Eli Yazdi on 7/31/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class NewCardViewController: UITableViewController, UITextFieldDelegate, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    @IBOutlet weak var targetBox: UITextField!
    @IBOutlet weak var translationBox: UITextField!
    @IBOutlet weak var latinBox: UITextField!
    @IBOutlet weak var recordAudioButton: UIButton!
    
    var forEditing: Bool?
    var forSentence: Bool?
    var unit: Unit?
    var audio: Data? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        self.recordAudioButton.contentHorizontalAlignment = .left
        self.recordAudioButton.setTitle("Record audio", for: .normal)
        
        let audioFilename = self.getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do{
            self.audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            self.audioRecorder.delegate = self
        }catch{
            
        }
        
        targetBox.delegate = self
        latinBox.delegate = self
        translationBox.delegate = self
        recordAudioButton.layer.cornerRadius = 10
        recordAudioButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        recordAudioButton.addTarget(self, action: #selector(record), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewCard))
        
        if(forSentence!){
            targetBox.placeholder = "Sentence in target language"
            latinBox.placeholder = "Transliteration of sentence (optional)"
            translationBox.placeholder = "Translation of sentence"
            self.navigationItem.title = "New Sentence"
            targetBox.autocapitalizationType = .sentences
            translationBox.autocapitalizationType = .sentences
            latinBox.autocapitalizationType = .sentences
        }else{
            self.navigationItem.title = "New Word"
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func addNewCard(){
        if(targetBox.text == "" || translationBox.text == ""){
            let alert = UIAlertController(title: "Card incomplete", message: "Complete all required fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { void in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
        }else{
            let newCard = Card()
            newCard.sentence = targetBox.text!
            newCard.translation = translationBox.text!
            newCard.latin = latinBox.text!
            newCard.isSentence = self.forSentence!
            newCard.unit = self.unit!
            newCard.audio = self.audio
            let realm = try! Realm()
            try! realm.write{
                realm.add(newCard)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func record(){
        if(audioRecorder.isRecording){
            audioRecorder.stop()
            self.recordAudioButton.setTitle("Record audio", for: .normal)
            self.audio = try! Data(contentsOf: audioRecorder.url)
        }else{
            audioRecorder.record()
            self.recordAudioButton.setTitle("Stop recording", for: .normal)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
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
