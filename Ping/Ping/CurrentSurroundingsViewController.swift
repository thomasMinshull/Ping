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
    let btm = BlueToothManager.sharedBluetooth()
    
    var users = [User]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userManager!.fetchUsersWthCompletion { (userArray) in
            self.btm?.setUpBluetooth()
            self.updateTableView()
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(CurrentSurroundingsViewController.updateTableView), for: UIControlEvents.valueChanged)
        
        currentSurroundingTableView.backgroundColor = UIColor(netHex:0xD9FAAA)
        currentSurroundingTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        currentSurroundingTableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    // MARK: TableView Delegate/DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        userCell.selectionStyle = UITableViewCellSelectionStyle.default
        userCell.configureWithUser(users[indexPath.row])
        
        return userCell
    }
    
    func colorForIndex(_ index: Int) -> UIColor {
        
        let itemCount = users.count - 1
        let transparency = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 0.44314, green: 0.95686, blue: 0.81961, alpha: transparency)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor =  colorForIndex((indexPath as NSIndexPath).row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        LISDKDeeplinkHelper.sharedInstance().viewOtherProfile(user.linkedInID, withState: "eventCellSelected", showGoToAppStoreDialog: false, success: nil, error: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Custom Methods
    
    func updateTableView() {
        updateUsers()
        
        if users.count == 0 {
            if !activityIndicator.isAnimating {
                activityIndicator.startAnimating()
            }
            
            
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(CurrentSurroundingsViewController.updateTableView), userInfo: nil, repeats: false)
            
        } else {
            activityIndicator.hidesWhenStopped = true
            activityIndicator.stopAnimating()
            currentSurroundingTableView.reloadData()
        }
    }
    
    func updateUsers() {
        let recMan = RecordManager()
        let sortedUUIDs = recMan.uuidsSorted(atTime: Date()) ?? []
        
        users.removeAll()
        
        for uuid:String in sortedUUIDs {
            if let user = userManager!.user(forUUID: uuid) {
                users.append(user)
            }
        }
        
    }
    
    // MARK: Actions
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        // *******************************************************************************************
        
        btm?.stop()
        
        // Creating an event each time user presses current surrounding button, should the app stop transmitting BT data after the user leaves the view or keep it going?
        // *******************************************************************************************
        performSegue(withIdentifier: "currentSurroundingsToEventList", sender: self)
    }
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
