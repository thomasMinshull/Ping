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

#import "UserManager.h"

#import "Ping-Swift.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *linkedInLoginButton;
@property (strong, nonatomic) UserManager *userManager;

@property LoadingView *loadingView;

typedef void(^myCompletion)(BOOL);


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadingView = [[LoadingView alloc] initWithFrame:CGRectZero];
    self.loadingView.backgroundColor = [UIColor whiteColor];
    
    CGFloat boxSize = 320;
    self.loadingView.frame = CGRectMake(self.view.bounds.size.width / 2 - boxSize / 2, 20, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.loadingView];
    
    self.userManager = [UserManager sharedUserManager];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __weak LoginViewController *weakSelf = self;
    [self.loadingView addLoadingAnimationGroupAnimationCompletionBlock:^(BOOL finished) {
        if(finished){
            [weakSelf.loadingView removeFromSuperview];
            
            NSLog(@"Done Animating!");
        }
    }];
    
    PingUser *previouslyLoggedInUser = [self.userManager fetchCurrentUserFromRealm];
    
    if (previouslyLoggedInUser && previouslyLoggedInUser.userUUID) {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        app.currentUser = previouslyLoggedInUser;
        
        // login with but don't create new user
        [self.userManager createNewSessionWithoutNewUsersWithCompletion:^{
            [self performSegueWithIdentifier:NSStringFromClass([MainViewController class]) sender:self];
        }];
    }
}


#pragma mark -Actions

- (IBAction)linkedInLoginButtonTapped:(id)sender {
    // do I have a account already
 
    PingUser *previouslyLoggedInUser = [self.userManager fetchCurrentUserFromRealm];
    
    if (previouslyLoggedInUser && previouslyLoggedInUser.userUUID) { //Yup
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        app.currentUser = previouslyLoggedInUser;
        
        // login with but don't create new user
        [self.userManager createNewSessionWithoutNewUsersWithCompletion:^{
            [self performSegueWithIdentifier:NSStringFromClass([MainViewController class]) sender:self];
        }];
    } else { // NOPE
        [self.userManager loginAndCreateNewUserWithCompletion:^{
            [self performSegueWithIdentifier:NSStringFromClass([MainViewController class]) sender:self];
        }];
    }
}

@end
