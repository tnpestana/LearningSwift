//
//  AudioPlayerViewController.swift
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
    @IBOutlet weak var btnNext: UIButton!
    
    var timerPlayback: Timer?
    var playersQueue: [AVAudioPlayer]?
    var audioPlayer: AVAudioPlayer?
    var directoryFilesURLs: [URL]?
    
    var selectedFileURL: URL? {
        didSet {
            if let url = selectedFileURL {
                UserDefaults().set(url.path as NSString, forKey: "selectedFileUrl")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioSession()
        if let selectedFileUrlPath = UserDefaults.standard.object(forKey:"selectedFileUrl") as? NSString {
            selectedFileURL = URL(fileURLWithPath: selectedFileUrlPath as String)
            lblFileTitle.text = selectedFileUrlPath.lastPathComponent
            getFilesFromDirectory(path: selectedFileUrlPath.replacingOccurrences(of: selectedFileUrlPath.lastPathComponent, with: String()))
        }
        else {
            lblFileTitle.text = "No file selected"
        }
        progressPlayback.progress = 0.0
    }
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        }
        catch {
            print("Couldn't setup audio session")
        }
    }
    
    func generateTimer() {
        timerPlayback = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateProgressView),
            userInfo: nil,
            repeats: true)
    }
    
    func startPlayback() {
        guard let fileURL = selectedFileURL else {
            let alert = UIAlertController(title: "Uh oh", message: "No file selected", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying { stopPlayback() }
        do {
            let newAudioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            newAudioPlayer.prepareToPlay()
            generateTimer()
            newAudioPlayer.play()
            audioPlayer = newAudioPlayer
        }
        catch {
            print("Couldn't load file")
            audioPlayer = nil
            selectedFileURL = nil
            lblFileTitle.text = "No file selected"
        }
    }
    
    func stopPlayback() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0.0
        updateProgressView()
        timerPlayback?.invalidate()
    }
    
    func playNextFile() {
        guard let directoryFilesURLs = directoryFilesURLs else { return }
        if directoryFilesURLs.count > 0 {
            for i in 0..<directoryFilesURLs.count {
                if directoryFilesURLs[i].path == selectedFileURL?.path {
                    if i + 1 == directoryFilesURLs.count {
                       selectedFileURL = directoryFilesURLs[0]
                    }
                    else {
                        selectedFileURL = directoryFilesURLs[i + 1]
                    }
                    lblFileTitle.text = (selectedFileURL!.path as NSString).lastPathComponent
                    if (audioPlayer?.isPlaying ?? false) {
                        stopPlayback()
                        startPlayback()
                    }
                    
                    break
                }
            }
        }
    }
    
    @objc func updateProgressView() {
        if let audioPlayer = audioPlayer {
            UIView.animate(withDuration: 1) {
                self.progressPlayback.setProgress(Float(audioPlayer.currentTime / audioPlayer.duration), animated: true)
            }
        }
    }
}

//MARK: Button Actions
extension AudioPlayerViewController {
    @IBAction func btnOpenFileTapped(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeMP3 as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func btnPlayTapped(_ sender: Any) {
        if audioPlayer != nil && audioPlayer!.currentTime != 0.0 {
            generateTimer()
            audioPlayer!.play()
            return
        }
        startPlayback()
    }
    
    @IBAction func btnPauseTapped(_ sender: Any) {
        audioPlayer?.pause()
        timerPlayback?.invalidate()
    }
    
    @IBAction func btnStopTapped(_ sender: Any) {
        stopPlayback()
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        playNextFile()
    }
}

//MARK: Document Picker Delegate
extension AudioPlayerViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        selectedFileURL = urls.first
        let fileName = (selectedFileURL!.path as NSString).lastPathComponent
        let folderPath = (selectedFileURL!.path as NSString).replacingOccurrences(of: fileName, with: String())
        getFilesFromDirectory(path: folderPath)
        lblFileTitle.text = fileName
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying { startPlayback() }
    }
    
    func getFilesFromDirectory(path: String) {
        let fileManager = FileManager.default
        let documentsURL = URL(fileURLWithPath: path, isDirectory: true)
        do {
            directoryFilesURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            directoryFilesURLs = directoryFilesURLs?.sorted(by: {
                ($0.path as NSString).lastPathComponent.lowercased() < ($1.path as NSString).lastPathComponent.lowercased()
            })
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
}

//MARK: Audio Player Delegate
extension AudioPlayerViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopPlayback()
    }
}

