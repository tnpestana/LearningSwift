//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Tiago Pestana on 24/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UIViewController
{
    @IBOutlet weak var navbarItem: UINavigationItem!
    @IBOutlet weak var todoTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
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
        
        //searchBar.delegate = self
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
                            category.items.append(newItem)
                            self.save(item: newItem)
                            
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
    
    func save(item: Item)
    {
        
    }
    
    func loadItems()
    {
        items = selectedCategory?.items.sorted(byKeyPath: "message", ascending: true)
    }
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = todoTable.dequeueReusableCell(withIdentifier: "idCell") as! TodoTableCell
        let item = items?[indexPath.row]
        cell.todoLbl.text = item?.message
        cell.accessoryType = (item?.done ?? false) ? .checkmark : .none
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        let item = items?[indexPath.row]
//        item.done = !item.done
//        todoTable.cellForRow(at: indexPath)?.accessoryType = item.done ? .checkmark : .none
//        save(item: item)
//        todoTable.deselectRow(at: indexPath, animated: true)
//    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
//    {
//        if editingStyle == .delete
//        {
//            context.delete(array[indexPath.row])
//            array.remove(at: indexPath.row)
//            todoTable.deleteRows(at: [indexPath], with: .fade)
//            saveData()
//        }
//    }
}

//extension ToDoListViewController: UISearchBarDelegate
//{
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
//    {
//        if !searchBar.text!.isEmpty
//        {
//            let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
//            request.predicate = NSPredicate(format: "message CONTAINS[cd] %@", searchBar.text!)
//            request.sortDescriptors = [NSSortDescriptor(key: "message", ascending: true)]
//
//            loadData(with: request)
//
//            todoTable.reloadData()
//        }
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
//    {
//        if searchBar.text!.count == 0
//        {
//            loadData()
//            todoTable.reloadData()
//
//            DispatchQueue.main.async
//            {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}

class TodoTableCell: UITableViewCell
{
    @IBOutlet weak var todoLbl: UILabel!
}
