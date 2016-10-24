//
//  EventListTableViewCell.swift
//  Ping
//
//  Created by Martin Zhang on 2016-08-11.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

import UIKit

class EventListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventHostLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    let gradientLayer = CAGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sharedSetup()
    }
    
    func configureWithEvent(_ event:Event) {
        eventTitleLabel.text = event.eventName
        eventHostLabel.text = event.hostName
        eventLocationLabel.text = event.eventAddress
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d h:mm a"
        
        eventTimeLabel.text = dateFormatter.string(from: event.startTime)
        
    }
    
    func sharedSetup() {
        gradientLayer.frame = self.bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).cgColor as CGColor
        let color2 = UIColor(white: 1.0, alpha: 0.1).cgColor as CGColor
        let color3 = UIColor.clear.cgColor as CGColor
        let color4 = UIColor(white: 0.0, alpha: 0.05).cgColor as CGColor
        
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.04, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedSetup()
    }

}
