//
//  CameraViewController.swift
//  CoreImageTutorial
//
//  Created by Tiago Pestana on 28/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import AVFoundation

class PreviewViewController: UIViewController
{
    @IBOutlet weak var imagePreview: UIImageView!
    
    var imagePicker: UIImagePickerController!
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupPreview()
    }
    
    func setupPreview()
    {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = ["public.image"]
        present(imagePicker, animated: true, completion: nil)
    }
}

extension PreviewViewController: UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePreview.contentMode = .scaleAspectFit
        imagePreview.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
}

extension PreviewViewController: UINavigationControllerDelegate
{
    
}
