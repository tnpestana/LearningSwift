//
//  ViewController.swift
//  SigningAndVerifyingExample
//
//  Created by Tiago Pestana on 16/02/2020.
//  Copyright © 2020 Tiago Pestana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var btnSignMessage: UIButton!
    @IBOutlet weak var lblSignature: UILabel!
    @IBOutlet weak var btnVerifySignature: UIButton!
    @IBOutlet weak var lblVerificationStatus: UILabel!
    
    var dataB64: String?
    var signatureB64: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSignAndVerifyTapped() {
        guard let message = tfMessage.text, !message.isEmpty else { return }
        var privateKey: SecKey?
        privateKey = CryptoHandler.loadKey(name: CryptoHandler.signingPrivateKeyTag)
        if privateKey == nil {
            privateKey = CryptoHandler.generateSingningKey()
        }
        guard let result = CryptoHandler.signMessage(message: message) else {
            lblSignature.text = "Unable to perform operation"
            return
        }
        dataB64 = result.data
        signatureB64 = result.signature
        lblSignature.text = "data: \(dataB64 ?? "")\nsignature: \(signatureB64 ?? "")"
    }
    
    @IBAction func btnVerifySignatureTapped() {
        guard
            let data = dataB64,
            let signature = signatureB64,
            let privateKey = CryptoHandler.loadKey(name: CryptoHandler.signingPrivateKeyTag),
            let publibKey = CryptoHandler.getPublicKey(with: privateKey)
        else {
            return
        }
        
        if CryptoHandler.verifySignature(publicKey: publibKey, data: data, signature: signature) {
            lblVerificationStatus.text = "Signing verified :)"
        }
        else {
            lblVerificationStatus.text = "Signing unverified :("
        }
    }
}

