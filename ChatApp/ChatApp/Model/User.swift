//
//  Profile.swift
//  ChatApp
//
//  Created by Tiago Pestana on 21/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import Foundation

class User
{
    var username: String?
    var email: String?
    
    internal init(username: String?, email: String?)
    {
        self.username = username
        self.email = email
    }
}
