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
    
    func applyFilter(image: UIImage) -> CIImage?
    {
        //let context = CIContext()
        guard let originalCIImage = CIImage(image: image) else { return CIImage() }
        return sepiaFilter(originalCIImage, intensity: 1.0)
    }
    
    func sepiaFilter(_ input: CIImage, intensity: Double) -> CIImage?
    {
        let sepiaFilter = CIFilter(name:"CISepiaTone")
        sepiaFilter?.setValue(input, forKey: kCIInputImageKey)
        sepiaFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        return sepiaFilter?.outputImage
    }
}

extension PreviewViewController: UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePreview.contentMode = .scaleAspectFit
        imagePreview.image = UIImage(ciImage: applyFilter(image: chosenImage)!)
        dismiss(animated: true, completion: nil)
    }
}

extension PreviewViewController: UINavigationControllerDelegate
{
    
}
