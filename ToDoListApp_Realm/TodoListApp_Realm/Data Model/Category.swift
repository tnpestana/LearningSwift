//
//  Category.swift
//  TodoListApp_Realm
//
//  Created by Tiago Pestana on 04/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object
{
    @objc dynamic var title: String = ""
    let items = List<Item>()
}
