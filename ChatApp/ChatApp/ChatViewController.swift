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
    @IBOutlet weak var viewSendMessage: UIView!
    @IBOutlet weak var bottomConstraintSendMessage: NSLayoutConstraint!
    @IBOutlet weak var txtNewMessage: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    var messageArray: [Message] = []
    let chatMessageCellId: String =  "ChatMessageTableViewCell"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        
        tableMessages.register(UINib(nibName: "ChatMessageTableViewCell", bundle: nil), forCellReuseIdentifier: chatMessageCellId)
        tableMessages.delegate = self
        tableMessages.dataSource = self
        tableMessages.separatorStyle = .none
        configureTableView()
        retrieveMessages()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tableMessages.isUserInteractionEnabled = true
        tableMessages.addGestureRecognizer(tapGesture)
        
        //txtNewMessage.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func handleKeyboardNotification(notification: Notification)
    {
        if let userInfo = notification.userInfo
        {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            print(keyboardFrame.height)
            
            UIView.animate(withDuration: 0.5)
            {
                self.bottomConstraintSendMessage.constant = keyboardFrame.height - UIApplication.shared.keyWindow!.safeAreaInsets.bottom
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func hideKeyboard()
    {
        UIView.animate(withDuration: 0.5)
        {
            self.bottomConstraintSendMessage.constant = 0
            self.txtNewMessage.resignFirstResponder()
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func tableViewTapped()
    {
        hideKeyboard()
    }
    
    @IBAction func sendTapped(_ sender: Any)
    {
        guard let body = txtNewMessage.text else { return }
        if body.isEmpty { return }
        
        txtNewMessage.endEditing(true)
        txtNewMessage.isEnabled = false
        btnSend.isEnabled = false
        
        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email,
                                 "Body" : body]
        
        messagesDB.childByAutoId().setValue(messageDictionary)
        { (error, reference) in
            if let error = error
            {
                self.showAlert(message: error.localizedDescription)
            }
            else
            {
                self.txtNewMessage.text = ""
                self.txtNewMessage.isEnabled = true
                self.btnSend.isEnabled = true
                self.hideKeyboard()
            }
        }
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
    
    func retrieveMessages()
    {
        let messagesDB = Database.database().reference().child("Messages")
        messagesDB.observe(.childAdded)
        { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let body = snapshotValue["Body"]
            let sender = snapshotValue["Sender"]
            
            let message = Message(sender: sender, body: body)
            self.messageArray.append(message)
            
            self.configureTableView()
            self.tableMessages.reloadData()
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
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell =  tableView.dequeueReusableCell(withIdentifier: chatMessageCellId) as! ChatMessageTableViewCell
        cell.lblMessage.text = messageArray[indexPath.row].body
        if messageArray[indexPath.row].sender == Auth.auth().currentUser?.email
        {
            if let myView = cell.stackMain.subviews.first {
                cell.stackMain.removeArrangedSubview(myView)
                cell.stackMain.setNeedsLayout()
                cell.stackMain.layoutIfNeeded()
                
                cell.stackMain.insertArrangedSubview(myView, at: 1)
                cell.stackMain.setNeedsLayout()
            }
            cell.lblMessage.textColor = .white
            cell.viewMessage.backgroundColor = UIColor(rgb: 0x007AFF, alphaVal: 1.0)
        }
        
        return cell
    }
}
