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
    
    let mainBackGroundColor = UIColor(netHex:0xD9FAAA)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // If selected EventlistVC, do things as usual
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
            
//        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! EventListTableViewCell

        cell.selectionStyle = UITableViewCellSelectionStyle.Gray // ToDo move into cell class
        
        cell.configureWithEvent(events[indexPath.row])
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("EventSegue", sender: self)
    }
    
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        let delete = UITableViewRowAction(style: .Normal, title: "\nDelete Event") {
//            action, index in
//            
//            let eventToDelete = self.events[indexPath.row]
//            let recMan = RecordManager()
//            recMan.deleteEvent(eventToDelete)
//            self.events.removeAtIndex(indexPath.row)
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
            
//            // Delete the local notificaitons when the event is removed.
//
//            if let notificationArray: Array = UIApplication.sharedApplication().scheduledLocalNotifications{
//                if let startNotificationToCancel: UILocalNotification = notificationArray[indexPath.row * 2]{
//                    UIApplication.sharedApplication().cancelLocalNotification(startNotificationToCancel)
//                }else{
//                    print("Could not find start notification to cancel")
//                }
//                if let endNotificationToCancel: UILocalNotification = notificationArray[indexPath.row * 2 + 1]{
//                    UIApplication.sharedApplication().cancelLocalNotification(endNotificationToCancel)
//                }else{
//                    print("Could not find ending notification to cancel")
//                }
//            }else{
//                print("Could not find array of notifications")
//            }
            
            // Deleting event from table(row) local array and realm
            
            
            let eventRecordManager = RecordManager()
            eventRecordManager.deleteEvent(events[indexPath.row])
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
        self.performSegueWithIdentifier("showNewEventViewSegue", sender: self)
    }
    
    // MARK: - Navigation
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        
        if let indexPath = eventListTableView.indexPathForSelectedRow where identifier == "EventSegue" {
            let event = events[indexPath.row]
            if let vc = segue.destinationViewController as? EventViewController {
                vc.event = event
                vc.userManager = self.userManager
            }
            
        } else if identifier == "showCurrentSurroundings" {
            if let vc = segue.destinationViewController as? CurrentSurroundingsViewController {
                vc.userManager = self.userManager
            }
        } else if identifier == "showCurrentSurroundingsNoAnimation" {
            if let vc = segue.destinationViewController as? CurrentSurroundingsViewController {
                vc.userManager = self.userManager
            }
        }
        
        
    }
    
}


