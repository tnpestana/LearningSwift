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
    
    var presentedImage: UIImage!
    var filters: [CIFilter] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let filterNames: [String] = CIFilter.filterNames(inCategory: "CICategoryColorEffect")
        for key in filterNames { filters.append(CIFilter(name: key)!) }
        
        imagePreview.contentMode = .scaleAspectFit
        imagePreview.image = presentedImage
        
        filtersCollection.delegate = self
        filtersCollection.dataSource = self
    }
    
    func apply(filter: CIFilter, image: UIImage) -> CIImage?
    {
        guard let originalCIImage = CIImage(image: image) else { return CIImage() }
        filter.setValue(originalCIImage, forKey: kCIInputImageKey)
        return filter.outputImage
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
            if let image = apply(filter: filters[indexPath.row - 1], image: presentedImage)
            {
                cell.imgView.image = UIImage(ciImage: image)
            }
            else
            {
                cell.imgView.image = presentedImage
            }
            cell.titleLbl.text = filters[indexPath.row - 1].name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            imagePreview.image = presentedImage
        }
        else
        {
            imagePreview.image = UIImage(ciImage: apply(filter: filters[indexPath.row - 1], image: presentedImage) ?? CIImage())
        }
    }
}
