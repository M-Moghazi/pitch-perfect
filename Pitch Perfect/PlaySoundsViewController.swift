//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mohamed Moghazi on 6/3/15.
//  Copyright (c) 2015 Mohamed Elmoghazi. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    
    var recievedAudio:RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    
    var audioFile: AVAudioFile!
    
    func playAtRate(rate: Float) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch (pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePath, error: nil )
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePath, error: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func slowPlay(sender: AnyObject) {
        audioEngine.reset()
        playAtRate(0.5)
    }
    
    @IBAction func fastPlay(sender: AnyObject) {
        audioEngine.reset()
        playAtRate(1.5)
    }
    
    @IBAction func chipmunk(sender: AnyObject) {
        playAudioWithVariablePitch(1200)

    }
    
    @IBAction func darthvader(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopAudioPlayer(sender: AnyObject) {
        audioPlayer.stop()
    }


}
