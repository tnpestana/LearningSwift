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
    
    var originalImage: UIImage!
    var presentedImage: UIImage!
    var filters: [CIFilter] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let filterNames: [String] = CIFilter.filterNames(inCategory: "CICategoryColorEffect")
        for key in filterNames
        {
            filters.append(CIFilter(name: key)!)
        }
        
        imagePreview.contentMode = .scaleAspectFit
        imagePreview.image = originalImage
        presentedImage = originalImage
        
        filtersCollection.delegate = self
        filtersCollection.dataSource = self
    }
    
    @IBAction func saveBtnTapped(_ sender: Any)
    {
        guard let imgData = presentedImage.jpegData(compressionQuality: 1.0) else { return }
        guard let image = UIImage(data: imgData) else { return }
        UIImageWriteToSavedPhotosAlbum(rotateUp(image), self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer)
    {
        if let error = error
        {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        else
        {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func rotateUp(_ image: UIImage) -> UIImage
    {
        if image.imageOrientation == .up { return image }
        UIGraphicsBeginImageContext(image.size)
        defer { UIGraphicsEndImageContext() }
        image.draw(in: CGRect(origin: .zero, size: image.size))
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    func apply(filter: CIFilter, image: UIImage) -> UIImage
    {
        let originalOrientation = image.imageOrientation
        let originalScale = image.scale
        let originalCIImage = CIImage(cgImage: image.cgImage!)
        filter.setValue(originalCIImage, forKey: kCIInputImageKey)
        if let ciImg = filter.outputImage
        {
            let context = CIContext(options: nil)
            if let imageRef = context.createCGImage(ciImg, from: originalCIImage.extent)
            {
                return UIImage(cgImage: imageRef, scale: originalScale, orientation: originalOrientation)
            }
        }
        return originalImage
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
            cell.imgView.image = originalImage
            cell.titleLbl.text = "Original"
        }
        else
        {
            //let image = apply(filter: filters[indexPath.row - 1], image: originalImage)
            cell.imgView.image = apply(filter: filters[indexPath.row - 1], image: originalImage)
            cell.titleLbl.text = filters[indexPath.row - 1].name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            presentedImage = originalImage
        }
        else
        {
            presentedImage = apply(filter: filters[indexPath.row - 1], image: originalImage)
        }
        imagePreview.image = presentedImage
    }
}
