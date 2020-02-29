//
//  PlayControllerViewController.swift
//  PitchPerfect
//
//  Created by Santhana Ravi on 27/2/20.
//  Copyright © 2020 org.udacity. All rights reserved.
//

import UIKit
import AVFoundation

class PlayControllerViewController: UIViewController {
    

    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recorderAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var timer: Timer!
    
    enum ButtonType:  Int { case slow = 0, fast, highPitch, lowPitch, echo, reverb }
    

    @IBAction func playbutton (_ sender: UIButton)  {
        switch (ButtonType(rawValue: sender.tag)) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .highPitch:
            playSound(pitch: 1000)
        case .lowPitch:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        default:
            exit(0)
        }
        configureUI(.playing)
    }

    @IBAction func stopbutton (_ sender: UIButton)  {
        stopAudio()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAudio()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
}
