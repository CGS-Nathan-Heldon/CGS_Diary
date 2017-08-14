//
//  DayViewController.swift
//  DiaryTesting
//
//  Created by James  on 1/8/17.
//  Copyright © 2017 James . All rights reserved.
//

import UIKit

class DayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //var dayOpen = segue.identifier <--
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var recessLabel: UILabel!
    @IBOutlet weak var lunchLabel: UILabel!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
