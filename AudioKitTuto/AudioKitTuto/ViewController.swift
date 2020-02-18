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
    var chorus: AKChorus?
    var phaser: AKPhaser?

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
        loadButtons()
        initOscillator()
        initReverb()
        initDelay()
        initChorus()
        initPhaser()
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
    
    func loadButtons() {
        let stack = UIStackView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2))
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        
        let btnDelay = UIButton(frame: CGRect(width: 200, height: 100))
        btnDelay.setTitle("Delay", for: .normal)
        btnDelay.setTitleColor(.blue, for: .normal)
        btnDelay.layer.borderWidth = 1
        btnDelay.addTarget(self, action: #selector(btnDelayTapped), for: .touchUpInside)
        
        let btnReverb = UIButton(frame: CGRect(width: 200, height: 100))
        btnReverb.setTitle("Reverb", for: .normal)
        btnReverb.setTitleColor(.blue, for: .normal)
        btnReverb.layer.borderWidth = 1
        btnReverb.addTarget(self, action: #selector(btnReverbTapped), for: .touchUpInside)
        
        let btnChorus = UIButton(frame: CGRect(width: 200, height: 100))
        btnChorus.setTitle("Chorus", for: .normal)
        btnChorus.setTitleColor(.blue, for: .normal)
        btnChorus.layer.borderWidth = 1
        btnChorus.addTarget(self, action: #selector(btnChorusTapped), for: .touchUpInside)
        
        let btnPhaser = UIButton(frame: CGRect(width: 200, height: 100))
        btnPhaser.setTitle("Phaser", for: .normal)
        btnPhaser.setTitleColor(.blue, for: .normal)
        btnPhaser.layer.borderWidth = 1
        btnPhaser.addTarget(self, action: #selector(btnPhaserTapped), for: .touchUpInside)
        
        stack.addArrangedSubview(btnDelay)
        stack.addArrangedSubview(btnReverb)
        stack.addArrangedSubview(btnChorus)
        stack.addArrangedSubview(btnPhaser)
        self.view.addSubview(stack)
    }
    
    @objc func btnDelayTapped() {
        guard let delay = delay else { return }
        if delay.isBypassed {
            delay.start()
        }
        else {
            delay.bypass()
        }
    }
    
    @objc func btnReverbTapped() {
        guard let reverb = reverb else { return }
        if reverb.isBypassed {
            reverb.start()
        }
        else {
            reverb.bypass()
        }
    }
    
    @objc func btnChorusTapped() {
        guard let chorus = chorus else { return }
        if chorus.isBypassed {
            chorus.start()
        }
        else {
            chorus.bypass()
        }
    }
    
    @objc func btnPhaserTapped() {
        guard let phaser = phaser else { return }
        if phaser.isBypassed {
            phaser.start()
        }
        else {
            phaser.bypass()
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
        reverb?.bypass()
    }

    func initDelay() {
        delay = AKDelay(reverb)
        delay?.time = 0.1 // seconds
        delay?.feedback = 0.8 // Normalized Value 0 - 1
        delay?.dryWetMix = 0.2 // Normalized Value 0 - 1
        delay?.bypass()
    }
    
    func initChorus() {
        chorus = AKChorus(delay)
        chorus?.dryWetMix = 0.5
        //chorus?.frequency = 200.0
        chorus?.rampDuration = currentRampDuration
        chorus?.bypass()
    }
    
    func initPhaser() {
        phaser = AKPhaser(chorus)
        phaser?.depth = 0.5
        phaser?.feedback = 0.5
        phaser?.bypass()
    }
    
    func initAuydioKit() {
        guard phaser != nil, oscillator != nil else { return }
        AudioKit.output = phaser
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

