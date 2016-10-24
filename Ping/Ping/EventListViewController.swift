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
        eventListTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        eventListTableView.tableFooterView = UIView(frame: CGRect.zero)
            
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

            events = CurrentUser.getCurrentUser().fetchEvents();
            eventListTableView.reloadData()
            
            // scroll past old events but leave at least one event showing
            let pastEvents = getIndexOfNextEvent()
            var ip:IndexPath?
            
            if pastEvents < events.count {
                ip = IndexPath(row: pastEvents, section: 0)
            }
            
            if let ip = ip {
                eventListTableView.scrollToRow(at: ip, at: .top, animated: false)
            }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventListTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.gray // ToDo move into cell class
        cell.configureWithEvent(events[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EventSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
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
            eventRecordManager.delete(events[indexPath.row])
            events.remove(at: indexPath.row)
            self.eventListTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)

        }
    }
    
    // Prepare to display gradient cells
    
    func colorforIndex(_ index: Int) -> UIColor {
        
        let itemCount = events.count - 1 // ToDo deal with edge case what happens when events is 0?
        let  transparency = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 0.44314, green: 0.95686, blue: 0.81961, alpha: transparency)
        
    }
    
    // Displaying gradient cells
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor =  colorforIndex((indexPath as NSIndexPath).row)
        
    }
    
    // Mark: - Custom Functions
    
    func getIndexOfNextEvent() -> Int {
        var index = 0
        let now = Date()
        
        for event in self.events {
            if now.compare(event.endTime) == ComparisonResult.orderedDescending {
                index += 1
            }
        }
        
        return index
    }
    
    // MARK: - Actions
    
    @IBAction func currentSurroundingButtonPressed(_ sender: AnyObject) {
            self.performSegue(withIdentifier: "showCurrentSurroundings", sender: self)
    }
    
    @IBAction func addEventButtonPressed(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "showNewEventViewSegue", sender: self)
    }
    
    // MARK: - Navigation
    @IBAction func unwindToMenu(_ segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        if let indexPath = eventListTableView.indexPathForSelectedRow , identifier == "EventSegue" {
            let event = events[indexPath.row]
            if let vc = segue.destination as? EventViewController {
                vc.event = event
                vc.userManager = self.userManager
            }
            
        } else if identifier == "showCurrentSurroundings" {
            if let vc = segue.destination as? CurrentSurroundingsViewController {
                vc.userManager = self.userManager
            }
        } else if identifier == "showCurrentSurroundingsNoAnimation" {
            if let vc = segue.destination as? CurrentSurroundingsViewController {
                vc.userManager = self.userManager
            }
        }
        
    }
    
}
