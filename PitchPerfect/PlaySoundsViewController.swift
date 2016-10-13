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
    
    
    // MARK: Variables
    
    var recordedAudioURL: NSURL!
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
        
        configureUI(playState: .NotPlaying)
        
        setupAudio()
    }
    
    
    // MARK: Button Actions

    enum ButtonType: Int {
        case Slow = 0, Fast, Chipmunk, Vader, Echo, Reverb
    }
    
    @IBAction func playSoundForButton(sender: UIButton) {
        print("Play sound button pressed.")
        
        switch(ButtonType(rawValue: sender.tag)!) {
        case .Slow:
            playSound(rate: 0.5)
        case .Fast:
            playSound(rate: 2.0)
        case .Chipmunk:
            playSound(pitch: 1000)
        case .Vader:
            playSound(pitch: -1000)
        case .Echo:
            playSound(echo: true)
        case .Reverb:
            playSound(reverb: true)
        }
        
        configureUI(playState: .Playing)
    }
    
    
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        
        stopAudio()
        print("Stop button pressed.")
    }

    
    



}
