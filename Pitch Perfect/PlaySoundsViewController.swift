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
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
//            // Do something
//            var filePathUrl = NSURL.fileURLWithPath(filePath)
//            
//            
//        } else {
//            println("the needed filepath not found")
//        }
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func audioPlayerPlay(myRate: Float) {
        audioPlayer.stop()
        audioPlayer.rate = myRate
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    
    @IBAction func playSlowAudio(sender: UIButton) {
        audioPlayerPlay(0.5)
        /*
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0
        audioPlayer.play()
        */
        
    }
  
    @IBAction func playFastAudio(sender: UIButton) {
        audioPlayerPlay(2.0)
        
        /*
        audioPlayer.stop()
        audioPlayer.rate = 2.0
        audioPlayer.currentTime = 0
        audioPlayer.play()
        */
    }
    
    
    @IBAction func stopAudioPlayer(sender: UIButton) {
        audioPlayer.stop()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
