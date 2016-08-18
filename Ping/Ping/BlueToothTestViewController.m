//
//  BlueToothTestViewController.m
//  Ping
//
//  Created by thomas minshull on 2016-08-13.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "BlueToothTestViewController.h"
#import "BlueToothManager.h"
#import "UserManager.h"

@interface BlueToothTestViewController ()

@property (strong, nonatomic) BlueToothManager *btm;
@property (weak, nonatomic) IBOutlet UITextView *textField;

@end

@implementation BlueToothTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btm = [BlueToothManager sharedBluetoothManager];
    self.btm.vc = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButtonTapped:(id)sender {
    [self.btm setUpBluetooth];
}

- (IBAction)stopButtonTapped:(id)sender {
    [self.btm stop];
}

- (IBAction)homeButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"TestToHome" sender:self];
}

- (void)logToScreen:(NSString *)string {
    NSString *currentText = self.textField.text;
    currentText = [NSString stringWithFormat:@"%@\n%@",currentText, string];
    [self.textField setText:currentText];
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
