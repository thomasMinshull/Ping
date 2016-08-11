//
//  EventCalendarViewController.m
//  Ping
//
//  Created by Martin Zhang on 2016-08-09.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "EventCalendarViewController.h"

@interface EventCalendarViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *addEventButton;
@property (weak, nonatomic) IBOutlet UIButton *currentSurroundingsButton;

@end

@implementation EventCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *addEventButtonHoveredImage = [UIImage imageNamed:@"Plus Copy"];
    [self.addEventButton setImage:addEventButtonHoveredImage forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addEventButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showNewEventViewSegue" sender:self];
}

- (IBAction)currentSurroundingsButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showCurrentSurroundings" sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = @"Martin Z.";
    
    return cell;
}

// No time for this, considering getting rid of
// Too fancy animation?
//- (void)setUpVideoBackgroundForStartNowButton {
//    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Green Color Water Moving Animation Video" ofType:@"mp4"]];
//    
//}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
