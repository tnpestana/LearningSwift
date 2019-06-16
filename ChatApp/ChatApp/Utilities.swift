//
//  Utilities.swift
//  ChatApp
//
//  Created by Tiago Pestana on 16/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit

extension UIViewController
{
    func showErrorAlert(message: String)
    {
        print("error: \(message)")
        let alert = UIAlertController(title: "Error",
                                      message: "\(message)",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
