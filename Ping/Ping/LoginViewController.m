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

#import "UserManager.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *linkedInLoginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserManager *uManager = [UserManager new];
    [uManager updateUserList];
    
    //query keychain
    
    NSMutableDictionary *query = [@{
      (__bridge id)kSecReturnAttributes : (__bridge id)kCFBooleanTrue,
      (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitAll,
      (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
      (__bridge id)kSecReturnData : (__bridge  id)kCFBooleanTrue
      } mutableCopy];
    
    CFTypeRef result = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    NSLog(@"%@", (__bridge id)result);
    
    if (result != NULL) { //then we found something in the keychain and can proceed to next screen
        
        [self createNewSession]; // to be removed when the code block bellow is completed
        
        /* NOTE the following code is unfinished it is meant to make a more robust test of what is in the keychaing. Specifically it retreves the token and uses it to creat a session
        NSArray *resultArray = (__bridge_transfer NSArray *)result;
        NSDictionary *resultDict = [resultArray firstObject];
        NSData *pswd = resultDict[(__bridge id)kSecValueData];
        NSString *password = [[NSString alloc] initWithData:pswd encoding:NSUTF16StringEncoding];
        
        NSLog(@"serialized token: %@", password);
        //CFRelease(result);
        
        
        [LISDKSessionManager createSessionWithAccessToken:[LISDKAccessToken LISDKAccessTokenWithSerializedString:password]];
       
        [self createNewSession];
        
        NSLog(@"ACcess tokens %@ ::::: %@",[[LISDKSessionManager sharedInstance].session.accessToken serializedString], password);
         */
    }
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark -Actions

- (IBAction)linkedInLoginButtonTapped:(id)sender {
    [self createNewSession];
}

#pragma mark -Helper Methods

- (void)createNewSession {
    [LISDKSessionManager createSessionWithAuth:@[LISDK_BASIC_PROFILE_PERMISSION] state:@"login with button" showGoToAppStoreDialog:YES successBlock:^(NSString *state) {
        NSLog(@"Success Segue to new screen");
        
        [self createUser];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"Error when logging in with LinkedIn %@", error);
    }];
}

#pragma mark -Helper Methods

- (void)createUser {
    // LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
    
    NSString *url = @"https://api.linkedin.com/v1/people/~";
    
    if ([LISDKSessionManager hasValidSession]) {
        [[LISDKAPIHelper sharedInstance] getRequest:url
                                            success:^(LISDKAPIResponse *response) {
                                                // do something with response
                                                NSLog(@"got user profile: %@", response.data);
                                                
                                                NSData *responseData = [response.data dataUsingEncoding:NSUTF8StringEncoding];
                                                
                                                NSError *jsonError;
                                            
                                                NSDictionary *myProfile = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                                          options:NSJSONReadingMutableContainers
                                                                                                            error:&jsonError];
                                               // should we have a userManager class?
                                                // if [myProfile["id"] is not in list of all users] then
                                                
                                                PingUser *selfUser = [[PingUser alloc] init];
                                                [selfUser setPropertiesWithProfileDictionary:myProfile];
                                                
                                                // need to get profile picture as well
                                                NSString *url = @"https://api.linkedin.com/v1/people/~:(id,num-connections,picture-url)?format=json";
                                                
                                                
                                                [[LISDKAPIHelper sharedInstance] getRequest:url success:^(LISDKAPIResponse *response) {
                                                    NSLog(@"successfully retrieved profile pic with response: %@", response.data);
                                                    
                                                    NSData *profilePicResponse = [response.data dataUsingEncoding:NSUTF8StringEncoding];
                                                    
                                                    NSError *picError;
                                                    NSDictionary *myPic = [NSJSONSerialization JSONObjectWithData:profilePicResponse
                                                                                                          options:NSJSONReadingMutableContainers
                                                                                                            error:&picError];
                                                    NSString *picURl = myPic[@"pictureUrl"];
                                                    
                                                    selfUser.profilePicURL = picURl;
                                                    
                                                    // save this user as selfUserSoIKnowWhoIAm
                                                    // save this user to the backend list
                                                    [self saveBackendlessUser:selfUser];
                                                    
                                                } error:^(LISDKAPIError *error) {
                                                    NSLog(@"Error when loading profile Pic: %@", error);
                                                    //send to backendless
                                                    [self saveBackendlessUser:selfUser];
                                                    
                                                }];
                                                
                                            }
                                              error:^(LISDKAPIError *apiError) {
                                                  // do something with error
                                                  NSLog(@"Failed to get user profile: %@", apiError);
                                              }];
    
    
    }
}

- (void)saveBackendlessUser:(PingUser *)user {
    id<IDataStore> dataStore = [backendless.persistenceService of:[PingUser class]];
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [dataStore save:user];
         });
    Fault *fault;
    BackendlessCollection *collection = [dataStore findFault:&fault];
        NSLog(@"log global list of users: %@", collection);
    
}

//- (void)createNewBackendlessUserWithUser:(User *)user {
//    BackendlessUser *backendUser = [BackendlessUser new];
//    [backendUser setProperty:@"UID" object:user.userUUID];
//    backendUser.password = user.linkedInID;
//    [backendless.userService registering:backendUser
//                                response:^(BackendlessUser *backendUser) {
//                                    NSLog(@"User Registered");
//                                } error:^(Fault *fault) {
//                                    NSLog(@"Fault: %@", fault);
//                                }];
//}


/*[[LISDKDeeplinkHelper sharedInstance] viewOtherProfile:martinID withState:@"viewMemberProfileButton" showGoToAppStoreDialog:NO success:success error:error];
 */

@end
