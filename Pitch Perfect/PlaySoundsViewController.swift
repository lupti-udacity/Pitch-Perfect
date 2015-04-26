//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Lupti Cheung on 4/16/15.
//  Copyright (c) 2015 Lupti. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func audioPlayerPlayRate(myRate: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioPlayer.rate = myRate
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    
    @IBAction func playSlowAudio(sender: UIButton) {
        audioPlayerPlayRate(0.5)
    }
  
    @IBAction func playFastAudio(sender: UIButton) {
        audioPlayerPlayRate(2.0)
     }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playTestReverb(sender: UIButton) {
        playAudioWithReverb()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
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
    
    func playAudioWithReverb() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        var audioPlayerReverbNode = AVAudioUnitReverb()
        var audioPlayerDistortNode = AVAudioUnitDistortion()
        var audioPlayerDelayNode = AVAudioUnitDelay()
        var audioPlayerMixerNode = AVAudioMixerNode()
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(audioPlayerReverbNode)
        audioEngine.attachNode(audioPlayerDistortNode)
        audioEngine.attachNode(audioPlayerDelayNode)
        audioEngine.attachNode(audioPlayerMixerNode)
        
        audioEngine.connect(audioPlayerNode, to: audioPlayerReverbNode, format: nil)
        audioEngine.connect(audioPlayerReverbNode, to: audioPlayerDistortNode, format: nil)
        audioEngine.connect(audioPlayerDistortNode, to: audioPlayerDelayNode, format: nil)
        audioEngine.connect(audioPlayerDelayNode, to: audioPlayerMixerNode, format: nil)
        audioEngine.connect(audioPlayerMixerNode, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
    
    @IBAction func stopAudioPlayer(sender: UIButton) {
        audioEngine.stop()
        audioPlayer.stop()
    }
    

}
