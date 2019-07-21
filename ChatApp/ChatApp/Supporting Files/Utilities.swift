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
    func showAlert(message: String)
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

extension UIView
{
    var firstResponder: UIView?
    {
        guard !isFirstResponder else { return self }
        for subview in subviews
        {
            if let firstResponder = subview.firstResponder
            {
                return firstResponder
            }
        }
        
        return nil
    }
}

extension UIColor
{
    convenience init(rgb: UInt, alphaVal: CGFloat)
    {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: alphaVal
        )
    }
}
