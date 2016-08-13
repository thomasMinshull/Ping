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
    var events = [Event]()
//    var events = ["AMG GT S World Primier", "Track day", "Drag race with police", "VanCity car meet"]
    
    let mainBackGroundColor = UIColor(netHex:0xD9FAAA)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventListTableView.backgroundColor = mainBackGroundColor
        eventListTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        eventListTableView.tableFooterView = UIView(frame: CGRectZero)
        eventListTableView.registerClass(EventListTableViewCell.self, forCellReuseIdentifier: "cell")
        
        events = CurrentUser.getCurrentUser().fetchEvents();
    }
    
    override func viewWillAppear(animated: Bool) {
        events = CurrentUser.getCurrentUser().fetchEvents();
        eventListTableView.reloadData()
        
        // scroll past old events but leave at least one event showing
        let pastEvents = getIndexOfNextEvent()
        var ip:NSIndexPath?
        
        if events.count > 0 {
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
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = events[indexPath.row].eventName
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.textLabel?.font = UIFont(name: "Helvetica Neue Thin", size: 20)
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        
        return cell
        
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
            if now.compare(event.endTime) != NSComparisonResult.OrderedAscending {
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

// (netHex:0xD9FAAA):
// color hex quickly accessible UIColor extension
// do NOT delete v
//           v
//           v
//           v
//           v
//           v
//           v
//           v
//           v

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
