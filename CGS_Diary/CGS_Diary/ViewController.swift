//
//  ViewController.swift
//  CGS_Diary
//
//  Created by Nathan Heldon on 14/8/17.
//  Copyright © 2017 Nathan Heldon. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var newHomeworkBtn: UIButton!
    @IBOutlet weak var moreHomeworkBtn: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var profilePicBtn: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateDisplay: UILabel!
    
    
    // Hide menu bar
    var menuShowing = false
    var countdown: Timer!
    let dateFormatter = DateFormatter()
    let cellReuseID = "homework"
    
    
    //var profilePic = UserDefaults.standard.object(forKey: "savedProfilePic") as? UIImage?
    
    var homeworkTasks = UserDefaults.standard.stringArray(forKey: "savedHomeworkTasks") ?? [String]()
    var homeworkDueDates = UserDefaults.standard.array(forKey: "savedHomeworkDueDates") as? [Date] ?? [Date]()
    
    var homeworkCounter = UserDefaults.standard.integer(forKey: "savedHomeworkCounter")
    var currentHomeworkCounter = UserDefaults.standard.integer(forKey: "savedCurrentHomeworkCounter")
    
    var username = UserDefaults.standard.string(forKey: "savedUsername")!
    
    //var homeworkTasks = [String]()
    //var homeworkDueDates = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        if (self.profilePic != nil) {
            self.profilePicView.image = profilePic
            print("Chnaged profile pic")
        }
        */
        
        profilePicView.layer.cornerRadius = profilePicView.frame.size.width / 2
        profilePicBtn.layer.cornerRadius = profilePicBtn.frame.size.width / 2
        profilePicView.clipsToBounds = true
        profilePicBtn.clipsToBounds = true
        
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 6
        menuView.layer.zPosition = 1;
        
        usernameLabel.text! = "\(String(describing: username))"
        
        self.dateFormatter.dateStyle = .full
        
        self.dateDisplay.text = self.dateFormatter.string(from: Date())
        
        // Register the table view cell class and it's reuse id:
        
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        
        // Problem: Can't get more than 6 table cells at once (max # displayed in view) ^^
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        checkIfOverdue() // Problem?: waits timed value until showing due dates on startup
        
        checkHomework()
        
        // Following used in debugging to reset UserDefaults/arrays:
        
        //homeworkTasks.removeAll()
        //homeworkDueDates.removeAll()
        
        //UserDefaults.standard.removeObject(forKey: "savedHomeworkTasks")
        //UserDefaults.standard.removeObject(forKey: "savedHomeworkDueDates")
        
    }
    
    // Maybe:
    func updateProfilePic(_ profilePic: UIImage) {
        profilePicView.image = profilePic
        profilePicView.setNeedsDisplay()
    }
    
    // Checks for overdue tasks, called once with timer repeating while app is open
    func checkIfOverdue() {
        
        // Change time interval to 60s or 1min for final build....
        countdown = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            
            let currentDate = Date()
            
            // Cycle through homework tasks to identify overdue tasks
            for i in 0..<self.homeworkDueDates.count {
                
                let dueDate = self.homeworkDueDates[i]
                
                let indexPath = IndexPath(row: i, section: 0) as IndexPath
                let overdueCell: UITableViewCell = self.tableView.cellForRow(at: indexPath)!
                
                // TimeLabel to be applied to .subtitle of tasks
                var timeLabel = ""
                
                let calendar = Calendar.current
                
                // Set the day's hours and mins to 00:00 for fair comparison
                let date1 = calendar.startOfDay(for: currentDate)
                let date2 = calendar.startOfDay(for: dueDate)
                
                // Difference between current date and homework task's due date
                let components = calendar.dateComponents([.day], from: date1, to: date2)
                
                // Determine days until homework task is due
                let timeLeftInDays = components.day!
                
                // If homework task is due today
                if timeLeftInDays == 0 {
                    
                    timeLabel = "Today"
                    
                }
                // If homework task is due later
                if timeLeftInDays >= 1 {
                    
                    timeLabel = "\(timeLeftInDays) days"
                    
                    // If due tomorrow
                    if timeLeftInDays == 1 {
                        
                        // Remove last character 's' for singular "1 day"
                        timeLabel = timeLabel.substring(to: timeLabel.index(before: timeLabel.endIndex))
                    }
                }
                
                // If homework task is overdue
                if currentDate >= dueDate {
                        
                    print("\(self.homeworkTasks[i]) is overdue")
                        
                    // Change cell appearance to indicate overdue task
                    overdueCell.backgroundColor = UIColor(red: 1, green: 61/252, blue: 57/252, alpha: 1)
                    overdueCell.textLabel?.textColor = UIColor.white
                        
                    timeLabel = "Overdue!"
                    
                    
                } else {
                    
                    // If not overdue, ensure cell's appearance is neutral
                    overdueCell.backgroundColor = UIColor.white
                    overdueCell.textLabel?.textColor = UIColor.black
                    
                    print("\(self.homeworkTasks[i]), \(timeLeftInDays)")
                    
                }
                
                
                overdueCell.detailTextLabel?.text = "\(timeLabel)"
                
            }
            
        }
        
    }
    
    // Check if homework array is empty and add faded '+' over tableview
    func checkHomework() {
        if homeworkTasks.isEmpty {
            
            //countdown.invalidate()
            
            newHomeworkBtn.isHidden = false
            moreHomeworkBtn.isHidden = true
            
            UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                
                self.newHomeworkBtn.alpha = 1.0
                self.moreHomeworkBtn.alpha = 0
                
            }, completion: nil)
            
        } else {
            
            newHomeworkBtn.isHidden = true
            newHomeworkBtn.alpha = 0
            
            moreHomeworkBtn.isHidden = false
            moreHomeworkBtn.alpha = 1
            
        }
    }
    
    // alert func, takes in message as string
    func alert(title: String,_ message: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss",
                                   style: .default,
                                   handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }

    // Open/close menu when btn is tapped
    @IBAction func openMenu(_ sender: Any) {
        
        if (menuShowing == true) {
            
            moveMenu(-220, 0.1)
            
            menuShowing = false

        } else {
            
            moveMenu(0, 0.2)
            
            menuShowing = true
            
        }
        
    }
    
    // moves side-menu with duration and inset as parameter
    func moveMenu(_ inset: Int, _ duration: Float) {
        
        self.leadingConstraint.constant = CGFloat(inset)
        
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    // Close menu when open and background is tapped
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (menuShowing == true) {
            
            moveMenu(-220, 0.1)
            
            menuShowing = false
        }
        
    }
    
}

