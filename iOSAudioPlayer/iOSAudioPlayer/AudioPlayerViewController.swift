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

class AudioPlayerViewController: UIViewController {

    @IBOutlet weak var lblFileTitle: UILabel!
    @IBOutlet weak var progressPlayback: UIProgressView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnOpenFile: UIButton!
    
    var timerPlayback: Timer?
    var audioPlayer: AVAudioPlayer?
    var selectedFileURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblFileTitle.text = "No file selected"
        progressPlayback.progress = 0.0
        timerPlayback = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(updateProgressView),
            userInfo: nil,
            repeats: true)
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
    
    @objc func updateProgressView() {
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying {
            progressPlayback.setProgress(Float(audioPlayer.currentTime / audioPlayer.duration), animated: true)
        }
    }
    
    @IBAction func btnOpenFileTapped(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeMP3 as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func btnPlayTapped(_ sender: Any) {
        if audioPlayer != nil {
            audioPlayer?.play()
        }
        else {
            playSelectedAudioFile()
        }
    }
    
    @IBAction func btnPauseTapped(_ sender: Any) {
        audioPlayer?.pause()
    }
    
    @IBAction func btnStopTapped(_ sender: Any) {
        audioPlayer?.stop()
    }
}

//MARK: UIDocumentPicker Delegate
extension AudioPlayerViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        selectedFileURL = urls.first
        lblFileTitle.text = (selectedFileURL!.path as NSString).lastPathComponent
    }
}

//MARK: AVAudioPlayer Delegate
extension AudioPlayerViewController: AVAudioPlayerDelegate {
    
}

