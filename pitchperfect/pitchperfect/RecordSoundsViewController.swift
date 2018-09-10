//
//  RecordSoundsViewController.swift
//  pitchperfect
//
//  Created by admin on 2018/09/03.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopRecordingButton.isEnabled = false
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        configUI(enable: false)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory , .userDomainMask , true) [0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath , recordingName]
        let filePath = URL(string: pathArray.joined(separator:"/"))
        print(filePath ?? "hello")
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord , with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath! , settings : [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        

    }

    @IBAction func stopRecording(_ sender: Any) {
        configUI(enable: true)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)

    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("recording failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundAC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundAC.recorderAudioURL = recordedAudioURL
        }
    }
    
    func configUI(enable : Bool){
        if enable {
            stopRecordingButton.isEnabled = false
            recordButton.isEnabled = true
            recordingLabel.text = "Tap to Record"
        }else{
            recordingLabel.text = "Recording in progress"
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
        }
    }
}

