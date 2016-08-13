//
//  MainViewController.m
//  Ping
//
//  Created by thomas minshull on 2016-07-27.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "MainViewController.h"
#import "RecordManager.h"
#import "UserManager.h"
#import "PingUserTableViewCell.h"
#import <linkedin-sdk/LISDK.h>
#import "Ping-Swift.h"
#import "CurrentUser.h"

@interface MainViewController ()  <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UISwitch *advertisingSwitch;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray<NSString *> *orderedListOfUUIDs;

@property (strong, nonatomic) UserManager *userManager;
@property (strong, nonatomic) RecordManager *recordManager;

@end

@implementation MainViewController {
    UIDatePicker *datePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    IntegrationManager *iM = [IntegrationManager sharedIntegrationManager];
    //[iM.userManager setUp]; //??? try this
   // [iM.blueToothManager setUUIDList:iM.userManager.uuids andCurrentUUID:[CurrentUser getCurrentUser].UUID]; // ToDo refactor to remove passing in Current

    self.recordManager = [[RecordManager alloc] init];
    
    CurrentUser *user = [CurrentUser getCurrentUser];
    NSLog(@"%@", user);
    
//    [self.userManager setUp];

    self.orderedListOfUUIDs = [self.recordManager sortingUserRecordsInTimePeriodByProximity:[NSDate date]];
    if (!self.orderedListOfUUIDs) {
        self.orderedListOfUUIDs = @[];
    }
    
    CGRect datePickerFrame = CGRectMake(20.0, 0.0, self.view.frame.size.width-16.0, 200.0);
    datePicker = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
    
    [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
////    aRecordManager.timePeriods
//    [aRecordManager storeBlueToothDataByUUID:@"14EE37F6-C9EC-4E15-9676-EB9491BD71F1" userProximity:27 andTime:[NSDate date]];
//    
//    PingUser *hardCodedUser = [PingUser new];
//    hardCodedUser.firstName = @"Tom";
//    hardCodedUser.lastName = @"minshull";
//    hardCodedUser.headline = @"Hard Core Hard Coded!";
//    hardCodedUser.linkedInID = @"QDL7qxV5lM";
//    hardCodedUser.userUUID = @"16256070-EA80-42B3-94F1-EFC7CBF9CA0B";
//    hardCodedUser.profilePicURL = @"https://media.licdn.com/mpr/mprx/0_a4AifdDWRR1F7X4bmpdCkRBWYIKU2qqndVbioj3WZeCVWXosSa5i3E2WpfbVdFo9uV5Cem7d9IAsorfwGwq0FjmLPIARormBTwqh2pUHZoXBh6vIDVCmuevJ1YII_rJQHHKfwC__vym";
//    
//    PingUser *martin = [PingUser new];
//    martin.firstName = @"Martin";
//    martin.lastName = @"Zhang";
//    martin.headline = @"CARZZZZZZ!";
//    martin.linkedInID = @"XOP3JP80MN";
//    martin.userUUID = @"78025C33-230F-4A02-B483-2AA9ABF3C72F";
//    martin.profilePicURL = @"https://media.licdn.com/mpr/mprx/0_toKw915dIk5rEJF8OU6IYKyHoARu2R5ygUeLKQodo1eD2INKgU6w41kdDkBD2Ib3YUEQ4FFWF1eS7xzKjMvBOF65C1e270r2RMvez61eW-g85dIKBHi6vtjMGQtp60bjtVAbtqut7mP";
//    
//    self.orderedListOfUsers = [@[hardCodedUser, martin, hardCodedUser, hardCodedUser, martin] mutableCopy];
}


#pragma mark -TableViewDataSourceMethods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"number of rows in section %d", (int)[self.orderedListOfUUIDs count]);
    return [self.orderedListOfUUIDs count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PingUserTableViewCell *cell = (PingUserTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"PingUserTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        PingUserTableViewCell *cell = [[PingUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PingUserTableViewCell"];
        return cell;
    }
    
    IntegrationManager *iM = [IntegrationManager sharedIntegrationManager];
    
    User *user = [iM.userManager userForUUID:self.orderedListOfUUIDs[indexPath.row]];
    
    [cell setUpWithUser:user];
    
    return cell;
}


#pragma mark -TableViewDeletage Methods 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Segue To Linked In profile page
    [[LISDKDeeplinkHelper sharedInstance] viewOtherProfile:[self.userManager userForUUID:self.orderedListOfUUIDs[indexPath.row]].linkedInID withState:@"viewedMemberProfilePage" showGoToAppStoreDialog:NO success:nil error:nil];
}


#pragma mark -Actions 

- (IBAction)nowButtonTapped:(id)sender {
    datePicker.date = [self getStartTimeForTimePeriod:[NSDate date]];
    [self datePickerChanged:datePicker];
   // [self.userManager setUp];
}

- (void)datePickerChanged:(UIDatePicker *)sender {
    
    // change orderedListOfUsers to be the list for this new date
    self.orderedListOfUUIDs = [self.recordManager sortingUserRecordsInTimePeriodByProximity:datePicker.date];
    if (!self.orderedListOfUUIDs) {
        self.orderedListOfUUIDs = @[];
    }
    [self.tableView reloadData];
}

- (IBAction)switchChanged:(id)sender {
    IntegrationManager *iM = [IntegrationManager sharedIntegrationManager];
    if (self.advertisingSwitch.on) {
        [iM.blueToothManager start];
    }
    
    else {
        [iM.blueToothManager stop];
    }
}

#pragma mark -Helper Methodes

// ToDo refactored martin's code so we "should" be able to delete this 

-(NSDate *)getStartTimeForTimePeriod:(NSDate *)time{
    NSCalendar *cal = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]; // get calander
    NSDateComponents *newDateComponenet = [[NSDateComponents alloc] init]; // create new component
    
    NSDateComponents *minComponent = [cal components:(NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitNanosecond) fromDate:time]; // get the components from time passed in
    
    // flip sign on seconds and nanoseconds (this will zero out these values)
    newDateComponenet.second = (-1)*minComponent.second;
    newDateComponenet.nanosecond = (-1)*minComponent.nanosecond;
    // round down the minutes
    newDateComponenet.minute = (-1) * (minComponent.minute %10);
    
    // apply the adjusted components to the passed in date to return the new date
    return [cal dateByAddingComponents:newDateComponenet toDate:time options:0];
    
}


@end
