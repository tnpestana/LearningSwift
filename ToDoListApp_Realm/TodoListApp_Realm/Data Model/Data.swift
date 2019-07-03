//
//  Data.swift
//  TodoListApp_Realm
//
//  Created by Tiago Pestana on 03/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import Foundation
import RealmSwift

class Person: Object
{
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
