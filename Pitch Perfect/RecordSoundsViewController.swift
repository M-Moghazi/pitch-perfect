//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mohamed Moghazi on 6/2/15.
//  Copyright (c) 2015 Mohamed Elmoghazi. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var microphoneIcon: UIButton!
    
    var audioRecord: AVAudioRecorder!
    
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        microphoneIcon.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var recordingLabel: UILabel!
    


    @IBAction func recordButton(sender: AnyObject) {
        recordingLabel.text = "..Recording.."
        stopButton.hidden = false
        microphoneIcon.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) [0] as! String
        
        let recordingName = "Audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray as [AnyObject])

        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecord = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecord.delegate = self
        audioRecord.meteringEnabled = true
        audioRecord.prepareToRecord()
        audioRecord.record()

    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio()
            recordedAudio.filePath = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("not successful")
            recordingLabel.hidden = true
            stopButton.hidden = true
            microphoneIcon.enabled = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.recievedAudio = data
            
        }
    }
    
    @IBAction func stopRecording(sender: AnyObject) {
        recordingLabel.text = "Tap to Record"
        stopButton.hidden = true
        microphoneIcon.enabled = true
        audioRecord.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

