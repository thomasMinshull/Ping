//
//  MainViewController.m
//  Ping
//
//  Created by thomas minshull on 2016-07-27.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "MainViewController.h"
#import "PingUserTableViewCell.h"
#import <linkedin-sdk/LISDK.h>


@interface MainViewController ()  <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<PingUser *> *orderedListOfUsers;
@property (strong, nonatomic) NSArray<NSString *> *orderedListOfUUIDs;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PingUser *hardCodedUser = [PingUser new];
    hardCodedUser.firstName = @"Tom";
    hardCodedUser.lastName = @"minshull";
    hardCodedUser.headline = @"Hard Core Hard Coded!";
    hardCodedUser.linkedInID = @"16256070-EA80-42B3-94F1-EFC7CBF9CA0B";
    hardCodedUser.profilePicURL = @"https://media.licdn.com/mpr/mprx/0_a4AifdDWRR1F7X4bmpdCkRBWYIKU2qqndVbioj3WZeCVWXosSa5i3E2WpfbVdFo9uV5Cem7d9IAsorfwGwq0FjmLPIARormBTwqh2pUHZoXBh6vIDVCmuevJ1YII_rJQHHKfwC__vym";
    
    PingUser *martin = [PingUser new];
    martin.firstName = @"Martin";
    martin.lastName = @"Zhang";
    martin.headline = @"CARZZZZZZ!";
    martin.linkedInID = @"XOP3JP80MN";
    martin.profilePicURL = @"https://media.licdn.com/mpr/mprx/0_toKw915dIk5rEJF8OU6IYKyHoARu2R5ygUeLKQodo1eD2INKgU6w41kdDkBD2Ib3YUEQ4FFWF1eS7xzKjMvBOF65C1e270r2RMvez61eW-g85dIKBHi6vtjMGQtp60bjtVAbtqut7mP";
    
    self.orderedListOfUsers = [@[hardCodedUser, martin, hardCodedUser, hardCodedUser, martin] mutableCopy];
}


#pragma mark -TableViewDataSourceMethods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.orderedListOfUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PingUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PingUserTableViewCell class])];
    
    [cell setUpWithPingUser:self.orderedListOfUsers[indexPath.row]];
    return cell;
}


#pragma mark -TableViewDeletage Methods 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Segue To Linked In profile page
    [[LISDKDeeplinkHelper sharedInstance] viewOtherProfile:self.orderedListOfUsers[indexPath.row].linkedInID withState:@"viewedMemberProfilePage" showGoToAppStoreDialog:NO success:nil error:nil];
}


#pragma mark -Actions 

- (IBAction)nowButtonTapped:(id)sender {
    // Will this be saved yet??
    self.datePicker.date = [NSDate date];
}

- (IBAction)datePickerChanged:(UIDatePicker *)sender {
    
    // change orderedListOfUsers to be the list for this new date
    
    [self.tableView reloadData];
}


@end
