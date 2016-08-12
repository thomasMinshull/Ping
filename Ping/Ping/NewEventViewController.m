//
//  NewEventViewController.m
//  Ping
//
//  Created by Martin Zhang on 2016-08-10.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "NewEventViewController.h"

@interface NewEventViewController ()

@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventHostTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventLocationTextField;
@property (weak, nonatomic) IBOutlet UIButton *startTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;

@end

@implementation NewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIImage *comple
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)completeButtonPressed:(id)sender {
    
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

-(void) dueDateChanged:(UIDatePicker *)sender {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //self.myLabel.text = [dateFormatter stringFromDate:[dueDatePickerView date]];
    NSLog(@"Picked the date %@", [dateFormatter stringFromDate:[sender date]]);
}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}

- (void)dismissDatePicker:(id)sender {
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
}
- (IBAction)startTimeButtonPressed:(id)sender {
    
    if ([self.view viewWithTag:9]) {
        return;
    }
    
    //    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, 320, 44);
    //    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 360, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor clearColor
                                ];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 380)];
    datePicker.tag = 10;
    //    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 44)];
    toolBar.tag = 11;
    //    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIImage *toolBarImage = [UIImage imageNamed:@"realDarkClockToolBarImage"];
    [toolBar setBackgroundImage:toolBarImage forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [
                                   [UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    //    CGSize pickerSize = [datePicker sizeThatFits:CGSizeZero];
    //    CGSize toolSize = [toolBar sizeThatFits:CGSizeZero];
    datePicker.frame = CGRectMake(0.0, self.view.bounds.size.height*4.7/10, self.view.bounds.size.width, 380);
    
    toolBar.frame = CGRectMake(0.0, self.view.bounds.size.height*4.7/10, self.view.bounds.size.width, 44);
    //    toolBar.frame = toolbarTargetFrame;
    //    datePicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.5;
    
    //    NSLayoutConstraint *datePickerHieght = [datePicker.topAnchor constraintEqualToAnchor:self.endTimeButton.bottomAnchor];
    //    datePickerHieght.active = YES;
    //    [datePicker.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    //
    //    [datePicker setNeedsDisplay];
    
    [UIView commitAnimations];
    
    // Old way abandoned
    
    //    UIDatePicker* picker = [[UIDatePicker alloc] init];
    //    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //    picker.datePickerMode = UIDatePickerModeDate;
    //
    //    [picker addTarget:self action:@selector(dueDateChanged:) forControlEvents:UIControlEventValueChanged];
    //    CGSize pickerSize = [picker sizeThatFits:CGSizeZero];
    //    picker.frame = CGRectMake(0.0, 250, pickerSize.width, 460);
    ////    picker.backgrounrdColor = [UIColor blackColor];
    //    [self.view addSubview:picker];
}

- (IBAction)endTimeButtonPressed:(id)sender {
    
    if ([self.view viewWithTag:9]) {
        return;
    }
    
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor clearColor
                                ];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 380)];
    datePicker.tag = 10;
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 44)];
    toolBar.tag = 11;
    UIImage *toolBarImage = [UIImage imageNamed:@"realToolBarImage"];
    [toolBar setBackgroundImage:toolBarImage forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [
                                   [UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    datePicker.frame = CGRectMake(0.0, self.view.bounds.size.height*4.7/10, self.view.bounds.size.width, 380);
    
    toolBar.frame = CGRectMake(0.0, self.view.bounds.size.height*4.7/10, self.view.bounds.size.width, 44);
    darkView.alpha = 0.5;

    [UIView commitAnimations];
}

- (void)changeDate:(UIDatePicker *)sender {
    NSLog(@"New Date: %@", sender.date);
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