// Extension to create and manage tableview and cells
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        currentHomeworkCounter = self.homeworkTasks.count
        
        UserDefaults.standard.set(currentHomeworkCounter, forKey: "savedCurrentHomeworkCounter")
        
        return self.homeworkTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseID) as UITableViewCell!
        //cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellReuseID)
        
        
        
        
        // Workaround for .subtitle style, atm cannot load more than 6 cells (max cells fit in view)
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellReuseID)
        }
        
        
        cell?.textLabel?.text = "\(homeworkTasks[indexPath.row])"
        
        return cell!
        
    }
    
    // If user selects homework task:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Format date from default to styled
        dateFormatter.dateStyle = .full
        
        let taskDueDate = dateFormatter.string(from: homeworkDueDates[indexPath.row])
        
        // Alert user of additional info in selected task
        alert(title: "\(homeworkTasks[indexPath.row])", "Due: \(taskDueDate).")
        
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // Delete completed homework task
        if editingStyle == .delete {
            
            homeworkTasks.remove(at: indexPath.row)
            homeworkDueDates.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            homeworkCounter += 1
            
            UserDefaults.standard.set(homeworkTasks, forKey: "savedHomeworkTasks")
            UserDefaults.standard.set(homeworkDueDates, forKey: "savedHomeworkDueDates")
            UserDefaults.standard.set(homeworkCounter, forKey: "savedHomeworkCounter")
            
            checkHomework()
            
            // Invalidate countdown timer for completed task
            //self.countdown?.invalidate()
            
        } else if editingStyle == .insert {
            // add new row :^))
        }
    }
    
}
