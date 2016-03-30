//
//  PlaySoundViewController.swift
//  PitchPerfect
//
//  Created by Xavier Heroult on 25/03/2016.
//  Copyright © 2016 Xavier Heroult. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    var recordedAudio :NSURL!
    
    @IBOutlet weak var snailButton:UIButton!
    @IBOutlet weak var rabbitButton:UIButton!
    @IBOutlet weak var chipmunkButton:UIButton!
    @IBOutlet weak var vadorButton:UIButton!
    @IBOutlet weak var reverbButton:UIButton!
    @IBOutlet weak var echoButton:UIButton!
    @IBOutlet weak var stopButton:UIButton!
    
    @IBOutlet weak var snailButton2:UIButton!
    @IBOutlet weak var rabbitButton2:UIButton!
    @IBOutlet weak var chipmunkButton2:UIButton!
    @IBOutlet weak var vadorButton2:UIButton!
    @IBOutlet weak var reverbButton2:UIButton!
    @IBOutlet weak var echoButton2:UIButton!
    @IBOutlet weak var stopButton2:UIButton!

    
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: NSTimer!
    
    enum ButtonType: Int {case Slow = 0, Fast, Chipmunk, Vador, Reverb, Echo}
    
    @IBAction func playSoundForButton(sender: UIButton) {
       // configureUI(.Playing)
        print("Play sound button")
        switch (ButtonType(rawValue: sender.tag)!) {
        case .Slow:
            print("Playing slowly")
            playSound(rate: 0.5)
        case .Fast:
            print("Play fast")
            playSound(rate: 1.5)
        case .Chipmunk:
            print("Play Chipmunk")
            playSound(pitch: 1000)
        case .Vador:
            print("Play Vador")
            playSound(pitch: -1000)
        case .Reverb:
            print("Play with reverb")
            playSound(reverb: true)
        case .Echo:
            print("Play with echo")
            playSound(echo: true)
        }
           }
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        print("Stop audio button")
        stopAudio()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        configureUI(.NotPlaying)
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
