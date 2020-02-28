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
        stopRecordButton.isEnabled = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        recordLabel[0].text = "Recording..."
        stopRecordButton.isEnabled = true
        recordButtonn.isEnabled = false
        
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
    
    @IBAction func stopRecording(_ sender: Any) {
        recordLabel[0].text = "Tap to record"
        stopRecordButton.isEnabled = false
        recordButtonn.isEnabled = true
        
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("inside audioRecorderDidFinishRecording")
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

