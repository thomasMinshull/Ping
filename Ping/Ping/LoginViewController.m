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
#import "LoginManager.h"
#import "Ping-Swift.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *linkedInLoginButton;
@property (strong, nonatomic) LoginManager *loginManager;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //IntegrationManager *integrationManager = [IntegrationManager sharedIntegrationManager];
    self.loginManager = [LoginManager new];
}

- (void)viewDidAppear:(BOOL)animated {
    
    if (self.loginManager.isFirstTimeUser) {
        // ToDo display Onboarding else continue
    }
    
    if (self.loginManager.isLoggedIn) {
        [self.loginManager attemptToLoginWithCompletion:^(BOOL success) {
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
    
    [self.loginManager createNewUserAndLoginWithCompletion:^(BOOL success) {
        if (success) {
            [self performSegueWithIdentifier:NSStringFromClass([MainViewController class]) sender:self];
        } else {
            // Display Error
        }
    }];
}

@end
