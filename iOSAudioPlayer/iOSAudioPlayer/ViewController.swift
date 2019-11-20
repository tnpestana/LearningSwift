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
    @IBOutlet weak var progressPlayback: UIProgressView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnOpenFile: UIButton!
    
    var timerPlayback: Timer?
    var audioPlayer: AVAudioPlayer?
    var selectedFileURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblFileTitle.text = "No file selected"
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
    }
    
    func playSelectedAudioFile() {
        guard let fileURL = selectedFileURL else {
            let alert = UIAlertController(title: "Uh oh", message: "No file selected", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
            return
        }
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying { audioPlayer.stop() }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.play()
        }
        catch {
            print("Couldn't load file")
        }
    }
    
    @objc func updateTimer() {
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying {
            progressPlayback.setProgress(Float(audioPlayer.currentTime/audioPlayer.duration), animated: true)
        }
    }
    
    @IBAction func btnOpenFileTapped(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeMP3 as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func btnPlayTapped(_ sender: Any) {
        playSelectedAudioFile()
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

