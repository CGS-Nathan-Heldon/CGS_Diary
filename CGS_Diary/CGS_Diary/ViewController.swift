//
//  ViewController.swift
//  CGS_Diary
//
//  Created by Nathan Heldon on 14/8/17.
//  Copyright © 2017 Nathan Heldon. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Outlets for storyboard:
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
    
    let dateFormatter = DateFormatter()
    
    var imageDataPNG: Data! = nil
    
    var countdown: Timer!
    
    let cellReuseID = "homeworkCell"
    
    var taskDateDueSoon: Date! = nil
    
    var taskDueSoon = ""
    
    var notificationsAllowed = true
    
    var profilePic = UserDefaults.standard.object(forKey: "savedProfilePic") as? Data
    
    var username = UserDefaults.standard.string(forKey: "savedUsername") ?? "Welcome!"
    
    var homeworkTasks = UserDefaults.standard.stringArray(forKey: "savedHomeworkTasks") ?? [String]()
    
    var homeworkDueDates = UserDefaults.standard.array(forKey: "savedHomeworkDueDates") as? [Date] ?? [Date]()
    
    var homeworkCounter = UserDefaults.standard.integer(forKey: "savedHomeworkCounter")
    
    var currentHomeworkCounter = UserDefaults.standard.integer(forKey: "savedCurrentHomeworkCounter")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if a custom profile picture exists
        if UserDefaults.standard.object(forKey: "savedProfilePic") != nil {
            
            // Set profile picture
            let newImage = UIImage(data: profilePic!)
            profilePicView.image = newImage
            
        }
        
        if UserDefaults.standard.string(forKey: "savedUsername") != nil {
            
            usernameLabel.text! = "\(String(describing: username))"
            
        }
        
        // Form profile pic and overlaying button a circle:
        profilePicView.layer.cornerRadius = profilePicView.frame.size.width / 2
        profilePicBtn.layer.cornerRadius = profilePicBtn.frame.size.width / 2
        profilePicView.clipsToBounds = true
        profilePicBtn.clipsToBounds = true
        
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 6
        menuView.layer.zPosition = 1;
        
        self.dateFormatter.dateStyle = .full
        
        self.dateDisplay.text = self.dateFormatter.string(from: Date())
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Begin countdown timer for
        // homework tasks's due date
        startCountdownTimer()
        
        checkHomework()
        
        // Request 'push notifications' from user; only asked on first startup
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
        
    }
    
    // Allow notifications to be set when view is active
    override func viewDidAppear(_ animated: Bool) {
        
        notificationsAllowed = true
        print("viewDidAppear")
        
    }
    
    // Reloads table date every 60s to manage homework task's due dates,
    // called just once, with timer repeating while app is open
    func startCountdownTimer() {
        
        countdown = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { (timer) in
            
            self.tableView.reloadData()
            
        }
        
    }
    
    // Check if homework array is empty
    // and add faded '+' over tableview
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
            
            // else, remove large '+' and
            // add smaller '+' above tableview
            newHomeworkBtn.isHidden = true
            moreHomeworkBtn.isHidden = false
            
            // No need for animation as
            // user will never see
            newHomeworkBtn.alpha = 0
            moreHomeworkBtn.alpha = 1
            
            self.taskDateDueSoon = self.homeworkDueDates[0]
            
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
    
    
    // Notify user when the most pertinent task is overdue
    func reminder(_ triggerTime: Date, _ taskName: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "Homework task \(taskName) is overdue!"
        content.subtitle = ""
        content.body = ""
        content.badge = 1
        
        let components = Calendar.current.dateComponents([.weekday, .hour, .minute], from: triggerTime)
        
        // Set time to notify user
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "overdueTask", content: content, trigger: trigger)
        
        // Finally, add notifcation request
        // to notify user of overdue task
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }

    // Open/close menu when 
    // navigation button is tapped
    @IBAction func openMenu(_ sender: Any) {
        
        if (menuShowing == true) {
            
            moveMenu(-220, 0.1)
            
            menuShowing = false

        } else {
            
            moveMenu(0, 0.2)
            
            menuShowing = true
            
        }
        
    }
    
    // Func to move side-menu with
    // duration and inset
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
    
    // -- TableView functions to create and manage cells -- //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        currentHomeworkCounter = self.homeworkTasks.count
        
        // Save number of homework task for counter in settings
        UserDefaults.standard.set(currentHomeworkCounter, forKey: "savedCurrentHomeworkCounter")
        
        return self.homeworkTasks.count
    }
    
    // Primary area for overdue timer's logic:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get current time for comparisons
        let currentDate = Date()
        
        let i = indexPath.row
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseID)!
        
        let dueDate = self.homeworkDueDates[i]
        
        let taskName = self.homeworkTasks[i]
        
        // TimeLabel to be applied 
        // to .subtitle of tasks
        var timeLabel = ""
        
        let calendar = Calendar.current
        
        // Set the day's hours and mins to 00:00 for fair comparison
        let date1 = calendar.startOfDay(for: currentDate)
        let date2 = calendar.startOfDay(for: dueDate)
        
        
        // Difference between current date and homework task's due date
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        
        // Determine days until homework task is due
        let timeLeftInDays = components.day!
        
        
        // If homework task is due today:
        if timeLeftInDays == 0 {
            
            timeLabel = "Today"
            
        }
        
        
        // If homework task is due later:
        if timeLeftInDays >= 1 {
            
            timeLabel = "\(timeLeftInDays) days"
            
            // and If due tomorrow:
            if timeLeftInDays == 1 {
                
                // Remove last character 's' for singular "1 day"
                timeLabel = timeLabel.substring(to: timeLabel.index(before: timeLabel.endIndex))
            }
        }
        
        
        // If homework task is overdue:
        if currentDate >= dueDate {
            
            // Change cell appearance to indicate overdue task
            cell.backgroundColor = UIColor(red: 1, green: 61/252, blue: 57/252, alpha: 1)
            cell.textLabel?.textColor = UIColor.white
            
            timeLabel = "Overdue!"
            
            
        } else {
            
            // If not overdue, ensure cell's appearance is neutral
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
            
        }
        
        
        // If homework task's due date is earlier than previous,
        // and is not overdue, update value of task due first
        if self.taskDateDueSoon >= dueDate  && currentDate <= dueDate {
            
            self.taskDueSoon = taskName
            self.taskDateDueSoon = dueDate
            
        }
        
        let state = UIApplication.shared.applicationState
        
        // If app is closed, and notification condition is true,
        // Set notification to remind user of overdue task
        if state == .background && self.notificationsAllowed == true {
            
            print("APP CLOSED")
            
            self.reminder(self.taskDateDueSoon, self.taskDueSoon)
            
            self.notificationsAllowed = false
            
        }
        
        // Finally,
        // set the cell's text to the task's name
        // and it's subtitle to the days until due
        cell.textLabel?.text = "\(taskName)"
        cell.detailTextLabel?.text = "\(timeLabel)"
        
        return cell
        
    }
    
    // If user selects homework task:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Format date from default to styled
        dateFormatter.dateStyle = .full
        
        let taskDueDate = dateFormatter.string(from: homeworkDueDates[indexPath.row])
        
        // Alert user of additional info in selected task
        alert(title: "\(homeworkTasks[indexPath.row])", "Due: \(taskDueDate).")
        
        // Overwrite changed background colour
        // which was applied when selected
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // Delete completed homeworktasks
        if editingStyle == .delete {
                
            homeworkTasks.remove(at: indexPath.row)
            homeworkDueDates.remove(at: indexPath.row)
                
            tableView.deleteRows(at: [indexPath], with: .fade)
                
            homeworkCounter += 1
            
            // Save all data:
            UserDefaults.standard.set(self.homeworkTasks, forKey: "savedHomeworkTasks")
            UserDefaults.standard.set(self.homeworkDueDates, forKey: "savedHomeworkDueDates")
            UserDefaults.standard.set(self.homeworkCounter, forKey: "savedHomeworkCounter")
            
            // Check if homework
            // array is/isn't empty
            checkHomework()
            
        }
        
    }
    
}
