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
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profilePicBtn: UIImageView!
    
    // On app launch, is the menu bar showing
    var menuShowing = false
    var homeworkTasks = UserDefaults.standard.stringArray(forKey: "savedHomeworkTasks") ?? [String]()
    let cellReuseIdentifier = "cell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2
        profilePicBtn.layer.cornerRadius = profilePicBtn.frame.size.width / 2
        profilePic.clipsToBounds = true
        profilePicBtn.clipsToBounds = true
        
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 6
        menuView.layer.zPosition = 1;
        
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
        checkHomework()
        tableView.reloadData()
        
        // Not sure if needed :tableView.reloadData()
    }
    
    func checkHomework() {
        if homeworkTasks.isEmpty {
            
            newHomeworkBtn.isHidden = false
            UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.newHomeworkBtn.alpha = 1.0
            }, completion: nil)
            
        } else {
            
            newHomeworkBtn.isHidden = true
            self.newHomeworkBtn.alpha = 0
            
        }
    }

    @IBAction func openMenu(_ sender: Any) {
        
        if (menuShowing == true) {
            
            moveMenu(-220, 0.1)
            
            menuShowing = false

        } else {
            
            moveMenu(0, 0.2)
            
            menuShowing = true
            
        }
        
        
    }
    
    func moveMenu(_ inset: Int, _ duration: Float) {
        
        self.leadingConstraint.constant = CGFloat(inset)
        
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (menuShowing == true) {
            
            moveMenu(-220, 0.1)
            
            menuShowing = false
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UserDefaults.standard.set(homeworkTasks, forKey: "savedHomeworkTasks")
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeworkTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        cell.textLabel?.text = self.homeworkTasks[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            homeworkTasks.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            print(homeworkTasks)
            
            checkHomework()
            
        } else if editingStyle == .insert {
            // add new row :^))
        }
    }
    
}
