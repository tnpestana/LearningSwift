//
//  ViewController.swift
//  iOSAudioPlayer
//
//  Created by Tiago Pestana on 18/11/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnPlayTapped(_ sender: Any) {
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying { audioPlayer.stop() }
        
        guard let path = Bundle.main.path(forResource: "Untitled", ofType: "mp3") else {
            print("file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("couldn't load file")
        }
    }
    
    @IBAction func btnPauseTapped(_ sender: Any) {
        audioPlayer?.pause()
    }
}

