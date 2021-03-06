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
    var keyboard: KeyboardView!
    var oscillator: Oscillator?
    var delay: Delay?
    var reverb: Reverb?
    var chorus: Chorus?
    var phaser: Phaser?
    
    var mainStack: UIStackView?
    var btnStack: UIStackView?

    let square = Table(.square, count: 256)
    let triangle = Table(.triangle, count: 256)
    let sine = Table(.sine, count: 256)
    let sawtooth = Table(.sawtooth, count: 256)
    var currentMIDINote: MIDINoteNumber = 0
    var currentAmplitude: Float = 0.2
    var currentRampDuration: Float = 0.05
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        loadButtons()
        loadKeyboard()
        
        initComponents()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        mainStack?.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        btnStack?.axis = (size.width > size.height) ? .horizontal : .vertical
    }
    
    // MARK: - Setup
    func setupStackView() {
        mainStack = UIStackView(frame: self.view.safeAreaLayoutGuide.layoutFrame)
        mainStack?.axis = .vertical
        mainStack?.distribution = .fillEqually
        mainStack?.alignment = .fill
        self.view.addSubview(mainStack!)
    }
    
    func loadKeyboard() {
        if keyboard == nil {
            keyboard = KeyboardView(frame: CGRect(width: 0, height: 0))
            keyboard.delegate = self
            mainStack?.addArrangedSubview(keyboard)
        }
    }
    
    func loadButtons() {
        btnStack = UIStackView(frame: CGRect(width: 0, height: 0))
        btnStack?.axis = (view.frame.width > view.frame.height) ? .horizontal : .vertical
        btnStack?.alignment = .fill
        btnStack?.distribution = .fillEqually
        
        let leftStack = UIStackView(frame: CGRect(width: 0, height: 0))
        leftStack.axis = .vertical
        leftStack.alignment = .fill
        leftStack.distribution = .fillEqually
        
        let rightStack = UIStackView(frame: CGRect(width: 0, height: 0))
        rightStack.axis = .vertical
        rightStack.alignment = .fill
        rightStack.distribution = .fillEqually
        
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
        
        leftStack.addArrangedSubview(btnDelay)
        leftStack.addArrangedSubview(btnReverb)
        rightStack.addArrangedSubview(btnChorus)
        rightStack.addArrangedSubview(btnPhaser)
        
        btnStack?.addArrangedSubview(leftStack)
        btnStack?.addArrangedSubview(rightStack)
        
        mainStack?.addArrangedSubview(btnStack!)
    }

    func initComponents() {
        oscillator = Oscillator(waveform: sine)
        oscillator?.$amplitude.ramp(to: AUValue(currentAmplitude), duration: currentRampDuration)
        oscillator?.start()
        
        reverb = Reverb(oscillator!)
        reverb?.bypass()
        
        delay = Delay(reverb!)
        delay?.time = 0.1 // seconds
        delay?.feedback = 0.8 // Normalized Value 0 - 1
        delay?.dryWetMix = 0.2 // Normalized Value 0 - 1
        delay?.bypass()
        
        chorus = Chorus(delay!)
        chorus?.dryWetMix = 0.5
        chorus?.$depth.ramp(to: AUValue(1), duration: currentRampDuration)
        chorus?.bypass()
        
        phaser = Phaser(chorus!)
        phaser?.depth = 0.5
        phaser?.feedback = 0.5
        phaser?.bypass()
        
        let engine = AudioEngine()
        engine.output = phaser
        do {
            try engine.start()
        }
        catch {
            print("Audio Kit init failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Actions
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
}

//MARK: Keyboard Delegate
extension ViewController: KeyboardDelegate {
    func noteOn(note: MIDINoteNumber) {
        currentMIDINote = note
//        // start from the correct note if amplitude is zero
//        if oscillator?.amplitude == 0 {
//            oscillator?.$amplitude.ramp(to: AUValue(0), duration: Float(currentRampDuration))
//        } else {
//            oscillator?.$amplitude.ramp(to: AUValue(currentAmplitude), duration: Float(currentRampDuration))
//        }
        oscillator?.frequency = note.midiNoteToFrequency()
        oscillator?.$amplitude.ramp(to: AUValue(currentAmplitude), duration: Float(currentRampDuration))
        oscillator?.play()
    }
    
    func noteOff(note: MIDINoteNumber) {
        if note == currentMIDINote {
            oscillator?.amplitude = 0
        }
    }
}

