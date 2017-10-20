//
//  HomeworkVC.swift
//  CGS_Diary
//
//  Created by James  on 5/9/17.
//  Copyright © 2017 Nathan Heldon. All rights reserved.
//

import UIKit

class HomeworkVC: UIViewController, UITextFieldDelegate {
    
    // Outlets for storyboard:
    @IBOutlet weak var homeworkInput: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var overdueTimer = Timer()
    
    var countdown2: Timer!
    
    var timeLeft = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.homeworkInput.delegate = self
        
        // Disable due dates before the current date
        datePicker.minimumDate = Date()
        
        // Close keyboard when screen is tapped
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Manage new homework to home view controller
    @IBAction func InputHomework(_ sender: Any) {
        
        // If there is text for
        // the homework task
        if homeworkInput.text != "" {
            
            // ViewController referencing:
            let navigationVC = self.navigationController!
            let homeVC = navigationVC.viewControllers[navigationVC.viewControllers.count - 2] as! ViewController
            
            let newHomework = self.homeworkInput.text!
            let newDueDate = self.datePicker.date
            
            // Stop timer...
            homeVC.countdown.invalidate()
            
            // Insert new task and it's due date
            homeVC.homeworkTasks.insert("\(newHomework)", at: 0)
            homeVC.homeworkDueDates.insert(newDueDate, at: 0)
            
            // Save input
            UserDefaults.standard.set(homeVC.homeworkTasks, forKey: "savedHomeworkTasks")
            UserDefaults.standard.set(homeVC.homeworkDueDates, forKey: "savedHomeworkDueDates")
            
            homeVC.checkHomework()
            
            homeVC.tableView.reloadData()
            
            // Start timer again...
            homeVC.startCountdownTimer()
            
            // Clear the textfield for future inputs
            homeworkInput.text = ""
            
            alert("New homework task added!")
            
        } else {
            
            // If no homework task was inputted,
            alert("Please enter a homework task.")
            
        }
        
    }
    
    // alert func, takes in message string
    func alert(_ message: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Dismiss",
                                   style: .default,
                                   handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // Close keyboard when return button is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
