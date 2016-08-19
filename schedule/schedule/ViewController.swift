//
//  ViewController.swift
//  schedule
//
//  Created by Jack Crawford on 2/12/16.
//  Copyright © 2016 Jack Crawford. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    @IBOutlet weak var touch_count: UILabel!
    @IBOutlet weak var letter_display: UILabel!
    @IBOutlet weak var next_mod_time_label: UILabel!
    @IBOutlet weak var message_label: UILabel!
    @IBOutlet weak var mod_display: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var visual_separation: UILabel!

    let schoolred = UIColor(red:0.77, green:0.08, blue:0.11, alpha:1.0)
    let schoolblue = UIColor(red:0.54, green:0.73, blue:0.87, alpha:1.0)
    var timer = Timer()

    var counter = 0;
    let uiwhite = UIColor.white;
    @IBAction func menubutton(_ sender: AnyObject) {
        if letter_display.textColor == uiwhite {
            letter_display.textColor = UIColor.black;
            next_mod_time_label.textColor = UIColor.black;
            mod_display.textColor = UIColor.black;
            message_label.textColor = UIColor.black;
            date_label.textColor = UIColor.black;
            visual_separation.textColor = UIColor.black;
            self.view.backgroundColor = uiwhite;
            UIApplication.shared.statusBarStyle = .default

        } else {
            date_label.textColor = uiwhite;
            visual_separation.textColor = schoolred;
            letter_display.textColor = uiwhite;
            next_mod_time_label.textColor = schoolblue;
            mod_display.textColor = schoolblue;
            message_label.textColor = schoolblue;
            self.view.backgroundColor = UIColor.black
            UIApplication.shared.statusBarStyle = .lightContent
        }
        print("button")
        counter = counter + 1;
        let counter_text = String(counter);
        touch_count.text = counter_text;
        
    }

    @IBAction func swipe_right(_ sender: UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "full_view", sender: nil)


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadweb()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(ViewController.loadweb), userInfo: nil, repeats: true)
        let priority = DispatchQueue.GlobalQueuePriority.default
        DispatchQueue.global(priority: priority).async {
            // do some task
            DispatchQueue.main.async {
                // update some UI
                self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(ViewController.loadweb), userInfo: nil, repeats: true)
            }
        }
    }
    func loadmessage(_ string: String) -> String {
        if let url = URL(string: "http://hollandhall.net/hhmods/message.php") {
            do {
                let contents = try NSString(contentsOf: url, usedEncoding: nil)
                return contents as String
            } catch {
                // contents could not be loaded
                return ""
            }
        } else {
            // the URL was bad!
            return ""
        }
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
                            let mod = dict["mod"] as! String
                            let mod_time = dict["modstart"] as? String
                            print(DateInDayFormat)
                            let message = loadmessage("test")
                            
                            if DateInDayFormat == "Sat" || DateInDayFormat == "Sun" {
                                //display weekend labels
                                letter_display.text = "It's";
                                mod_display.text = "Weekend";
                                next_mod_time_label.text = "";
                                date_label.text = "The"
                                message_label.text = "";
                                visual_separation.text = "";
                                
                            } else {
                                if mod == "no school" {
                                    letter_display.text = dateInDisplayForm;
                                    mod_display.text = "No School"
                                    next_mod_time_label.text = "Today!"
                                    message_label.text = message
                                    message_label.adjustsFontSizeToFitWidth = true
                                    print("over")
                                    visual_separation.text = ""
                                    date_label.text = "";
                                }
                                 else {
                                    if DateInDayFormat == "Wed" && timeAsaNumber <= 8.45 {
                                        //morning meeting begins at 8:45
                                        letter_display.text = cyc + " Day";
                                        mod_display.text = "Morning Meeting"
                                        mod_display.adjustsFontSizeToFitWidth = true
                                        message_label.text = message
                                        message_label.adjustsFontSizeToFitWidth = true

                                        next_mod_time_label.text = "8:45"
                                        date_label.text = dateInDisplayForm;
                                    }
                                     else {
                                        if timeAsaNumber <= 8.00 && DateInDayFormat != "Wed" && DateInDayFormat != "Sat" && DateInDayFormat != "Sun"{
                                            //morning meeting begins at 8:00
                                            letter_display.text = cyc + " Day";
                                            mod_display.text = "Morning meeting"
                                            mod_display.adjustsFontSizeToFitWidth = true;
                                            next_mod_time_label.text = "8:00"
                                            date_label.text = dateInDisplayForm;
                                            message_label.adjustsFontSizeToFitWidth = true
                                            message_label.text = message
                                        } else {
                                        if mod == "over" {
                                            //this is after school
                                            letter_display.text = dateInDisplayForm;
                                            mod_display.text = "School is out"
                                            next_mod_time_label.text = "for the day";
                                            next_mod_time_label.adjustsFontSizeToFitWidth = true
                                            message_label.text = message
                                            message_label.adjustsFontSizeToFitWidth = true
                                            print("over")
                                            visual_separation.text = "";
                                            date_label.text = "";
                                    } else {
                                        if mod == "19"{
                                            //this is before 3:10 but after mod 18 has begun
                                            mod_display.text = "School ends"
                                            next_mod_time_label.text = "3:10"
                                            letter_display.text = cyc + " Day";
                                            message_label.text = message;
                                            date_label.text = dateInDisplayForm;
                                            message_label.adjustsFontSizeToFitWidth = true
                                                
                                        } else {
                                            if mod == "finals" {
                                                letter_display.text = "Finals"
                                                message_label.text = message;
                                                message_label.adjustsFontSizeToFitWidth = true
                                                mod_display.text = "Good Luck"
                                                next_mod_time_label.text = "Today";
                                                date_label.text = dateInDisplayForm
                                                visual_separation.text = "";
                                                    
                                            } else {
                                            letter_display.text = cyc + " Day";
                                            message_label.text = message;
                                            message_label.adjustsFontSizeToFitWidth = true
                                            mod_display.text = "Mod " + mod;
                                            next_mod_time_label.text = mod_time;
                                            date_label.text = dateInDisplayForm;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    }
                } else {
                    print("Could not parse JSON: \(error!)")
                }
            }
            }catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        }
    }


    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
