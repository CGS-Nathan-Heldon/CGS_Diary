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
    
    // On app launch, is the menu bar showing
    var menuShowing = false
    
    
    @IBOutlet weak var menuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 6
        menuView.layer.zPosition = 1;
        
        
    }

    @IBAction func openMenu(_ sender: Any) {
        
        if(menuShowing) {
            
            leadingConstraint.constant = -220
            
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded()
            })

        } else {
            
            leadingConstraint.constant = 0
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
        
        
        menuShowing = !menuShowing
        
        
    }
}
