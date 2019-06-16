//
//  ChatMessageTableViewCell.swift
//  ChatApp
//
//  Created by Tiago Pestana on 16/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit

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
        
        viewMessage.layer.cornerRadius = 7
        imgSender.image = UIImage(named: "default_user")?.withRenderingMode(.alwaysTemplate)
        imgSender.tintColor = UIColor(rgb: 0x8AA6FF, alphaVal: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
