//
//  DayVC.swift
//  CGS_Diary
//
//  Created by James  on 30/8/17.
//  Copyright © 2017 Nathan Heldon. All rights reserved.
//

import UIKit

class DayVC: UIViewController {

    @IBOutlet weak var DayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let weekday = Calendar.current.component(.weekday, from: Date())
        
        if weekday == 2 {
            DayLabel.text = "MONDAY"
        } else if weekday == 3 {
            DayLabel.text = "TUESDAY"
        } else if weekday == 4 {
            DayLabel.text = "WEDNESDAY"
        } else if weekday == 5 {
            DayLabel.text = "THURSDAY"
        } else if weekday == 6 {
            DayLabel.text = "FRIDAY"
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
