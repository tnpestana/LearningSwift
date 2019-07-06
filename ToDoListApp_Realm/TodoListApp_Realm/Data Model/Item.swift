//
//  Iten.swift
//  TodoListApp_Realm
//
//  Created by Tiago Pestana on 04/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object
{
    @objc dynamic var done: Bool = false
    @objc dynamic var message: String = ""
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
