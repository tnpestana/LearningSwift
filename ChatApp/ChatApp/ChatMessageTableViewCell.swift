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
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgSender: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        viewMessage.layer.cornerRadius = 6
//        imgSender.image = UIImage(named: "default_user")?.withRenderingMode(.alwaysTemplate)
//        imgSender.tintColor = UIColor(red: 138, green: 166, blue: 255, alpha: 0) // hex: #8AA6FF
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
