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
    internal init(sender: String?, body: String?)
    {
        self.sender = sender
        self.body = body
    }
    
    var sender: String?
    var body: String?
}
