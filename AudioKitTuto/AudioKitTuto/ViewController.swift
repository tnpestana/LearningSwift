//
//  ViewController.swift
//  AudioKitTuto
//
//  Created by Tiago Pestana on 03/01/2020.
//  Copyright © 2020 Tiago Pestana. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class ViewController: UIViewController {
    var vKeyboard: AKKeyboardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadKeyboard()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateKeyboardFrame(CGRect(size: size))
    }
    
    func loadKeyboard() {
        if vKeyboard == nil {
            vKeyboard = AKKeyboardView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height
                / 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2))
            self.view.addSubview(vKeyboard)
        }
    }
    
    func updateKeyboardFrame(_ rect: CGRect) {
        if vKeyboard != nil {
            vKeyboard.frame = CGRect(x: 0, y: rect.height
                / 2, width: rect.width, height: rect.height / 2)
        }
    }
}

