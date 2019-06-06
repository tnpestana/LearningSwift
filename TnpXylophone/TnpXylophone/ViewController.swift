//
//  ViewController.swift
//  TnpXylophone
//
//  Created by Tiago Pestana on 11/05/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController
{
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func notePressed(_ sender: UIButton)
    {
        guard let noteURL = Bundle.main.url(forResource: "note" + String(sender.tag + 1), withExtension: "wav") else
        {
            return
        }
        
        do
        {
            try audioPlayer = AVAudioPlayer(contentsOf: noteURL)
        }
        catch
        {
            print(error)
        }
        
        audioPlayer?.play()
    }
}

extension ViewController: UIApplicationDelegate
{
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        audioPlayer?.stop()
    }
}

