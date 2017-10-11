//
//  SettingsVC.swift
//  CGS_Diary
//
//  Created by James  on 10/10/17.
//  Copyright © 2017 Nathan Heldon. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {
    
    @IBOutlet weak var newProfilePic: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var homeworkCounterLabel: UILabel!
    @IBOutlet weak var currentHomeworkLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationVC = self.navigationController!
        let homeVC = navigationVC.viewControllers[navigationVC.viewControllers.count - 2] as! ViewController
        // NB: System of referencing HomeVC doesn't work when user has tapped to segues at once; e.g Homework and Settings...

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        // Set the image view displaying the profile pic to a circle
        newProfilePic.layer.cornerRadius = newProfilePic.frame.size.width / 2
        newProfilePic.clipsToBounds = true
        
        // Display the count of completed and current homework tasks
        homeworkCounterLabel.text = "\(homeVC.homeworkCounter)"
        currentHomeworkLabel.text = "\(homeVC.currentHomeworkCounter)"
        
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
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
    }
    
    // NB: Simulator doesn't allow access to camera
    @IBAction func openCamera(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
    }
    
    // Controller for user's selected profile pic
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage  {
            newProfilePic.image = image
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func submit(_ sender: Any) {
        
        let navigationVC = self.navigationController!
        let homeVC = navigationVC.viewControllers[navigationVC.viewControllers.count - 2] as! ViewController
        // NB: System of referencing HomeVC doesn't work when user has tapped to segues at once; e.g Homework and Settings...
        
        // Change user's display name
        if usernameTextField.text != "" {
            
            let newUsername = usernameTextField.text!
            homeVC.usernameLabel.text = newUsername
            UserDefaults.standard.set(newUsername, forKey: "savedUsername")
            
        }
        
        
        let profilePic: UIImage = newProfilePic.image!
        
        homeVC.profilePicView.image = profilePic
        //UserDefaults.standard.set(homeVC.profilePicView.image, forKey: "savedProfilePic")
        
        //homeVC.updateProfilePic(image)
        //homeVC.profilePicView.setNeedsDisplay()
        
        
        print("Profile pic working")
        
    }
    
    
    // Close keyboard when return is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // Close keyboard when background is tapped
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        usernameTextField.resignFirstResponder()
        
    }
    
    /*
     override func viewWillDisappear(_ animated: Bool) {
     super.viewWillDisappear(animated)
     
     let navigationVC = self.navigationController!
     let homeVC = navigationVC.topViewController as!ViewController
     
     homeVC.profilePic = newProfilePic.image
     
     homeVC.profilePicBtn.reloadInputViews()
     
     print("Working")
     
     // UserDefaults.standard.set(homeVC.profilePic, forKey: "savedProfilePic")
     
     // NB: Most recently added homework is first in array,
     //     except overdue which overtakes it
     
     }
     */
    
    /*
 
 // Profile pic not working atm
 @IBAction func submit(_ sender: Any) {
 
 let navigationVC = self.navigationController!
 let homeVC = navigationVC.viewControllers[navigationVC.viewControllers.count - 2] as! ViewController
 // NB: System of referencing HomeVC doesn't work when user has tapped to segues at once; e.g Homework and Settings...
 
 let profilePic: UIImage = newProfilePic.image!
 
 homeVC.profilePicView.image = profilePic
 //UserDefaults.standard.set(homeVC.profilePicView.image, forKey: "savedProfilePic")
 
 
 //homeVC.updateProfilePic(image)
 //homeVC.profilePicView.setNeedsDisplay()
 
 
 
 print("Profile pic working")
 
 }
 
 // Change user name //
 
 */

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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
