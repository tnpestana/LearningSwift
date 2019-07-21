//
//  ChatsListViewController.swift
//  ChatApp
//
//  Created by Tiago Pestana on 21/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ChatsListViewController: UIViewController
{
    var usersArray: [User] = []
    @IBOutlet weak var tableUsers: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        //self.performSegue(withIdentifier: "segueToChat", sender: self)
    }
    
    func retrieveChats()
    {
        SVProgressHUD.show()
        let usersDB = Database.database().reference().child("Users")
        usersDB.observe(.childAdded)
        { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let username = snapshotValue["Username"]
            let email = snapshotValue["Email"]
            
            let user = User(username: username, email: email)
            self.usersArray.append(user)
//            self.configureTableView()
//            self.tableMessages.reloadData()
            SVProgressHUD.dismiss()
        }
    }
}

extension ChatsListViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userChatId") as! UserChatTableCell
        cell.lblUsername.text = usersArray[indexPath.row].username
        return cell
    }
}

class UserChatTableCell: UITableViewCell
{
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
}
