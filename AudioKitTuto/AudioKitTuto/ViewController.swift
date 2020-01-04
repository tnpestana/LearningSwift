//
//  ViewController.swift
//  AudioKitTuto
//
//  Created by Tiago Pestana on 03/01/2020.
//  Copyright © 2020 Tiago Pestana. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class ViewController: UIViewController {
    var keyboard: AKKeyboardView!
    var oscillator: AKOscillator?
    var delay: AKDelay?
    var reverb: AKReverb?

    let square = AKTable(.square, count: 256)
    let triangle = AKTable(.triangle, count: 256)
    let sine = AKTable(.sine, count: 256)
    let sawtooth = AKTable(.sawtooth, count: 256)
    var currentMIDINote: MIDINoteNumber = 0
    var currentAmplitude = 0.2
    var currentRampDuration = 0.05
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadKeyboard()
        initOscillator()
        initReverb()
        initDelay()
        initAuydioKit()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateKeyboardFrame(CGRect(size: size))
    }
    
    func loadKeyboard() {
        if keyboard == nil {
            keyboard = AKKeyboardView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height
                / 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2))
            self.view.addSubview(keyboard)
            keyboard.delegate = self
        }
    }
    
    func updateKeyboardFrame(_ rect: CGRect) {
        if keyboard != nil {
            keyboard.frame = CGRect(x: 0, y: rect.height
                / 2, width: rect.width, height: rect.height / 2)
        }
    }
    
    func initOscillator() {
        oscillator = AKOscillator(waveform: sine)
        oscillator?.rampDuration = currentRampDuration
        oscillator?.amplitude = currentAmplitude
    }
    
    func initReverb() {
        reverb = AKReverb(oscillator)
    }
    
    func initDelay() {
        delay = AKDelay(reverb)
        delay?.time = 0.1 // seconds
        delay?.feedback = 0.8 // Normalized Value 0 - 1
        delay?.dryWetMix = 0.2 // Normalized Value 0 - 1
        //delay?.bypass()
    }
    
    func initAuydioKit() {
        guard delay != nil, oscillator != nil else { return }
        AudioKit.output = delay
        do {
            try AudioKit.start()
        }
        catch {
            print("Audio Kit init failed: \(error.localizedDescription)")
        }
    }
}

//MARK: Keyboard Delegate
extension ViewController: AKKeyboardDelegate {
    func noteOn(note: MIDINoteNumber) {
        currentMIDINote = note
        // start from the correct note if amplitude is zero
        if oscillator?.amplitude == 0 {
            oscillator?.rampDuration = 0
        }
        oscillator?.frequency = note.midiNoteToFrequency()

        // Still use rampDuration for volume
        oscillator?.rampDuration = currentRampDuration
        oscillator?.amplitude = currentAmplitude
        
        oscillator?.play()
    }
    
    func noteOff(note: MIDINoteNumber) {
        if note == currentMIDINote {
            oscillator?.amplitude = 0
        }
    }
}

