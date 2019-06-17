//
//  ChatMessageTableViewCell.swift
//  ChatApp
//
//  Created by Tiago Pestana on 16/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import Firebase

class ChatMessageTableViewCell: UITableViewCell
{
    @IBOutlet weak var stackMain: UIStackView!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewSender: UIView!
    @IBOutlet weak var imgSender: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        viewMessage.layer.borderWidth = 1
        viewMessage.layer.borderColor = UIColor(rgb: 0x007AFF, alphaVal: 1.0).cgColor
        viewMessage.layer.cornerRadius = 15
        imgSender.image = UIImage(named: "default_user")?.withRenderingMode(.alwaysTemplate)
        imgSender.tintColor = UIColor(rgb: 0x007AFF/*0x8AA6FF*/, alphaVal: 1.0)
    }
    
    func setup(message: Message)
    {
        lblMessage.text = message.body
        if message.sender == Auth.auth().currentUser?.email
        {
            lblMessage.textColor = .white
            viewMessage.backgroundColor = UIColor(rgb: 0x007AFF, alphaVal: 1.0)
            if let myView = stackMain.subviews.first
            {
                stackMain.removeArrangedSubview(myView)
                stackMain.setNeedsLayout()
                stackMain.layoutIfNeeded()
                stackMain.insertArrangedSubview(myView, at: 1)
                stackMain.setNeedsLayout()
            }
        }
        else
        {
            viewMessage.backgroundColor = .white
            lblMessage.textColor = .black
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
