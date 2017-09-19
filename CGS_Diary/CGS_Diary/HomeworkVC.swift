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
    @IBOutlet weak var homeworkLabel: UILabel!
    
    var overdueTimer = Timer()
    var countdown: Timer!
    var timeLeft = 0
    var newHomeworkTasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.homeworkInput.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func InputHomework(_ sender: Any) {
        
        if homeworkInput.text != "" {
            let newHomework = self.homeworkInput.text!
            self.homeworkLabel.text = newHomework
            
            newHomeworkTasks.insert("\(newHomework)", at: 0)
            
            alert("New homework task added!")
            
            homeworkInput.text = ""
            
            self.timeLeft = Int(self.datePicker.date.timeIntervalSinceNow)
            countdown = Timer.scheduledTimer(timeInterval: 1,
                                             target: self,
                                             selector: (#selector(HomeworkVC.updateTimer)),
                                             userInfo: nil,
                                             repeats: true)
        } else {
            
            alert("Please enter a homework task.")
            
        }
        
        
    }
    
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
    
    // NB: overdue not working atm
    func updateTimer() {
        
        timeLeft -= 1
        
        // overdue?
        if self.timeLeft <= 0 {
            countdown.invalidate()
            self.timeLeft = 0
            self.homeworkLabel.textColor = UIColor.red
            print("OVERDUE")
        } else {
            print(self.timeLeft)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let navigationVC = self.navigationController!
        let homeVC = navigationVC.topViewController as!ViewController
        newHomeworkTasks.append(contentsOf: homeVC.homeworkTasks)
        homeVC.homeworkTasks = newHomeworkTasks
        
        UserDefaults.standard.set(homeVC.homeworkTasks, forKey: "savedHomeworkTasks")
        
        homeVC.checkHomework()
        homeVC.tableView.reloadData()
        
        // NB: Most recently added homework is first in array, 
        //     except overdue which overtakes it
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
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
