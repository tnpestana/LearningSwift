//
//  CategoryViewController.swift
//  ToDoListApp
//
//  Created by Tiago Pestana on 02/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController
{
    @IBOutlet weak var categoryTable: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let realm = try! Realm()
    var array: [Category] = []
    let categoryTableCellId = "CategoryTableCell"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        categoryTable.delegate = self
        categoryTable.dataSource = self
        
        //loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = categoryTable.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = array[indexPath.row]
        }
    }
    
    @IBAction func addBtnTapped(_ sender: Any)
    {
        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addTextField()
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
                self.array.append(newCategory)
                self.save(category: newCategory)
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
    
//    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest())
//    {
//        do
//        {
//            array = try context.fetch(request)
//        }
//        catch
//        {
//            print(error.localizedDescription)
//        }
//    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = categoryTable.dequeueReusableCell(withIdentifier: categoryTableCellId) as! CategoryTableCell
        cell.titleLbl.text = array[indexPath.row].title
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
//    {
//        if editingStyle == .delete
//        {
//            context.delete(array[indexPath.row])
//            array.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            save()
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
}

class CategoryTableCell: UITableViewCell
{
    @IBOutlet weak var titleLbl: UILabel!
}
