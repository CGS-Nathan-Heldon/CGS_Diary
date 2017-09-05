//
//  EventsVC.swift
//  CGS_Diary
//
//  Created by James  on 5/9/17.
//  Copyright © 2017 Nathan Heldon. All rights reserved.
//

import UIKit

class EventsVC: UIViewController {

    @IBOutlet weak var monBtn: UIButton!
    @IBOutlet weak var tueBtn: UIButton!
    @IBOutlet weak var wedBtn: UIButton!
    @IBOutlet weak var thuBtn: UIButton!
    @IBOutlet weak var friBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let weekday = Calendar.current.component(.weekday, from: Date())
        
        if weekday == 2 {
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
