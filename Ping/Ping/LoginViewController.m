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

#import "MainViewController.h"

#import "UserManager.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *linkedInLoginButton;
@property (strong, nonatomic) UserManager *userManager;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userManager = [UserManager sharedUserManager];
}

- (void)viewDidAppear:(BOOL)animated {
    
//    if ([self.userManager previouslyLoggedIn]) {
//        [self.userManager createNewSessionWithoutNewUsersWithCompletion:^{
//            [self performSegueWithIdentifier:NSStringFromClass([MainViewController class]) sender:self];
//        }];
//    }
}


#pragma mark -Actions

- (IBAction)linkedInLoginButtonTapped:(id)sender {
    // do I have a account already
    
    // yes
    
    
    [self.userManager loginAndCreateNewUserWithCompletion:^{
        [self performSegueWithIdentifier:NSStringFromClass([MainViewController class]) sender:self];
     
    }];
    
    /*
    // No
//    [self.userManager createNewSessionWithoutNewUsersWithCompletion:^{
//        [self performSegueWithIdentifier:NSStringFromClass([MainViewController class]) sender:self];
//    }];
    */
}

@end
