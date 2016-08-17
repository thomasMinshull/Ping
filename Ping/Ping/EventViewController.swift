//
//  EventViewController.swift
//  Ping
//
//  Created by Martin Zhang on 2016-08-12.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties 
    var event:Event!
    var userManager:UserManager!
    var timePeriods:RLMArray!
    var uuids = [String]()
    var currentTimePeriod:TimePeriod?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        timeSlider.minimumValue = 0
        
        updateTimePeriods()
        timeSlider.value = timeSlider.maximumValue
        
        currentTimePeriod = getCurrentTimePeriodForSliderValue(UInt(timeSlider.value))
        
        uuids = getUUIDsForTimePeriod(currentTimePeriod!)
        
        if let startTime = currentTimePeriod!.startTime {
            updateDateLabelWithDate(startTime)
        }
        
        
    }
    
    func updateTimePeriods() {
        
        timePeriods = TimePeriod.sortArray(event.timePeriods, byDateAscending: true) //implemented in objective-C because realm-objective-C hates swift
        
        if let timePeriods = timePeriods {
            if timePeriods.count > 0 {
                timeSlider.maximumValue = Float(timePeriods.count) - 1
                return
            }
        }
        
        timeSlider.maximumValue = 0
    }

    func getCurrentTimePeriodForSliderValue(sliderValue:UInt) -> TimePeriod {
        return timePeriods?.objectAtIndex(UInt(sliderValue)) as! TimePeriod
    }
    
    func getUUIDsForTimePeriod(timePeriod:TimePeriod) -> [String] {
        let recMan = RecordManager()
        return recMan.UUIDsSortedAtTime(timePeriod.startTime)
    }
    
    func updateDateLabelWithDate(date:NSDate) {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        
        dateLabel.text = formatter.stringFromDate(date)
    }
    
    
    // MARK: datasource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uuids.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // refactor to reorder cells & insert and delete
        let cell:UserTableViewCell = tableView.dequeueReusableCellWithIdentifier("UserTableViewCell") as! UserTableViewCell
        let user = userManager.userForUUID(uuids[indexPath.row])
        cell.configureWithUser(user)
        return cell
    }
    
    
    // MARK: Actions
    
    @IBAction func timerSliderFinishSliding(sender: UISlider) {
        print("timeSliderFinishSlidingFired")
        timeSlider.value = roundf(sender.value)
        
        // ToDo Refactor so we are reordering cells, inserting and deleting instead of reloading table view
        currentTimePeriod = getCurrentTimePeriodForSliderValue(UInt(timeSlider.value))
        uuids = getUUIDsForTimePeriod(currentTimePeriod!)
        updateDateLabelWithDate(currentTimePeriod!.startTime)
        tableView.reloadData()
        
    }
//    @IBAction func timeSliderChanged(sender: UISlider) { // ToDo finish implementing this method
//        timeSlider.value = roundf(sender.value)
//        
//    }

    @IBAction func backButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("unwindFromEventToEventList", sender: self)
    }

}
