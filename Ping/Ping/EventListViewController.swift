//
//  EventListViewController.swift
//  Ping
//
//  Created by Martin Zhang on 2016-08-11.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var currentSurroundingButton: UIButton!
    @IBOutlet weak var addEventButton: UIButton!
    @IBOutlet weak var eventListTableView: UITableView!
    let mainBackGroundColor = UIColor(netHex:0xD9FAAA)
        var tableData = ["AMG GT S World Primier", "Track day", "Drag race with police", "VanCity car meet"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventListTableView.backgroundColor = mainBackGroundColor
        eventListTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        eventListTableView.tableFooterView = UIView(frame: CGRectZero)
        eventListTableView.registerClass(EventListTableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = tableData[indexPath.row]
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.textLabel?.font = UIFont(name: "Helvetica Neue Thin", size: 20)
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        
        return cell
        
    }
    
    func colorforIndex(index: Int) -> UIColor {
        
        let itemCount = tableData.count - 1
        let transparency = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 0.44314, green: 0.95686, blue: 0.81961, alpha: transparency)
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor =  colorforIndex(indexPath.row)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func currentSurroundingButtonPressed(sender: AnyObject) {
            self.performSegueWithIdentifier("showCurrentSurroundings", sender: self)
    }
    
    @IBAction func addEventButtonPressed(sender: AnyObject) {
        self .performSegueWithIdentifier("showNewEventViewSegue", sender: self)
    }
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
