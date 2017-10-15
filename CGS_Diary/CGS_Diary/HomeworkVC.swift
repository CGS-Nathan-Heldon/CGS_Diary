//
//  HomeworkVC.swift
//  CGS_Diary
//
//  Created by James  on 5/9/17.
//  Copyright © 2017 Nathan Heldon. All rights reserved.
//

import UIKit

class HomeworkVC: UIViewController, UITextFieldDelegate {
    
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 'submit' button tapped -> manage new homework 
    //  to home ViewControler, alerts, countdown...
    @IBAction func InputHomework(_ sender: Any) {
        
        
        if homeworkInput.text != "" {
            
            let newHomework = self.homeworkInput.text!
            let newDueDate = self.datePicker.date
            
            print("NewDueDate: \(newDueDate)")
            
            
            let navigationVC = self.navigationController!
            let homeVC = navigationVC.viewControllers[navigationVC.viewControllers.count - 2] as! ViewController
            
            // NB: Most recently added homework is first in array,
            //     except overdue which overtakes it
            
            homeVC.countdown.invalidate()
            
            homeVC.homeworkTasks.insert("\(newHomework)", at: 0)
            homeVC.homeworkDueDates.insert(newDueDate, at: 0)
            
            
            // homeVC.homeworkDueDates.sort(by: { $0.compare($1) == .orderedDescending }) // Order by date?
            
            UserDefaults.standard.set(homeVC.homeworkTasks, forKey: "savedHomeworkTasks")
            UserDefaults.standard.set(homeVC.homeworkDueDates, forKey: "savedHomeworkDueDates")
            
            homeVC.checkHomework()
            
            homeVC.tableView.reloadData()
            
            homeVC.checkIfOverdue()
            
            alert("New homework task added!")
            
            // Clear the textfield
            homeworkInput.text = ""
            
        } else {
            
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
    
    // Close keyboard when background is tapped
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        homeworkInput.resignFirstResponder()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
