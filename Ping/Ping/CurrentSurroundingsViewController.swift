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
    var tableData = ["Read 3 car articles", "Cleanup car", "Go for a ride", "Hit the road", "Build another car project", "Driving training", "Fix the layout problem of a client car project", "Get gas for car", "Check car parts dispatch status", "Booking the ticket to New York International Car Show", "Test the BMW M Performane Electronic Steering Wheel", "Call auto inspector"]
    let themeBackGroundColor = UIColor(netHex:0xD9FAAA)
    @IBOutlet weak var longBackButton: UIButton!
    @IBOutlet weak var currentSurroundingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentSurroundingTableView.backgroundColor = themeBackGroundColor
        currentSurroundingTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        currentSurroundingTableView.tableFooterView = UIView(frame: CGRectZero)
        currentSurroundingTableView.registerClass(SurroundingsTableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell");
        
        cell!.textLabel?.text = tableData[indexPath.row]
        cell!.textLabel?.textColor = UIColor.blackColor()
        cell!.textLabel?.backgroundColor = UIColor.clearColor()
        cell!.textLabel?.font = UIFont(name: "Helvetica Neue Thin", size: 22)
        cell?.selectionStyle = UITableViewCellSelectionStyle.Default
        
        return cell!
    }
    
    func colorForIndex(index: Int) -> UIColor {
        
        let itemCount = tableData.count - 1
        let transparency = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        
        return UIColor(red: 0.85098, green: 0.98039, blue: 0.66667, alpha: transparency)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor =  colorForIndex(indexPath.row)
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
