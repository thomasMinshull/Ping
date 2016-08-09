//
//  LoginViewController.m
//  Ping
//
//  Created by thomas minshull on 2016-07-25.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "LoginViewController.h"
#import <linkedin-sdk/LISDK.h>
#import "PingUser.h"
#import "Backendless.h"

#import "AppDelegate.h"

#import "MainViewController.h"
#import "Ping-Swift.h"
#import "LoginManager.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *linkedInLoginButton;
@property (strong, nonatomic) IntegrationManager *iM;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.iM = [IntegrationManager sharedIntegrationManager];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    if (self.iM.loginManager.isFirstTimeUser) {
        // ToDo display Onboarding else continue
    }
    
    if (self.iM.loginManager.isLoggedIn) {
        [self.iM.loginManager attemptToLoginWithCompletion:^(BOOL success) {
            if (success) {
                [self performSegueWithIdentifier:NSStringFromClass([MainViewController class]) sender:self];
            } else {
                // ToDo display error message
            }
        }];
    }
    
}


#pragma mark -Actions

- (IBAction)linkedInLoginButtonTapped:(id)sender {
    
    [self.iM.loginManager createNewUserAndLoginWithCompletion:^(BOOL success) {
        if (success) {
            [self performSegueWithIdentifier:NSStringFromClass([MainViewController class]) sender:self];
        } else {
            // Display Error
        }
    }];
}

@end
