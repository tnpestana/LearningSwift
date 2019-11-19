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

    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnOpenFile: UIButton!
    
    var audioPlayer: AVAudioPlayer?
    var selectedFileURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
//        guard let path = Bundle.main.path(forResource: "Untitled", ofType: "mp3") else {
//            print("file not found")
//            return
//        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.play()
        } catch {
            print("couldn't load file")
        }
    }
    
    @IBAction func btnPauseTapped(_ sender: Any) {
        audioPlayer?.pause()
    }
}

extension ViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        selectedFileURL = urls[0]
    }
}

