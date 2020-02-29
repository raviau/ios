//
//  RecordController.swift
//  PitchPerfect
//
//  Created by Santhana Ravi on 24/2/20.
//  Copyright © 2020 org.udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet var recordLabel: [UILabel]!
    @IBOutlet weak var recordButtonn: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopRecordButton.isEnabled = false
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        configureUIElemennts(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        
        let session = AVAudioSession.sharedInstance()

        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }
    
    fileprivate func configureUIElemennts(_ isRecordinng:  Bool) {
        if isRecordinng {
            recordLabel[0].text = "Recording..."
        } else {
            recordLabel[0].text = "Tap to record"
        }
        stopRecordButton.isEnabled = isRecordinng
        recordButtonn.isEnabled = !isRecordinng
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUIElemennts(false)
        
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Could not record audio")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playController = segue.destination as! PlayControllerViewController
            let recordedAudioURL = sender as! URL
            
            playController.recorderAudioURL = recordedAudioURL                        
        }
    }
}

