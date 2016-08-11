//
//  LoginViewController.m
//  Ping
//
//  Created by thomas minshull on 2016-07-25.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

#import "LoginViewController.h"
#import <linkedin-sdk/LISDK.h>
#import <Parse/Parse.h>
#import "Backendless.h"

#import "AppDelegate.h"

#import "MainViewController.h"
#import "Ping-Swift.h"
#import "LoginManager.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *linkedInLoginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    
    IntegrationManager *iM = [IntegrationManager sharedIntegrationManager];
    
    if (iM.loginManager.isFirstTimeUser) {
        // ToDo display Onboarding else continue
        NSLog(@"First time user");
    }
    
    if (iM.loginManager.isLoggedIn) {
        [iM.loginManager attemptToLoginWithCompletion:^(BOOL success) {
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
    IntegrationManager *iM = [IntegrationManager sharedIntegrationManager];
    
    [iM.loginManager createNewUserAndLoginWithCompletion:^(BOOL success) {
        if (success) {
            
            [self performSegueWithIdentifier:NSStringFromClass([MainViewController class]) sender:self];
        } else {
            // Display Error
        }
    }];
}

@end
