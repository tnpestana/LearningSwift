//
//  ViewController.swift
//  AudioKitTutorial
//
//  Created by Tiago Pestana on 07/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import AudioKit

class PlayerViewController: UIViewController
{
    let oscillator = AKOscillator()
        
    override func viewDidLoad()
    {
        super.viewDidLoad()
        AudioKit.output = AKMixer(oscillator)
        do
        {
            try AudioKit.start()
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func playAction(_ sender: UIButton)
    {
        if oscillator.isPlaying
        {
            oscillator.stop()
            sender.setTitle("Play", for: .normal)
        }
        else
        {
            oscillator.amplitude = random(in: 0.5...1)
            oscillator.frequency = random(in: 220...880)
            oscillator.start()
            sender.setTitle("Stop", for: .normal)
        }
    }
}

