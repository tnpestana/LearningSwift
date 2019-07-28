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
        UIImageWriteToSavedPhotosAlbum(presentedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer)
    {
        if let error = error
        {
            // we got back an error!
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
    
    func apply(filter: CIFilter, image: UIImage) -> UIImage
    {
        guard let originalCIImage = CIImage(image: image) else { return originalImage }
        filter.setValue(originalCIImage, forKey: kCIInputImageKey)
        if let ciImage = filter.outputImage
        {
            return UIImage(ciImage: ciImage)
        }
        else
        {
            return originalImage
        }
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
