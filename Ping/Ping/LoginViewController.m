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

#import "AppDelegate.h"

#import "MainViewController.h"
#import "Ping-Swift.h"
#import "LoginManager.h"

#import "Ping-Swift.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *linkedInLoginButton;

@property LoadingView *loadingView;

typedef void(^myCompletion)(BOOL);


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingView = [[LoadingView alloc] initWithFrame:CGRectZero];
    self.loadingView.backgroundColor = [UIColor colorWithRed:0.85 green:0.98 blue:0.67 alpha:1.0];
    
    CGFloat boxSize = 320;
    self.loadingView.frame = CGRectMake(self.view.bounds.size.width / 2 - boxSize / 2, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.loadingView];

    // Highlight button when selected
    UIImage *signInWithLinkedInButtonHoveredImage = [UIImage imageNamed:@"Sign-In-Large---Hover"];
    [self.linkedInLoginButton setImage:signInWithLinkedInButtonHoveredImage forState:UIControlStateHighlighted];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __weak LoginViewController *weakSelf = self;
    [self.loadingView addLoadingAnimationGroupAnimationCompletionBlock:^(BOOL finished) {
        if(finished){
            [weakSelf.loadingView removeFromSuperview];
            
            NSLog(@"Done Animating!");

            IntegrationManager *iM = [IntegrationManager sharedIntegrationManager];
            
            if (iM.loginManager.isFirstTimeUser) {
                // ToDo display Onboarding else continue
                NSLog(@"First time user");
            }
        }
    }];
    
    
}


#pragma mark -Actions

- (IBAction)linkedInLoginButtonTapped:(id)sender {
    IntegrationManager *iM = [IntegrationManager sharedIntegrationManager];
    
    [iM.loginManager createNewUserAndLoginWithCompletion:^(BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:NSStringFromClass([MainViewController class]) sender:self];
            });
        } else {
            // Display Error
        }
    }];
}

@end
