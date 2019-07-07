//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Tiago Pestana on 24/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListViewController: UIViewController
{
    @IBOutlet weak var navbarItem: UINavigationItem!
    @IBOutlet weak var todoTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var realm = try! Realm()
    var items: Results<Item>?
    var selectedCategory: Category?
    {
        didSet
        {
            loadItems()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        navbarItem.title = selectedCategory?.title
        todoTable.delegate = self
        todoTable.dataSource = self
        searchBar.delegate = self
    }
    
    @IBAction func addItemTapped(_ sender: Any)
    {
        let alert = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        var textField = UITextField()
        alert.addTextField()
        { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "OK", style: .default)
        { (action) in
            if !textField.text!.isEmpty
            {
                if let category = self.selectedCategory
                {
                    do
                    {
                        try self.realm.write
                        {
                            let newItem = Item()
                            newItem.message = textField.text!
                            newItem.dateCreated = Date()
                            category.items.append(newItem)
                        }
                    }
                    catch
                    {
                        print(error.localizedDescription)
                    }
                }
                self.todoTable.reloadData()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func delete(item: Item)
    {
        do
        {
            try realm.write
            {
                realm.delete(item)
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func edit(item: Item)
    {
        let alert = UIAlertController(title: "Edit category", message: nil, preferredStyle: .alert)
        var textField = UITextField()
        alert.addTextField()
        { (alertTextField) in
                alertTextField.text = item.message
                textField = alertTextField
        }
        let action = UIAlertAction(title: "OK", style: .default)
        { (action) in
            if !textField.text!.isEmpty
            {
                do
                {
                    try self.realm.write
                    {
                        item.message = textField.text!
                    }
                }
                catch
                {
                    print(error.localizedDescription)
                }
                self.todoTable.reloadData()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems()
    {
        items = selectedCategory?.items.sorted(byKeyPath: "message", ascending: true)
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = todoTable.dequeueReusableCell(withIdentifier: "ItemTableCell") as! SwipeTableViewCell
        cell.delegate = self
        if let item = items?[indexPath.row]
        {
            cell.textLabel!.text = item.message
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory?.color ?? "#FFFFFF")?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count))
            {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let item = items?[indexPath.row]
        {
            do
            {
                try realm.write
                {
                    item.done = !item.done
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
        todoTable.reloadData()
        todoTable.deselectRow(at: indexPath, animated: true)
    }
}

extension TodoListViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if !searchBar.text!.isEmpty
        {
            items = items?.filter("message CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
            todoTable.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text!.count == 0
        {
            loadItems()
            todoTable.reloadData()
            DispatchQueue.main.async
            {
                searchBar.resignFirstResponder()
            }
        }
    }
}

extension TodoListViewController: SwipeTableViewCellDelegate
{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]?
    {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete")
        { _, _ in
            if let item = self.items?[indexPath.row]
            {
                self.delete(item: item)
            }
            self.todoTable.reloadData()
        }
        let editAction = SwipeAction(style: .default, title: "Edit")
        { _, _ in
            if let item = self.items?[indexPath.row]
            {
                self.edit(item: item)
            }
        }
        return [deleteAction, editAction]
    }
}
