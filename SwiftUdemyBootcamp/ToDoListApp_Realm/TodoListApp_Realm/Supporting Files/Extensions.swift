//
//  Extensions.swift
//  TodoListApp_Realm
//
//  Created by Tiago Pestana on 07/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit

extension UINavigationController
{
    open override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
