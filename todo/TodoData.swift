//
//  TodoData.swift
//  todo
//
//  Created by Mostafa Hendawi on 6/21/20.
//  Copyright © 2020 Hendawi. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class TodoData: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var dataLabel: UITextView!
    
    var todoTitle = ""
    var todoData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeFields()
        hideKeyboard()
        if todoTitle != "" {
            titleLabel.text = todoTitle
        }
        if todoData != "" {
            dataLabel.text = todoData
        }
        titleLabel.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent{
            self.navigationController?.popViewController(animated: true)
            if titleLabel.text == "" && dataLabel.text != ""{ //no title, data only
                TodoList().saveData(title: "Title", data: dataLabel.text)
            } else if titleLabel.text != "" && dataLabel.text == ""{ //title only, no data
                TodoList().saveData(title: titleLabel.text!, data: " ")
            } else if titleLabel.text == "" && dataLabel.text == ""{ //no title, no data
                showAlert()
            } else{
                TodoList().saveData(title: titleLabel.text!, data: dataLabel.text)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func customizeFields(){
        titleLabel.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        titleLabel.layer.borderColor = UIColor.white.cgColor
        titleLabel.layer.borderWidth = 1
        dataLabel.layer.borderColor = UIColor.white.cgColor
        dataLabel.layer.borderWidth = 1
    }
    
    func hideKeyboard(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    func showAlert(){
        let alert = UIAlertController(title: "No data to save dummy!", message: nil, preferredStyle: .alert)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: {Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                self.dismiss(animated: true, completion: nil)
                }})
        }
    }
}
