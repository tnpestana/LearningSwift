//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Tiago Pestana on 16/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController
{
    @IBOutlet weak var tableMessages: UITableView!
    
    let messageArray = ["First message", "Second Message", "Third Message"]
    let chatMessageCellId: String =  "ChatMessageTableViewCell"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        
        tableMessages.register(UINib(nibName: "ChatMessageTableViewCell", bundle: nil), forCellReuseIdentifier: chatMessageCellId)
        tableMessages.delegate = self
        tableMessages.dataSource = self
        configureTableView()
    }
    
    @IBAction func logOutTapped(_ sender: Any)
    {
        do
        {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        }
        catch
        {
            self.showAlert(message: error.localizedDescription)
        }
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource
{
    func configureTableView()
    {
        tableMessages.rowHeight = UITableView.automaticDimension
        tableMessages.estimatedRowHeight = 120.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell =  tableView.dequeueReusableCell(withIdentifier: chatMessageCellId) as! ChatMessageTableViewCell
        cell.lblMessage.text = messageArray[indexPath.row]
        return cell
    }
}
