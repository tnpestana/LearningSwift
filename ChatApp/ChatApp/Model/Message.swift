//
//  MessageDataModel.swift
//  ChatApp
//
//  Created by Tiago Pestana on 16/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import Foundation

class Message
{
    var sender: String?
    var body: String?
    var date: String?
    var dateLblHidden: Bool?
    
    internal init(sender: String?, body: String?, date: String?)
    {
        self.sender = sender
        self.body = body
        self.date = date
        self.dateLblHidden = true
    }
}
