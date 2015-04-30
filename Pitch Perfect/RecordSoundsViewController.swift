//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Lupti Cheung on 4/12/15.
//  Copyright (c) 2015 Lupti. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var tapToRecord: UILabel!
    @IBOutlet weak var tapToPause: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var recordingSessionIsOn:Bool = false
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
        tapToRecord.hidden = false
        tapToPause.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }

    //create file path for recording audio
    func createFilePath() {
        recordingInProgress.textColor = UIColor.redColor()
        recordingInProgress.hidden = false
        stopButton.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+"wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
    
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        //Added delegate = self where self is the class RecordSoundsViewController
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        // Set up recording session for beginning recording
        if (!recordingSessionIsOn) {
            createFilePath()
            recordingSessionIsOn = true
        } else {
            // recording session is already on, do nothing and go to the next recording or pausing action
        }
        // recording
        if (!tapToRecord.hidden) {
            audioRecorder.record()
            recordingInProgress.text = "Recording"
            tapToRecord.hidden = true
            tapToPause.hidden = false
        } else {
            // pausing
            audioRecorder.pause()
            recordingInProgress.text = "Pausing"
            tapToRecord.hidden = false
            tapToPause.hidden = true
        }
      }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //To save the recorded audio
        //initize the variable recordAudio
        
        if(flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url!, title: recorder.url.lastPathComponent!)
            
        } else {
            println("Recording was not successfully")
            recordButton.enabled = true
            stopButton.hidden = true
        }
        
        //To transition to next scene i.e. to perform segue
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController=segue.destinationViewController as!PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
   
    @IBAction func stopAudio(sender: UIButton) {
        recordingInProgress.hidden = true
        stopButton.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        //Turn off the recording session when stop the audio recording
        if (recordingSessionIsOn) {
            recordingSessionIsOn = false
        }
    }
}

