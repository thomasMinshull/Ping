//
//  EventListViewController.swift
//  Ping
//
//  Created by Martin Zhang on 2016-08-11.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Outlets
    @IBOutlet weak var currentSurroundingButton: UIButton!
    @IBOutlet weak var addEventButton: UIButton!
    @IBOutlet weak var eventListTableView: UITableView!
    
    // MARK: Properties
    var userManager:UserManager?
    var events = [Event]()
//    var events = ["AMG GT S World Primier", "Track day", "Drag race with police", "VanCity car meet"]
    
    let mainBackGroundColor = UIColor(netHex:0xD9FAAA)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventListTableView.backgroundColor = mainBackGroundColor
        eventListTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        eventListTableView.tableFooterView = UIView(frame: CGRectZero)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        events = CurrentUser.getCurrentUser().fetchEvents();
        eventListTableView.reloadData()
        
        // scroll past old events but leave at least one event showing
        let pastEvents = getIndexOfNextEvent()
        var ip:NSIndexPath?
        
        if pastEvents < events.count {
            ip = NSIndexPath(forRow: pastEvents, inSection: 0)
        }
        
        if let ip = ip {
            eventListTableView.scrollToRowAtIndexPath(ip, atScrollPosition: .Top, animated: false)
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! EventListTableViewCell
        
        cell.eventTitleLabel.text = events[indexPath.row].eventName
        cell.eventTimeLabel.text = String(events[indexPath.row].startTime)
        
        cell.eventTitleLabel.textColor = UIColor.blackColor()
        cell.eventTitleLabel.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.Gray
        
        cell.eventTimeLabel.textColor = UIColor.blackColor()
        cell.eventTimeLabel.backgroundColor = UIColor.clearColor()
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showParticularEventSegue", sender: self)
    }
    
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        let delete = UITableViewRowAction(style: .Normal, title: "\nDelete Event") {
//            action, index in
//            print("Delete button pressed")
//        }
//        delete.backgroundColor = UIColor.redColor()
//        
//        return [delete]
//    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            events.removeAtIndex(indexPath.row)
            self.eventListTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func colorforIndex(index: Int) -> UIColor {
        
        let itemCount = events.count - 1 // ToDo deal with edge case what happens when events is 0?
        let transparency = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 0.44314, green: 0.95686, blue: 0.81961, alpha: transparency)
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor =  colorforIndex(indexPath.row)
        
    }
    
    // Mark: - Custom Functions
    
    func getIndexOfNextEvent() -> Int {
        var index = 0
        let now = NSDate()
        
        for event in self.events {
            if now.compare(event.endTime) == NSComparisonResult.OrderedDescending {
                index += 1
            }
        }
        
        return index
    }
    
    // MARK: - Actions
    
    @IBAction func currentSurroundingButtonPressed(sender: AnyObject) {
            self.performSegueWithIdentifier("showCurrentSurroundings", sender: self)
    }
    
    @IBAction func addEventButtonPressed(sender: AnyObject) {
        self .performSegueWithIdentifier("showNewEventViewSegue", sender: self)
    }
    
    // MARK: - Navigation
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
}


