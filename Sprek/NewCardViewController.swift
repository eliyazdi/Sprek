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
    @IBOutlet weak var deleteAudioButton: UIButton!
    
    var forEditing: Bool? = false
    var editCard: Card?
    var forSentence: Bool? = false
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
        
        let stateStr = forEditing! ? "Edit" : "New"
        
        if(forSentence!){
            targetBox.placeholder = "Sentence in target language"
            latinBox.placeholder = "Transliteration of sentence (optional)"
            translationBox.placeholder = "Translation of sentence"
            self.navigationItem.title = "\(stateStr) Sentence"
            targetBox.autocapitalizationType = .sentences
            translationBox.autocapitalizationType = .sentences
            latinBox.autocapitalizationType = .sentences
        }else{
            self.navigationItem.title = "\(stateStr) Word"
        }
        
        if(forEditing!){
            targetBox.text = editCard?.sentence
            translationBox.text = editCard?.translation
            latinBox.text = editCard?.latin
            self.navigationItem.rightBarButtonItems = [
                UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneEditing)),
                UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteCard))
            ]
        }
        
        if(audio != nil){
            deleteAudioButton.isHidden = false
        }
        
        deleteAudioButton.addTarget(self, action: #selector(deleteAudio), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func deleteCard(){
        if let card = self.editCard{
            let alert = UIAlertController(title: "Delete card?", message: "", preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(
                    title: "Cancel",
                    style: .cancel) { (_) in
                })
            alert.addAction(
                UIAlertAction(
                    title: "Delete",
                    style: .destructive) { (_) in
                        let realm = try! Realm(configuration: MyRealm.config)
                        try! realm.write {
                            realm.delete(card)
                        }
                        self.navigationController?.popViewController(animated: true)
                    })
            self.present(alert, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @objc func addNewCard(){
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
            print("here4")
            let realm = try! Realm(configuration: MyRealm.config)
            try! realm.write{
                realm.add(newCard)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func doneEditing(){
        if(targetBox.text == "" || translationBox.text == ""){
            let alert = UIAlertController(title: "Card incomplete", message: "Complete all required fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { void in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
        }else{
            let realm = try! Realm(configuration: MyRealm.config)
            try! realm.write{
                editCard?.sentence = targetBox.text!
                editCard?.translation = translationBox.text!
                editCard?.latin = latinBox.text
                editCard?.audio = self.audio
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func record(){
        if(audioRecorder.isRecording){
            audioRecorder.stop()
            self.recordAudioButton.setTitle("Record audio", for: .normal)
            self.audio = try! Data(contentsOf: audioRecorder.url)
            self.deleteAudioButton.isHidden = false
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
    
    @objc func deleteAudio(){
        let alert = UIAlertController(title: "Delete audio?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { void in
            self.audio = nil
            self.deleteAudioButton.isHidden = true
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { void in
            
        }))
        self.present(alert, animated: true)
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
