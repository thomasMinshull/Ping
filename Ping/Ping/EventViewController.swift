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
    var timePeriods:[TimePeriod]? // note can't be nil if no timePeriods will have empty array
    var uuids = [String]()
    var currentTimePeriod:TimePeriod?
    // Definint theme background color:
    let thmeBackGroundColor = UIColor(netHex:0xD9FAAA)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = thmeBackGroundColor
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        timeSlider.minimumValue = 0
        
        updateTimePeriods()
        timeSlider.value = timeSlider.maximumValue
        
        currentTimePeriod = getCurrentTimePeriodForSliderValue(UInt(timeSlider.value))
        uuids = getUUIDsForTimePeriod(currentTimePeriod)
        
        if let startTime = currentTimePeriod?.startTime {
            updateDateLabelWithDate(startTime)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 130

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("appaer")
    }
    
    func updateTimePeriods() {
        
        self.timePeriods = TimePeriod.sortArray(event.timePeriods, byDateAscending: true) as?[TimePeriod] //implemented in objective-C because realm-objective-C hates swift
        
        if let timePeriods = self.timePeriods {
            
            if timePeriods.count > 0 {
                timeSlider.maximumValue = Float(timePeriods.count) - 1
                return
            }
            
            timeSlider.maximumValue = 0
            
        }
    }

    
    func getCurrentTimePeriodForSliderValue(_ sliderValue:UInt) -> TimePeriod? {
        
        if let timePeriods = timePeriods {
            if timePeriods.count != 0 {
                if Int(sliderValue) < timePeriods.count {
                    return timePeriods[Int(sliderValue)]
                }
            }
        }
        return nil
    }
    
    func getUUIDsForTimePeriod(_ timePeriod:TimePeriod?) -> [String] {
        let recMan = RecordManager()
        
        if let timePeriod = timePeriod {
            return recMan.uuidsSorted(atTime: timePeriod.startTime)
        } else {
            return [String]()
        }
    }
    
    func updateDateLabelWithDate(_ date:Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = .short
        
        dateLabel.text = formatter.string(from: date)
    }
    
    
    // MARK: delegate/datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uuids.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // refactor to reorder cells & insert and delete
        let cell:UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        
        if let user = userManager.user(forUUID: uuids[indexPath.row]) {
            cell.configureWithUser(user)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.userManager.user(forUUID: uuids[indexPath.row])
        
        if let user = user {
            LISDKDeeplinkHelper.sharedInstance().viewOtherProfile(user.linkedInID, withState: "eventCellSelected", showGoToAppStoreDialog: false, success: nil, error: nil)
        }
        
    }
    
    func colorForIndex(_ index: Int) -> UIColor {
        
        let userCount = uuids.count - 1
        let transparency = (CGFloat(index) / CGFloat(userCount)) * 0.6
        return UIColor(red: 0.44314, green: 0.95686, blue: 0.81961, alpha: transparency)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = colorForIndex((indexPath as NSIndexPath).row)
    }
    
    // MARK: Actions
    
    @IBAction func timerSliderFinishSliding(_ sender: UISlider) {
        print("timeSliderFinishSlidingFired")
        timeSlider.value = roundf(sender.value)
        
        // ToDo Refactor so we are reordering cells, inserting and deleting instead of reloading table view
        currentTimePeriod = getCurrentTimePeriodForSliderValue(UInt(timeSlider.value))
        
        if let currentTimePeriod = currentTimePeriod {
            
            uuids = getUUIDsForTimePeriod(currentTimePeriod)
            tableView.reloadData()
        }
        
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        // ToDo Make Dry, code repeated in timeSliderFinishSliding
        timeSlider.value = roundf(sender.value)
        currentTimePeriod = getCurrentTimePeriodForSliderValue(UInt(timeSlider.value))
        
        if let currentTimePeriod = currentTimePeriod {
            updateDateLabelWithDate(currentTimePeriod.startTime)
        } else {
            updateDateLabelWithDate(event.startTime)
        }
    }
    

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "unwindFromEventToEventList", sender: self)
    }

}
