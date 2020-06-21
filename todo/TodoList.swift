//
//  TodoList.swift
//  todo
//
//  Created by Mostafa Hendawi on 6/20/20.
//  Copyright © 2020 Hendawi. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 13.0, *)
class TodoList: UITableViewController {
    
    let cellId = "todoCell"
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavBar()
        tableView.rowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TodoCell else {
            fatalError("an error happened")
        }
        let person = people[indexPath.row]
        cell.titleLabel.text = person.value(forKeyPath: "title") as? String
        cell.dataLabel.text = person.value(forKeyPath: "data") as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TodoData") as? TodoData else {
            fatalError("an error happened")
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Todo")
        do{
            let results = try managedContext.fetch(fetchRequest)
            let todo = results[indexPath.row]
            let title = todo.value(forKey: "title") as! String
            let data = todo.value(forKey: "data") as! String
            vc.todoTitle = title
            vc.todoData = data
        } catch let error {
            print("an error occurred: \(error)")
        }
        self.navigationController?.pushViewController(vc, animated: true)
        deleteObject(index: indexPath.row)
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        deleteObject(index: indexPath.row)
        tableView.reloadData()
    }
    
    func customizeNavBar(){
        navigationController?.navigationBar.barTintColor = UIColor.init(hex: "1D1D1D")
        navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "My Todo List"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 22)!]
        tableView.backgroundColor = UIColor.init(hex: "1D1D1D")
    }
    
    func deleteObject(index: Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Todo")
        do{
            let results = try managedContext.fetch(fetchRequest)
            managedContext.delete(results[index])
            try managedContext.save()
        } catch let error{
            print("an error occurred: \(error)")
        }
    }
    
    func loadData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Todo")
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveData(title: String, data: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Todo", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(title, forKeyPath: "title")
        person.setValue(data, forKeyPath: "data")
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}


extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
