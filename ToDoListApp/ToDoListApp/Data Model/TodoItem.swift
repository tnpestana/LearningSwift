//
//  TodoItem.swift
//  ToDoListApp
//
//  Created by Tiago Pestana on 01/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import Foundation

class TodoItem
{
    var message: String!
    var isChecked: Bool = false
    
    init(message: String!)
    {
        self.message = message
    }
}
