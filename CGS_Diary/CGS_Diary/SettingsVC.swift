//
//  SettingsVC.swift
//  CGS_Diary
//
//  Created by James  on 10/10/17.
//  Copyright © 2017 Nathan Heldon. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Outlets for storyboard:
    @IBOutlet weak var newProfilePic: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var homeworkCounterLabel: UILabel!
    @IBOutlet weak var currentHomeworkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationVC = self.navigationController!
        let homeVC = navigationVC.viewControllers[navigationVC.viewControllers.count - 2] as! ViewController
        
        // Form the profile pic into a circle:
        newProfilePic.layer.cornerRadius = newProfilePic.frame.size.width / 2
        newProfilePic.clipsToBounds = true
        
        // Display the count of completed and current homework tasks
        homeworkCounterLabel.text = "\(homeVC.homeworkCounter)"
        currentHomeworkLabel.text = "\(homeVC.currentHomeworkCounter)"
        
        // Close keyboard when screen is tapped
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Profile image picker - https://stackoverflow.com/questions/41100717/access-to-camera-and-photolibrary //
    
    
    // Open photo library for user to select profile pic
    @IBAction func openPhotos(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
    }
    
    // Open camera for user to take profile pic
    // NB: simulator doesn't allow access to camera
    @IBAction func openCamera(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
    }
    
    // Controller for user's selected profile picture
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage  {
            newProfilePic.image = image
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func submit(_ sender: Any) {
        
        let navigationVC = self.navigationController!
        let homeVC = navigationVC.viewControllers[navigationVC.viewControllers.count - 2] as! ViewController
        
        // Change user's display name
        if usernameTextField.text != "" {
            
            let newUsername = usernameTextField.text!
            homeVC.usernameLabel.text = newUsername
            UserDefaults.standard.set(newUsername, forKey: "savedUsername")
            
        }
        
        // Change user's profile picture
        if newProfilePic.image != #imageLiteral(resourceName: "defaultProfilePic") {
            
            let profilePic: UIImage = newProfilePic.image!
            
            homeVC.profilePicView.image = profilePic
            
            homeVC.imageDataPNG = UIImagePNGRepresentation(profilePic)
            
            UserDefaults.standard.set(homeVC.imageDataPNG, forKey: "savedProfilePic")
            
        }
        
        alert("Changes saved!")
        
    }
    
    // alert func, takes in message as string
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
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let headerView = view as! UITableViewHeaderFooterView
        //headerView.textLabel?.textColor = UIColor(red: 151.0/255, green: 193.0/255, blue: 100.0/255, alpha: 1)
        let font = UIFont(name: "HelveticaNeue", size: 18.0)
        headerView.textLabel?.font = font!
        
    }

}
