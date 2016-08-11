//
//  CurrentSurroundingsViewController.swift
//  Ping
//
//  Created by Martin Zhang on 2016-08-10.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

import UIKit

class CurrentSurroundingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var surroundingTableView: UITableView!
    @IBOutlet weak var longBackButton: UIButton!
    let appMainThemeColor = UIColor(netHex:0xD9FAAA)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        surroundingTableView.backgroundColor = appMainThemeColor
        surroundingTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        surroundingTableView.tableFooterView = UIView(frame: CGRectZero)
        surroundingTableView.registerClass(SurroundingsTableViewCell.self, forCellReuseIdentifier: "cell")
        
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
        return 20
        // Hard coded data here, pass in array.count later
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
        // Best looking row height DON'T change
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell");
        
        cell?.textLabel?.text = "UI Designer ---- Martin"
        cell?.textLabel?.textColor = UIColor.blackColor()
        cell?.textLabel?.backgroundColor = UIColor.clearColor()
        cell?.textLabel?.font = UIFont(name: "Helvetica Neue Thin", size: 18)
        cell?.selectionStyle = UITableViewCellSelectionStyle.Default
        
        return cell!
    }
}

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
