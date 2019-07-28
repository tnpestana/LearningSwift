//
//  CameraViewController.swift
//  CoreImageTutorial
//
//  Created by Tiago Pestana on 28/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController
{
    var imagePicker: UIImagePickerController?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupPreview()
    }
    
    func setupPreview()
    {
        imagePicker =  UIImagePickerController()
        imagePicker!.delegate = self
        imagePicker!.sourceType = .camera
        present(imagePicker!, animated: true, completion: nil)
    }
}

extension CameraViewController: UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        imagePicker?.dismiss(animated: true, completion: nil)
    }
}

extension CameraViewController: UINavigationControllerDelegate
{
    
}
