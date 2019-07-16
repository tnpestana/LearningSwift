//
//  MicAnalysisViewController.swift
//  AudioKitTutorial
//
//  Created by Tiago Pestana on 08/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class MicAnalysisViewController: UIViewController
{
    @IBOutlet weak var audioInputPlot: EZAudioPlot!
    @IBOutlet weak var frequencyLbl: UILabel!
    @IBOutlet weak var amplitudeLbl: UILabel!
    @IBOutlet weak var sharpNotesLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet var flatNotesLbl: UILabel!
    
    var mic: AKMicrophone?
    var tracker: AKFrequencyTracker?
    var silence: AKBooster?
    var plot: AKNodeOutputPlot?
    var timer: Timer?
    var noteFrequencies: [Double] = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    var noteNamesWithSharps: [String] = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    var noteNamesWithFlats: [String] = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)
        stopBtn.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        AudioKit.output = silence
        do { try AudioKit.start() }
        catch { print(error.localizedDescription) }
        setupPlot()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        do { try AudioKit.stop() }
        catch { print(error.localizedDescription) }
    }
    
    @IBAction func startButtonPressed(_ sender: Any)
    {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                             target: self,
                             selector: #selector(updateUI),
                             userInfo: nil,
                             repeats: true)
        plot?.resume()
        startBtn.isEnabled = false
        stopBtn.isEnabled = true
    }

    @IBAction func stopButtonPressed(_ sender: Any)
    {
        plot?.pause()
        timer?.invalidate()
        timer = nil
        startBtn.isEnabled = true
        stopBtn.isEnabled = false
    }
    
    func setupPlot()
    {
        plot = AKNodeOutputPlot(mic, frame: audioInputPlot.bounds)
        plot?.plotType = .rolling
        plot?.shouldFill = true
        plot?.shouldMirror = true
        plot?.color = .blue
        plot?.pause()
        audioInputPlot.addSubview(plot!)
    }
    
    @objc func updateUI()
    {
        if tracker!.amplitude > 0.1
        {
            frequencyLbl.text = String(format: "%0.1f", tracker!.frequency)
            var frequency = Float(tracker!.frequency)
            while (frequency > Float(noteFrequencies[noteFrequencies.count-1]))
            {
                frequency = frequency / 2.0
            }
            while (frequency < Float(noteFrequencies[0]))
            {
                frequency = frequency * 2.0
            }
            
            var minDistance: Float = 10000.0
            var index = 0
            
            for i in 0..<noteFrequencies.count
            {
                let distance = fabsf(Float(noteFrequencies[i]) - frequency)
                if (distance < minDistance)
                {
                    index = i
                    minDistance = distance
                }
            }
            let octave = Int(log2f(Float(tracker!.frequency) / frequency))
            sharpNotesLbl.text = "\(noteNamesWithSharps[index])\(octave)"
            flatNotesLbl.text = "\(noteNamesWithFlats[index])\(octave)"
        }
        amplitudeLbl.text = String(format: "%0.2f", tracker!.amplitude)
    }
}
