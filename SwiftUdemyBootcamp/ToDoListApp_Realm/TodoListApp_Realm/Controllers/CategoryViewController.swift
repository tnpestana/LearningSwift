//
//  CategoryViewController.swift
//  ToDoListApp
//
//  Created by Tiago Pestana on 02/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: UIViewController
{
    @IBOutlet weak var categoryTable: UITableView!
    
    lazy var realm = try! Realm()
    var categories: Results<Category>?
    let categoryTableCellId = "CategoryTableCell"
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        categoryTable.delegate = self
        categoryTable.dataSource = self
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = ContrastColorOf(.black, returnFlat: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = categoryTable.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    @IBAction func addBtnTapped(_ sender: Any)
    {
        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        var textField = UITextField()
        alert.addTextField
        { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "OK", style: .default)
        { (action) in
            if !textField.text!.isEmpty
            {
                let newCategory = Category()
                newCategory.title = textField.text!
                newCategory.color = UIColor.randomFlat.hexValue()
                self.save(category: newCategory)
                self.categoryTable.reloadData()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func edit(category: Category)
    {
        let alert = UIAlertController(title: "Edit category", message: nil, preferredStyle: .alert)
        var textField = UITextField()
        alert.addTextField
        { (alertTextField) in
            alertTextField.text = category.title
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
                        category.title = textField.text!
                    }
                }
                catch
                {
                    print(error.localizedDescription)
                }
                self.categoryTable.reloadData()
            }
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func save(category: Category)
    {
        do
        {
            try realm.write
            {
                realm.add(category)
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func delete(category: Category)
    {
        do
        {
            try realm.write
            {
                realm.delete(category)
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func loadCategories()
    {
        categories = realm.objects(Category.self)
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = categoryTable.dequeueReusableCell(withIdentifier: categoryTableCellId) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = categories?[indexPath.row].title
        if let color = UIColor(hexString: categories?[indexPath.row].color ?? "#FFFFFF")
        {
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "goToItems", sender: self)
        categoryTable.deselectRow(at: indexPath, animated: true)
    }
}

extension CategoryViewController: SwipeTableViewCellDelegate
{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]?
    {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete")
        { _, _ in
            if let category = self.categories?[indexPath.row]
            {
                self.delete(category: category)
            }
            self.categoryTable.reloadData()
        }
        let editAction = SwipeAction(style: .default, title: "Edit")
        { _, _ in
            if let category = self.categories?[indexPath.row]
            {
                self.edit(category: category)
            }
        }
        return [deleteAction, editAction]
    }
}
