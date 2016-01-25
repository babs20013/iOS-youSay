//
//  ViewController.m
//  youSay
//
//  Created by macbokpro on 10/20/15.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"
#import "JSONDictionaryExtensions.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import "MainPageViewController.h"
#import "ProfileOwnerModel.h"
#import "RequestModel.h"
#import "ProfileViewController.h"
#import "CommonHelper.h"
#import "UIImageView+Networking.h"
#import <BFAppLinkReturnToRefererView.h>
#import <BFAppLinkReturnToRefererController.h>

@interface ViewController ()
{
    NSString * accessToken;
    NSString * fbID;
    FBSDKAccessToken *currentToken;
    ProfileOwnerModel *profileModel;
    NSDictionary *profileDict;
    NSDictionary *colorDict;
}
@property (weak, nonatomic) BFAppLinkReturnToRefererView *appLinkReturnToRefererView;
@property (strong, nonatomic) BFAppLink *appLink;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.appLinkReturnToRefererView) {
        self.appLinkReturnToRefererView.hidden = YES;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.parsedUrl) {
        self.appLink = [delegate.parsedUrl appLinkReferer];
        [self _showRefererBackView];
    }
    delegate.parsedUrl = nil;
}

- (void) _showRefererBackView {
    if (nil == self.appLinkReturnToRefererView) {
        // Set up the back link navigation view
        BFAppLinkReturnToRefererView *backLinkView  = [[BFAppLinkReturnToRefererView alloc] initWithFrame:CGRectMake(0, 30, 320, 40)];
        self.appLinkReturnToRefererView = backLinkView;
    }
    self.appLinkReturnToRefererView.hidden = NO;
    // Initialize the back link view controller
    BFAppLinkReturnToRefererController *alc =[[BFAppLinkReturnToRefererController alloc] init];
    alc.view = self.appLinkReturnToRefererView;
    // Display the back link view
    [alc showViewForRefererAppLink:self.appLink];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:@"UI"
                                            action:@"app_launched"
                                             label:@"app_launched"
                                             value:nil] build];
    [[GAI sharedInstance].defaultTracker send:event];
    [[GAI sharedInstance] dispatch];
    
    accessToken = @"";
    if ([[FBSDKAccessToken currentAccessToken].expirationDate compare:[NSDate date]] == NSOrderedDescending) {
        [self goToMainPage];
    }
    else if ([[FBSDKAccessToken currentAccessToken].expirationDate compare:[NSDate date]] == NSOrderedAscending ) {
        [FBSDKAccessToken refreshCurrentAccessToken:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (result) {
                [self goToMainPage];
            }
        }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goToMainPage {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainPageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainPageViewController"];
    vc.profileDictionary = profileDict;
    vc.colorDictionary = colorDict;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)faceBookAction:(id)sender {
    [AppDelegate sharedDelegate].isFirstLoad = YES;
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There is no internet connection");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ERR_MSG_TITLE_SORRY
                                                        message:ERR_MSG_NO_INTERNET
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        
        NSLog(@"There IS internet connection");
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        login.loginBehavior = FBSDKLoginBehaviorNative;
        [login logInWithReadPermissions:nil fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error){
            if (error) {
                // Process error
            } else if (result.isCancelled) {
                // Handle cancellations
            }
            else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                accessToken = [FBSDKAccessToken currentAccessToken].tokenString;
                if([accessToken isKindOfClass:[NSString class]]){
                    [self goToMainPage];
                }
                HideLoader();
            }
        }];
    }
}


- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}

#pragma mark - FBInviteDelegate
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results {
    
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error {
    
}
@end
