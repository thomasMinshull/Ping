//
//  CurrentSurroundingsViewController.swift
//  Ping
//
//  Created by Martin Zhang on 2016-08-10.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

import UIKit

class CurrentSurroundingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    @IBOutlet weak var longBackButton: UIButton!
    @IBOutlet weak var currentSurroundingTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties 
    var userManager:UserManager?
    let btm = BlueToothManager.sharedBluetoothManager()
    
    var users = [User]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userManager!.fetchUsersWthCompletion { (userArray) in
            self.btm.setUpBluetooth()
            self.updateTableView()
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(CurrentSurroundingsViewController.updateTableView), forControlEvents: UIControlEvents.ValueChanged)
        
        currentSurroundingTableView.backgroundColor = UIColor(netHex:0xD9FAAA)
        currentSurroundingTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        currentSurroundingTableView.tableFooterView = UIView(frame: CGRectZero)
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
        userCell.configureWithUser(users[indexPath.row])
        
        return userCell
    }
    
    func colorForIndex(index: Int) -> UIColor {
        
        let itemCount = users.count - 1
        let transparency = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 0.44314, green: 0.95686, blue: 0.81961, alpha: transparency)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor =  colorForIndex(indexPath.row)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = users[indexPath.row]
        LISDKDeeplinkHelper.sharedInstance().viewOtherProfile(user.linkedInID, withState: "eventCellSelected", showGoToAppStoreDialog: false, success: nil, error: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: Custom Methods
    
    func updateTableView() {
        updateUsers()
        
        if users.count == 0 {
            if !activityIndicator.isAnimating() {
                activityIndicator.startAnimating()
            }
            
            
            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:#selector(CurrentSurroundingsViewController.updateTableView), userInfo: nil, repeats: false)
            
        } else {
            activityIndicator.hidesWhenStopped = true
            activityIndicator.stopAnimating()
            currentSurroundingTableView.reloadData()
        }
    }
    
    func updateUsers() {
        let recMan = RecordManager()
        let sortedUUIDs = recMan.UUIDsSortedAtTime(NSDate()) ?? []
        
        users.removeAll()
        
        for uuid:String in sortedUUIDs {
            if let user = userManager!.userForUUID(uuid) {
                users.append(user)
            }
        }
        
    }
    
    // MARK: Actions
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        // *******************************************************************************************
        
        btm.stop()
        
        // Creating an event each time user presses current surrounding button, should the app stop transmitting BT data after the user leaves the view or keep it going?
        // *******************************************************************************************
        performSegueWithIdentifier("currentSurroundingsToEventList", sender: self)
    }
    
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

}
