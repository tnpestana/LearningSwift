//
//  ViewController.swift
//  iOSAudioPlayer
//
//  Created by Tiago Pestana on 18/11/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class ViewController: UIViewController {

    @IBOutlet weak var lblFileTitle: UILabel!
    @IBOutlet weak var sliderPlayback: UISlider!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnOpenFile: UIButton!
    
    var timerPlayback: Timer?
    var audioPlayer: AVAudioPlayer?
    var selectedFileURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblFileTitle.text = "No file selected"
        sliderPlayback?.minimumValue = 0
        sliderPlayback?.value = 0
        timerPlayback = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true)
    }
    
    func setupSliderPlayback() {
        guard let fileURL = selectedFileURL else { return }
        let asset = AVURLAsset(url: fileURL, options: nil)
        let audioDuration = asset.duration
        let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
        sliderPlayback?.maximumValue = Float(audioDurationSeconds)
        sliderPlayback?.isContinuous = true
    }
    
    @objc func updateTimer() {
        guard let audioPlayer = audioPlayer else { return }
        let currentTime = Float(audioPlayer.currentTime).truncatingRemainder(dividingBy: 60)
        sliderPlayback.value = currentTime
    }
    
    @IBAction func btnOpenFileTapped(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeMP3 as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func btnPlayTapped(_ sender: Any) {
        guard let fileURL = selectedFileURL else { return }
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying { audioPlayer.stop() }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.play()
        }
        catch {
            print("couldn't load file")
        }
    }
    
    @IBAction func btnPauseTapped(_ sender: Any) {
        audioPlayer?.pause()
    }
}

extension ViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        selectedFileURL = urls.first
        lblFileTitle.text = (selectedFileURL!.path as NSString).lastPathComponent
        setupSliderPlayback()
    }
}

extension ViewController: AVAudioPlayerDelegate {
    
}

