//
//  ViewController.swift
//  CoreImageTutorial
//
//  Created by Tiago Pestana on 09/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import AVFoundation

class EntryViewController: UIViewController
{
    var chosenImage: UIImage?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier
        {
        case "goToFilterGallery":
            let destination = segue.destination as! PreviewViewController
            destination.originalImage = chosenImage
        default:
            break
        }
    }
    
    @IBAction func choosePictureTapped(_ sender: Any)
    {
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
}

extension EntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        chosenImage = image
        performSegue(withIdentifier: "goToFilterGallery", sender: self)
        dismiss(animated: true, completion: nil)
    }
}
