//
//  ViewController.swift
//  DiaryTesting
//
//  Created by James  on 25/7/17.
//  Copyright © 2017 James . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var MondayBtn: UIButton!
    @IBOutlet weak var TuesdayBtn: UIButton!
    @IBOutlet weak var WednesdayBtn: UIButton!
    @IBOutlet weak var ThursdayBtn: UIButton!
    @IBOutlet weak var FridayBtn: UIButton!
    
    
    func start() {
        
        let weekday = Calendar.current.component(.weekday, from: Date())
        print(weekday)
        
        if weekday == 2 {
            MondayBtn.setTitle("   >MON",for: .normal)
        } else if weekday == 3 {
            TuesdayBtn.setTitle("   >TUE",for: .normal)
        } else if weekday == 4 {
            WednesdayBtn.setTitle("   >WED",for: .normal)
        } else if weekday == 5 {
            ThursdayBtn.setTitle("   >THU",for: .normal)
        } else if weekday == 6 {
            FridayBtn.setTitle("   >FRI",for: .normal)
        }
        
    }
    
    func swipeLeft(recognizer : UIScreenEdgePanGestureRecognizer) {
        self.performSegue(withIdentifier: "Wednesday", sender: self)
    }
    
}

