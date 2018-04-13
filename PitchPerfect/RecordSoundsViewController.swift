//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Sai Leung on 4/10/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide navigation bar when app loads
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        updateRecordingUI(enabled: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // This allow recordButton to appear after returning from PlaySoundsViewController
        recordButton.isHidden = false

    }

    // MARK: Record Audio Button function
    @IBAction func recordAudio(_ sender: UIButton) {
        
        updateRecordingUI(enabled: false)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // MARK: Stop Recording Button function
    
    @IBAction func stopRecording(_ sender: UIButton) {
        updateRecordingUI(enabled: true)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: UI Configuration function for enabling/disabling the recording and stop buttons. When recordButton is enabled, stop recording button will be hidden, vice versa. Also, the recodingLabel will reflect the instructional messages accordingly
    
    func updateRecordingUI(enabled: Bool) {
        if enabled {
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            stopRecordingButton.isHidden = true
            recordingLabel.text = "Tap to Record"
        } else {
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
            stopRecordingButton.isHidden = false
            recordButton.isHidden = true
            recordingLabel.text = "Tap to finish recording"
            
        }
    }
    
    // MARK: Audio Recorder delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            
            // When audio finished recording, perform segue and send the assosciated recorder url
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            
            // Print below message if the recording process was unsuccessful
            print("recording was not successful")
        }
    }
    
    // MARK: Prepare for segue -> Passing recorded audio URL
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            
            // declare below constant as destination controller
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            
            // declare constant as URL as sender and set destination variable as the same URL (Passing data between view controllers
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

