//
//  PingUserTableViewCell.m
//  Ping
//
//  Created by thomas minshull on 2016-07-27.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "PingUserTableViewCell.h"
//#import <SDWebImage/UIImageView+WebCache.h> // switched to nuke

@interface PingUserTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *headLineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation PingUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setUpWithUser:(User *)user {
    [self.firstNameLabel setText:user.firstName];
    [self.lastNameLabel setText:user.lastName];
    [self.headLineLabel setText:user.headline];
    
    if (user.profilePicURL == nil) {
       user.profilePicURL = @"";
    }
    
  //  [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:user.profilePicURL] placeholderImage:[UIImage imageNamed:@"ghost_person.png"]];
}
@end
