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

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate, didDismissViewControllerDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    // MARK: UI Functions
    
    enum RecordingState {
        case recording, recordingStopped, recordAgain
    }
    
    func configureUI(_ state: RecordingState) {
        switch(state) {
        case .recording:
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
            recordingLabel.text = "Recording in progress."
        case .recordingStopped:
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            recordingLabel.text = "Recording stopped."
        case .recordAgain:
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            recordingLabel.text = "Press button to record."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didDismissViewController(false)
    }

    @IBAction func recordAudio(_ sender: UIButton) {
        
        configureUI(.recording)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let recordingName = "recordedVoice.wav"
        //let pathArray = [dirPath, recordingName]
        let pathArray = dirPath+"/"+recordingName
        //let filePath = URL.fileURL(withPathComponents: pathArray)
        let filePath = URL(fileURLWithPath: pathArray)
        
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: UIButton) {
        
        configureUI(.recordingStopped)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            playSoundsVC.delegate = self
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
    
    // configure UI when returns from PlaySoundsVC
    func didDismissViewController(_ dismissed: Bool) {
        configureUI(.recordAgain)
    }
    
}

