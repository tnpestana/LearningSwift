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
    var audioPlayer: AVAudioPlayer?
    var selectedFileURL: URL?
    var directoryFilesURLs: [URL]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblFileTitle.text = "No file selected"
        progressPlayback.progress = 0.0
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
//        if audioPlayer != nil {
//            generateTimer()
//            audioPlayer?.play()
//            return
//        }
        
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
            generateTimer()
            audioPlayer?.play()
        }
        catch {
            print("Couldn't load file")
        }
    }
    
    func stopPlayback() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0.0
        updateProgressView()
        timerPlayback?.invalidate()
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
        guard let directoryFilesURLs = directoryFilesURLs else { return }
        if directoryFilesURLs.count > 0 {
            for i in 0..<directoryFilesURLs.count {
                if directoryFilesURLs[i].path == selectedFileURL?.path {
                    stopPlayback()
                    #warning("possible bug if last file is picked")
                    selectedFileURL = directoryFilesURLs[i + 1]
                    lblFileTitle.text = (selectedFileURL!.path as NSString).lastPathComponent
                    startPlayback()
                    break
                }
            }
        }
    }
}

//MARK: UIDocumentPicker Delegate
extension AudioPlayerViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        selectedFileURL = urls.first
        let fileName = (selectedFileURL!.path as NSString).lastPathComponent
        let folderPath = (selectedFileURL!.path as NSString).replacingOccurrences(of: fileName, with: String())
        getFilesFromDirectory(path: folderPath)
        lblFileTitle.text = fileName
    }
    
    func getFilesFromDirectory(path: String) {
        let fileManager = FileManager.default
        let documentsURL = URL(fileURLWithPath: path, isDirectory: true)
        do {
            directoryFilesURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
}

//MARK: AVAudioPlayer Delegate
extension AudioPlayerViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopPlayback()
    }
}

