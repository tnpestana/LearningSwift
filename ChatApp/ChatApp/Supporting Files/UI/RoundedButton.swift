//
//  UI.swift
//  ChatApp
//
//  Created by Tiago Pestana on 28/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit

class RoundedButton: UIButton
{
    var mainColor: UIColor = .lightGray //UIColor(red: 138, green: 166, blue: 255, alpha: 1.0)
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        shakeMotion()
    }
    
    func setup()
    {
        setupButton()
        setupShadow()
        
    }
    
    func setupButton()
    {
        layer.cornerRadius = layer.frame.height / 2
        layer.borderWidth = 1
        layer.borderColor = mainColor.cgColor
        backgroundColor = mainColor
        tintColor = .white
    }
    
    func setupShadow()
    {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowRadius = 0.8
        layer.shadowOpacity = 0.6
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    func shakeMotion()
    {
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = CGPoint(x: center.x - 8, y: center.y)
        animation.toValue = CGPoint(x: center.x + 8, y: center.y)
        animation.duration = 0.2
        animation.repeatCount = 2
        animation.autoreverses = true
        layer.add(animation, forKey: "position")
    }
}
