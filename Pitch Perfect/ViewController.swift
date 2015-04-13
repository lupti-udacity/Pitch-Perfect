//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Lupti Cheung on 4/12/15.
//  Copyright (c) 2015 Lupti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        //TODO: Add recording in progress
        //TODO: Add user's recording message
        println("inside the recordAudio function")
       microphoneOutlet.hidden = !microphoneOutlet.hidden
       
    }
    
    
    @IBOutlet weak var microphoneOutlet: UILabel!
    

}

