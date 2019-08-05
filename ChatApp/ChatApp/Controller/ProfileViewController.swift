//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Tiago Pestana on 21/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class ProfileViewController: UIViewController {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var imagePicker: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        lblName.text = Auth.auth().currentUser?.email
        //imgProfile.image = Auth.auth().currentUser?.avatar
    }

    @IBAction func changePictureTapped(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.sourceType = .camera
        imagePicker?.mediaTypes = ["public.image"]
        present(imagePicker!, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        dismiss(animated: true, completion: {
            self.imgProfile.image = image
        })
    }
}
