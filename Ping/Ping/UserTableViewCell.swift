//
//  UserTableViewCell.swift
//  Ping
//
//  Created by Martin Zhang on 2016-08-11.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var profilePicImageView: UIImageView! {
        didSet {
            profilePicImageView.layer.cornerRadius = profilePicImageView.frame.width/2
            profilePicImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    
    let gradientLayer = CAGradientLayer()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gradientLayer.frame = self.bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).cgColor as CGColor
        let color2 = UIColor(white: 1.0, alpha: 0.1).cgColor as CGColor
        let color3 = UIColor.clear.cgColor as CGColor
        let color4 = UIColor(white: 0.0, alpha: 0.05).cgColor as CGColor
        
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.04, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)

    }
    
    override func prepareForReuse() {
        firstNameLabel.text = "Unknown User"
        lastNameLabel.text = ""
        headlineLabel.text = ""
        profilePicImageView.image = UIImage(named: "ghost_person")
    }
    
    func configureWithUser(_ user:User) {
        
        firstNameLabel.text = user.firstName;
        lastNameLabel.text = user.lastName;
        headlineLabel.text = user.headline;
        if let profileURL = user.profilePicURL, let url = URL(string: profileURL) {
            profilePicImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "ghost_person"))
        } else {
            profilePicImageView.image = UIImage(named: "ghost_person")
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }

}
