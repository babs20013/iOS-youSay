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
#import "FacebookStyleViewController.h"
#define BaseURL @"https://yousayweb.com/yousay/backend/api/"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import "MainPageViewController.h"
#import "ProfileOwnerModel.h"
#import "HTTPReq.h"
#import "RequestModel.h"
#import "constant.h"
#import "ProfileViewController.h"
#import "CommonHelper.h"
#import "UIImageView+Networking.h"


@interface ViewController ()
{
    NSString * accessToken;
    ProfileOwnerModel *profileModel;
    NSDictionary *profileDict;
    NSDictionary *colorDict;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    accessToken = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)faceBookAction:(id)sender {
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There is no internet connection");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:@"There IS NO internet connection"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        
        NSLog(@"There IS internet connection");
    
    [[UIApplication sharedApplication]
     canOpenURL:[NSURL URLWithString:@"TestA://"]];

    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error){
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                 accessToken = [FBSDKAccessToken currentAccessToken].tokenString;
                if([accessToken isKindOfClass:[NSString class]]){
                    NSString *completeUrl=[NSString stringWithFormat:@"https://graph.facebook.com/"];
                    [self loadFaceBookData:completeUrl param:@{@"fields":@"email,picture,name,first_name,last_name,gender,cover",@"access_token":accessToken}];
                }
                
            }
            [SVProgressHUD dismiss];
        }
    }];
    }
}

-(void)loadFaceBookData:(NSString*)fbURLString param:(NSDictionary*)param
{
    AFHTTPClient * client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:fbURLString]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"text/html"];
    [client getPath:@"me"
         parameters:param
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                NSString* facebook_id=@"";
                
                profileModel = [[ProfileOwnerModel alloc]init];
                profileModel.Name = [resultDic valueForKey:@"name"];
                profileModel.UserID = [resultDic objectForKey:@"user_id"];
                profileModel.FacebookToken = [resultDic objectForKey:@"access_token"];
                profileModel.FacebookID = [resultDic objectForKey:@"id"];
                
                //--Get profile picture
                NSDictionary *pictureDict = [[resultDic objectForKey:@"picture"] objectForKey:@"data"];
                NSString *pictureURL = [pictureDict objectForKey:@"url"];
                profileModel.ProfileImage = pictureURL;
                
                //--Get cover picture
                NSString *coverURL = [[resultDic objectForKey:@"cover"] objectForKey:@"source"];
                profileModel.CoverImage = coverURL;
                
                if([resultDic valueForKey:@"id"]&&[[resultDic valueForKey:@"id"]isKindOfClass:[NSString class]]){
                    facebook_id=[resultDic valueForKey:@"id"];
                }
//                FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
//                content.appLinkURL = [NSURL URLWithString:@"https://www.mydomain.com/myapplink"];
//                //optionally set previewImageURL
//                content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];
//                [FBSDKAppInviteDialog showFromViewController:self withContent:content delegate:self];
                [self requestLogin];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error!", nil) message:NSLocalizedString(@"There is an Error While logging in! Please try Again.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil]show];
            }];
}

- (void)requestLogin {
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Loading..."];
    UIColor *blackColor = [UIColor colorWithWhite:0.42f alpha:0.4f];
    [SVProgressHUD setBackgroundColor:blackColor];
    RequestModel *loginReq = [[RequestModel alloc]init];
    loginReq.request = REQUEST_LOGIN;
    loginReq.authorization_id = profileModel.FacebookID;
    loginReq.authority_type = AUTHORITY_TYPE_FB;
    loginReq.authority_access_token = accessToken;
    loginReq.app_name = APP_NAME;
    loginReq.app_version = APP_VERSION;
    loginReq.device_info = @"iPhone 5";
    
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:loginReq completionBlock:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                profileModel.UserID = [dictResult valueForKey:@"user_id"];
                profileModel.token = [dictResult valueForKey:@"token"];
                [AppDelegate sharedDelegate].profileOwner = profileModel;
                profileDict = [result objectForKey:@"profile"];
                [self requestSayColor];
            }
        }
        else if (error)
        {
        }
        else{
          
        }
    }];
}

- (void)requestSayColor {
    NSMutableDictionary *dictRequest =  [[NSMutableDictionary alloc]init];
    [dictRequest setObject:REQUEST_SAY_COLOR forKey:@"request"];
    [dictRequest setObject:profileModel.UserID forKey:@"user_id"];
    [dictRequest setObject:profileModel.token forKey:@"token"];
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:dictRequest completionBlock:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                colorDict = [result objectForKey:@"colors"];
            }
        }
        else if (error)
        {
        }
        else{
            
        }
        [SVProgressHUD dismiss];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainPageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainPageViewController"];
        vc.profileDictionary = profileDict;
        vc.colorDictionary = colorDict;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}

- (IBAction)dummyButton:(id)sender {
    NSLog(@"open AddNewSay");
//    AddNewSayViewController *newSayVC = [[AddNewSayViewController alloc]init];
//    [self.navigationController pushViewController:newSayVC animated:YES];
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    MainPageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainPageViewController"];
//    [self.navigationController pushViewController:vc animated:YES];
    
    MainPageViewController *rightMenu = (MainPageViewController*)[CommonHelper instantiateViewControllerWithIdentifier:@"MainPageViewController" storyboard:@"Main" bundle:nil];
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:rightMenu withCompletion:nil];
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
