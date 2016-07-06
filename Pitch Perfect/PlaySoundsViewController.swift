//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Lupti Cheung on 4/16/15.
//  Copyright (c) 2015 Lupti. All rights reserved.
//

/* AVAudioEngine Workflow
1. Create an engine
2. Create nodes
3. Attach nodes to the engine
4. Connect the nodes together 
5. Start the engine
*/

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    //Declare global variables
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Instantiate audioPlayer, audioEngine and audioFile
        audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: receivedAudio.filePathUrl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Common function to stop player and engine, set the rate from pass-in parameter, and restart audioPlayer
    func audioPlayerPlayRate(myRate: Float) {
        stopAudioPlayerAndEngine()
        audioPlayer.rate = myRate
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    //Common function to stop player and engine
    func stopAudioPlayerAndEngine() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
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
        //Stop any player still in process
        stopAudioPlayerAndEngine()
        
        //Instantiate player and attach it to the audio engine
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //Add pitch rate from parameter to the audio engine by attaching it
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        //Connect the node and effect to the audio engine
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        //Attach audio file to the audio engine and start the engine
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            // try audioEngine.startAndReturnError()
            try audioEngine.start()
        } catch _ {
        }
        
        //Play the audio player
        audioPlayerNode.play()
        
    }
    //Play recorded audio in rever/echo mode
    func playAudioWithReverb() {
        stopAudioPlayerAndEngine()
        
        //First declare the necessary nodes
        let audioPlayerNode = AVAudioPlayerNode()
        let audioPlayerReverbNode = AVAudioUnitReverb()
        let audioPlayerDistortNode = AVAudioUnitDistortion()
        let audioPlayerDelayNode = AVAudioUnitDelay()
        let audioPlayerMixerNode = AVAudioMixerNode()
        
        //Attach nodes to the audioEngine
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(audioPlayerReverbNode)
        audioEngine.attachNode(audioPlayerDistortNode)
        audioEngine.attachNode(audioPlayerDelayNode)
        audioEngine.attachNode(audioPlayerMixerNode)
        
        //Connect audioEngine to nodes in series
        audioEngine.connect(audioPlayerNode, to: audioPlayerReverbNode, format: nil)
        audioEngine.connect(audioPlayerReverbNode, to: audioPlayerDistortNode, format: nil)
        audioEngine.connect(audioPlayerDistortNode, to: audioPlayerDelayNode, format: nil)
        audioEngine.connect(audioPlayerDelayNode, to: audioPlayerMixerNode, format: nil)
        audioEngine.connect(audioPlayerMixerNode, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        do {
            //Start the audioEngine in reverb mode
            try audioEngine.start()
            //try audioEngine.startAndReturnError()
        } catch _ {
        }
        
        //Play in reverb mode
        audioPlayerNode.play()
        
    }
    
    
    @IBAction func stopAudioPlayer(sender: UIButton) {
        stopAudioPlayerAndEngine()
    }
}
