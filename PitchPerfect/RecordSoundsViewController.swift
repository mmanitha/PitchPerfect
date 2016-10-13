//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Michael Manisa on 9/29/16.
//  Copyright © 2016 Michael Manisa. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    // MARK: UI Function to toggle button states
    
    func configureUI(recording: Bool) {
        if recording == true {
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
        } else {
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(recording: false)
    }

    @IBAction func recordAudio(_ sender: UIButton) {
        
        //configureUI(recordingState: .Recording)
        configureUI(recording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        recordingLabel.text = "Recording in progress."
    }

    @IBAction func stopRecording(_ sender: UIButton) {
        
        //configureUI(recordingState: .NotRecording)
        configureUI(recording: false)
        audioRecorder.stop()
        recordingLabel.text = "Recording stopped."
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // Makes sure audio stops recording before performing segue.
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            let alert = UIAlertController(title: "Error", message: "Audio file failed to save.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

