//
//  ViewController.swift
//  todo
//
//  Created by Mostafa Hendawi on 6/20/20.
//  Copyright © 2020 Hendawi. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 13.0, *)
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        deleteAllData("Todo")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TodoList") as? TodoList
            let nc = UINavigationController(rootViewController: vc!)
            nc.modalPresentationStyle = .fullScreen
            self.present(nc, animated: false, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func deleteAllData(_ entity: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                managedContext.delete(object)
            }
        } catch let error {
            print("Detele all data in  error :", error)
        }
    }
    
}

