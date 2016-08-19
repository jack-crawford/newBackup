//
//  TodayViewController.swift
//  cycle_today
//
//  Created by Jack Crawford on 7/11/16.
//  Copyright © 2016 Jack Crawford. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var letter: UILabel!
    @IBOutlet weak var next_mod: UILabel!
    @IBOutlet weak var next_mod_time: UILabel!
    
    var timer = Timer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        //
        loadweb()
        timer = Timer.scheduledTimer(timeInterval: 90, target: self, selector: #selector(TodayViewController.loadweb), userInfo: nil, repeats: true)
        self.preferredContentSize = CGSize(width: 0, height: 60
        );

        
    }
    func loadweb() {
        print("loadweb started")
        if let url = URL(string: "http://hollandhall.net/hhmods/mobile.php") {
            do {
                let contents = try! NSString(contentsOf: url, usedEncoding: nil)
                let data = contents.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!
                
                do {
                    //the abbreviated weekday format
                    let todaysDate:Date = Date()
                    let dateFormatter:DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEE"
                    let DateInDayFormat:String = dateFormatter.string(from: todaysDate)
                    //the hour format
                    let hourFormatter:DateFormatter = DateFormatter()
                    hourFormatter.dateFormat = "H"
                    let DateInHourFormat:String = hourFormatter.string(from: todaysDate)
                    //the month format
                    let monthFormatter:DateFormatter = DateFormatter()
                    monthFormatter.dateFormat = "MMMM"
                    let DateInMonthFormat:String = monthFormatter.string(from: todaysDate)
                    //the num day format
                    let dayFormatter:DateFormatter = DateFormatter()
                    dayFormatter.dateFormat = "dd"
                    let DateInNumDayFormat:String = dayFormatter.string(from: todaysDate)
                    //the weekday format
                    let weekdayFormatter:DateFormatter = DateFormatter()
                    weekdayFormatter.dateFormat = "EEEE"
                    //the minute format
                    let minuteFormatter:DateFormatter = DateFormatter()
                    minuteFormatter.dateFormat = "m"
                    let DateInMinuteFormat:String = minuteFormatter.string(from: todaysDate)
                    //create current time as a weird number for the morning meeting code
                    let timeAsaString = DateInHourFormat + "." + DateInMinuteFormat;
                    let timeAsaNumber = Float(timeAsaString);
                    
                    
                    let dateInDisplayForm = DateInMonthFormat + " " + DateInNumDayFormat;
                    print(dateInDisplayForm)
                    
                    let error:NSError? = nil
                    print(DateInDayFormat)
                    print(DateInHourFormat)
                    print("time as a number is " + timeAsaString);
                    
                    if let jsonObject: AnyObject = try JSONSerialization.jsonObject(with: data, options: []) {
                        if let dict = jsonObject as? NSDictionary {
                            print(dict)
                            let cyc = dict["cycleval"] as! String
                            let mod = dict["mod"] as? String
                            let mod_time = dict["modstart"] as? String
                            print(DateInDayFormat)
                            
                            if DateInDayFormat == "Sat" || DateInDayFormat == "Sun" {
                                //display weekend labels
                                letter.text = "It's"
                                next_mod.text = "The"
                                next_mod_time.text = "Weekend"

                            } else {
                                if mod == "no school" {
                                    letter.text = "No"
                                    next_mod.text = "School"
                                    next_mod_time.text = "Today"
                                }
                                else {
                                    if DateInDayFormat == "Wed" && timeAsaNumber <= 8.45 {
                                        //morning meeting begins at 8:45
                                        letter.text = "Morning"
                                        next_mod.text = "Meeting"
                                        next_mod_time.text = "8:45"
                                    }
                                    else {
                                        if timeAsaNumber <= 8.00 && DateInDayFormat != "Wed" && DateInDayFormat != "Sat" && DateInDayFormat != "Sun"{
                                            //morning meeting begins at 8:00
                                            letter.text = "Morning"
                                            next_mod.text = "Meeting"
                                            next_mod_time.text = "8:00"
                                        } else {
                                            if mod == "over" {
                                                letter.text = "School's"
                                                next_mod.text = "Out"
                                                next_mod_time.text = "For Today"
                                            } else {
                                                if mod == "19"{
                                                    //this is before 3:10 but after mod 18 has begun
                                                    letter.text = "School"
                                                    next_mod.text = "Ends at"
                                                    next_mod_time.text = "3:10"
                                                    
                                                } else {
                                                    if mod == "finals" {
                                                        letter.text = "Good"
                                                        next_mod.text = "Luck"
                                                        next_mod_time.text = "Today"
                                                        
                                                    } else {
                                                        letter.text = cyc + " Day";
                                                        next_mod.text = "Mod " + mod!;
                                                        next_mod_time.text = mod_time!;
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            print("Could not parse JSON: \(error!)")
                            letter.text = "?"
                            next_mod.text = "?"
                            next_mod_time.text = "?"
                        }
                    }
                }catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    letter.text = "?"
                    next_mod.text = "?"
                    next_mod_time.text = "?"
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }
    
}
