//
//  CurrentSurroundingsViewController.swift
//  Ping
//
//  Created by Martin Zhang on 2016-08-10.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

import UIKit

class CurrentSurroundingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Hard coded car data, replace with real people around
//    var tableData = ["Read 3 car articles", "Cleanup car", "Go for a ride", "Hit the road", "Build another car project", "Driving training", "Fix the layout problem of a client car project", "Get gas for car", "Check car parts dispatch status", "Booking the ticket to New York International Car Show", "Test the BMW M Performane Electronic Steering Wheel", "Call auto inspector"]
    
    // MARK: Outlets
    @IBOutlet weak var longBackButton: UIButton!
    @IBOutlet weak var currentSurroundingTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var users = [User]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentSurroundingTableView.backgroundColor = UIColor(netHex:0xD9FAAA)
        currentSurroundingTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        currentSurroundingTableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if users.count == 0 {
            activityIndicator.startAnimating()
            
        }
    }
    
    // MARK: TableView Delegate/DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 136
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserTableViewCell
        
        userCell.selectionStyle = UITableViewCellSelectionStyle.Default
        
        userCell.configureWithUser(users[indexPath.row]);
        
        return userCell;
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor =  colorForIndex(indexPath.row)
    }
    
    // MARK: Custom Methods
    
    func updateUsers() {
        let recMan = RecordManager()
        let sortedUUIDs = recMan.sortingUserRecordsInTimePeriodByProximity(NSDate()) ?? []
        
        users.removeAll()
        let userMan = UserManager()
        
        for uuid:String in sortedUUIDs {
            let user = userMan.userForUUID(uuid)
            users.append(user)
        }
        
    }
    
    func colorForIndex(index: Int) -> UIColor {
        
        let itemIndex = users.count - 1
        let transparency = (CGFloat(index) / CGFloat(itemIndex)) * 0.6
        
        return UIColor(red: 0.85098, green: 0.98039, blue: 0.66667, alpha: transparency)
    }
    
    
    // MARK: Actions
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

}




//extension UIColor {
//    convenience init(red: Int, green: Int, blue: Int) {
//        assert(red >= 0 && red <= 255, "Invalid red component")
//        assert(green >= 0 && green <= 255, "Invalid green component")
//        assert(blue >= 0 && blue <= 255, "Invalid blue component")
//        
//        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
//    }
//    
//    convenience init(netHex:Int) {
//        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
//    }
//}
