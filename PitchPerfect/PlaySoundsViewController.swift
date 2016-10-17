//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Michael Manisa on 10/1/16.
//  Copyright © 2016 Michael Manisa. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var delegate : didDismissViewControllerDelegate?
    
    // MARK: Variables
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    // MARK: Outlets
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopPlaybackButton: UIButton!
    
    
    override func viewDidLoad() {
        
        // Set UIButton Aspect Fit
        snailButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        rabbitButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        chipmunkButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        vaderButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        echoButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        reverbButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        stopPlaybackButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                
        super.viewDidLoad()
        
        print("PlaySoundViewController loaded.")
        
        configureUI(.notPlaying)
        
        setupAudio()
    }
    
    
    // MARK: Button Actions

    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    @IBAction func playSoundForButton(sender: UIButton) {
        print("Play sound button pressed.")
        
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(0.5)
        case .fast:
            playSound(2.0)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        
        stopAudio()
        print("Stop button pressed.")
    }

    override func viewDidDisappear(_ animated: Bool) {
        if let d = delegate {
            d.didDismissViewController(true)
        }
    }
}
