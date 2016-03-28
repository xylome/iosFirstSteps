//
//  AVFunctions.swift
//  PitchPerfect
//
//  Created by Xavier Heroult on 27/03/2016.
//  Copyright © 2016 Xavier Heroult. All rights reserved.
//

import UIKit
import AVFoundation

extension PlaySoundViewController: AVAudioPlayerDelegate {
    struct Alerts {
        static let DissmissAlert = "Dismiss"
        static let RecordingdisabledTitle = "Recording disabled"
        static let RecordingDisabledMessage = "You did not allow this app to access the microphone. Change this in you device settings"
        static let RecordingFailedTitle = "Recording failed"
        static let RecordingFailedMessage = "Something went wrong with the recording"
        static let AudioRecorderError = "Audio Recorder Error"
        static let AudioSessionError = "Audio session Error"
        static let AudioRecordingError = "Audio recording Error"
        static let AudioFileError = "Audio file Error"
        static let AudioEngineError = "Audio engine Error"
    }
    
    enum PlayingState {
        case Playing, NotPlaying
    }
    
    func setupAudio() {
        do {
            audioFile = try AVAudioFile(forReading: recordedAudio)
        } catch {
            showAlert(Alerts.AudioFileError, message: String(error))
        }
        print("Audio has been setup")
    }
    
    func playSound(rate rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {
        audioEngine = AVAudioEngine()
 
        // node for playing audio
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        try! AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        
        let changePitchRateNode = AVAudioUnitTimePitch()
        if let pitch = pitch {
            changePitchRateNode.pitch = pitch
        }
        
        if let rate = rate {
            changePitchRateNode.rate = rate
        }
        audioEngine.attachNode(changePitchRateNode)
        
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.MultiEcho1)
        audioEngine.attachNode(echoNode)
        
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.Cathedral)
        reverbNode.wetDryMix = 50
        audioEngine.attachNode(reverbNode)
        
  
        if echo == true && reverb == true {
            connectAudioNodes(audioPlayerNode, changePitchRateNode, echoNode, reverbNode, audioEngine.outputNode)
        } else if echo == true {
            connectAudioNodes(audioPlayerNode, changePitchRateNode, echoNode, audioEngine.outputNode)
        } else if reverb == true {
            connectAudioNodes(audioPlayerNode, changePitchRateNode, reverbNode, audioEngine.outputNode)
        } else {
            connectAudioNodes(audioPlayerNode, changePitchRateNode, audioEngine.outputNode)
        }
        
        //
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, atTime: nil) {
            var delayInSeconds: Double = 0
            
            if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTimeForNodeTime(lastRenderTime) {
                
                if let rate = rate {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
                }
            }
            
            self.stopTimer = NSTimer(timeInterval: delayInSeconds, target: self, selector: #selector(PlaySoundViewController.stopAudio), userInfo: nil, repeats: false)
            NSRunLoop.mainRunLoop().addTimer(self.stopTimer!, forMode: NSDefaultRunLoopMode)
        }
        do {
            try audioEngine.start()
        } catch {
            showAlert(Alerts.AudioEngineError, message: String(error))
        }
        
        //audioPlayerNode.outputFormatForBus(AV)
        audioPlayerNode.play()
        
    }
    
    func stopAudio() {
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
        
        configureUI(.NotPlaying)
        
        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.stop()
        }
        
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
    func configureUI(playstate: PlayingState) {
        switch playstate {
        case .NotPlaying:
            setPlayButtonEnabled(true)
            stopButton.enabled = false
        default:
            setPlayButtonEnabled(false)
            stopButton.enabled = true
        }
    }
    
    func setPlayButtonEnabled(state :Bool) {
        snailButton.enabled = state
        rabbitButton.enabled = state
        chipmunkButton.enabled = state
        vadorButton.enabled = state
        echoButton.enabled = state
        reverbButton.enabled = state
    }
    
    func connectAudioNodes(nodes: AVAudioNode...) {
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: Alerts.DissmissAlert, style: .Default, handler: {
                action in
            switch action.style {
            case .Default:
                print("Default")
            case .Cancel:
                print("Cancel")
            case .Destructive:
                print("Destructive")
                }
            }
            ))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
