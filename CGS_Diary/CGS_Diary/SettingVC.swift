//
//  SettingsVC.swift
//  CGS_Diary
//
//  Created by James  on 18/9/17.
//  Copyright © 2017 Nathan Heldon. All rights reserved.
//

import UIKit

class SettingVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var newProfilePic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newProfilePic.layer.cornerRadius = newProfilePic.frame.size.width / 2
        newProfilePic.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Profile image picker - https://stackoverflow.com/questions/41100717/access-to-camera-and-photolibrary //
    
    // Open photo library for user to select profile pic
    @IBAction func library(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    // NB: Simulator doesn't allow access to camera
    @IBAction func camera(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
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
        picker.dismiss(animated: true, completion: nil);
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
