//
//  NewEventViewController.m
//  Ping
//
//  Created by Martin Zhang on 2016-08-10.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "NewEventViewController.h"
#import "Event.h"
#import "CurrentUser.h"

@interface NewEventViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventHostTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventLocationTextField;
@property (weak, nonatomic) IBOutlet UIButton *startTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;

@property (strong) Event *event;

@end

@implementation NewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventNameTextField.delegate = self;
    self.eventHostTextField.delegate = self;
    self.eventLocationTextField.delegate = self;
    
    self.event = [[Event alloc] init];
    
}


#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.eventNameTextField]) {
        [self.eventHostTextField becomeFirstResponder];
    } else if ([textField isEqual:self.eventHostTextField]) {
        [self.eventLocationTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Actions

- (IBAction)backgroundTapped:(id)sender {
        [self.view endEditing:YES];
}


- (IBAction)eventNameChanged:(UITextField *)sender {
    self.event.eventName = sender.text;
}

- (IBAction)hoseNameChanged:(UITextField *)sender {
    self.event.eventName = sender.text;
}

- (IBAction)completeButtonPressed:(id)sender {
    CurrentUser *currentUser = [CurrentUser getCurrentUser];
    [currentUser addEvent:self.event];
    
    
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}
- (IBAction)startTimeButtonPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    //set up tinted background view
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor clearColor];
    darkView.tag = 9;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(dismissDatePicker:)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    
    //set up date picker
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 380)];
    datePicker.tag = 10;
    
    [datePicker addTarget:self action:@selector(changeStartDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    
    // set up toolBar
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 44)];
    toolBar.tag = 11;
    
    UIImage *toolBarImage = [UIImage imageNamed:@"realDarkClockToolBarImage"];
    [toolBar setBackgroundImage:toolBarImage forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                            target:nil
                                                                            action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(dismissDatePicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    
    // Make a cool enterince 
    [UIView beginAnimations:@"MoveIn" context:nil];

    datePicker.frame = CGRectMake(0.0, self.view.bounds.size.height*4.7/10, self.view.bounds.size.width, 380);
    
    toolBar.frame = CGRectMake(0.0, self.view.bounds.size.height*4.7/10, self.view.bounds.size.width, 44);
    
    darkView.alpha = 0.5;
    
    [UIView commitAnimations];
}

- (IBAction)endTimeButtonPressed:(id)sender {
    
    [self.view endEditing:YES];
    
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
    [datePicker addTarget:self action:@selector(changeEndDate:) forControlEvents:UIControlEventValueChanged];
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

- (void)changeStartDate:(UIDatePicker *)sender {
    NSLog(@"New Date: %@", sender.date);
    
   // [realm transactionWithBlock:^{
        self.event.startTime = sender.date;
   // }];
}

- (void)changeEndDate:(UIDatePicker *)sender {
    NSLog(@"New Date: %@", sender.date);
    
    self.event.endTime = sender.date;
}


#pragma mark -custom methods

-(void) dueDateChanged:(UIDatePicker *)sender {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
