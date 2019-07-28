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
    @IBOutlet weak var filtersCollection: UICollectionView!
    
    var presentedImage: UIImage?
    var imagePicker: UIImagePickerController!
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var filters: [String] = CIFilter.filterNames(inCategory: "CICategoryColorEffect")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        filtersCollection.delegate = self
        filtersCollection.dataSource = self
        presentImagePicker()
    }
    
    func presentImagePicker()
    {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = ["public.image"]
        present(imagePicker, animated: true, completion: nil)
    }
    
    func applyFilter(name: String, image: UIImage) -> CIImage?
    {
        guard let originalCIImage = CIImage(image: image) else { return CIImage() }
        let filter = CIFilter(name: name)
        filter?.setValue(originalCIImage, forKey: kCIInputImageKey)
        //filter?.setValue(1.0, forKey: kCIInputIntensityKey)
        return filter?.outputImage
    }
}

extension PreviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        presentedImage = chosenImage
        imagePreview.contentMode = .scaleAspectFit
        imagePreview.image = presentedImage
        filtersCollection.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

extension PreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return filters.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCell
        if indexPath.row == 0
        {
            cell.imgView.image = presentedImage
            cell.titleLbl.text = "Original"
        }
        else
        {
            if let image = applyFilter(name: filters[indexPath.row - 1], image: presentedImage ?? UIImage())
            {
                cell.imgView.image = UIImage(ciImage: image)
            }
            else
            {
                cell.imgView.image = UIImage(named: "default_img")
            }
            cell.titleLbl.text = filters[indexPath.row - 1]
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
//    {
//        imagePreview.image =
//    }
}
