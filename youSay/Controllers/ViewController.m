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

@interface ViewController ()
{
    NSString * accessToken;
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
    
    //[SVProgressHUD show];
    [SVProgressHUD setStatus:@"Loading..."];
    UIColor *blackColor = [UIColor colorWithWhite:0.42f alpha:0.4f];
    [SVProgressHUD setBackgroundColor:blackColor];
        
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
        } else {
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
        }
    }];
    }
//    
//    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
//    dialog.fromViewController = self;
//    //dialog.content = @"test";
//    dialog.mode = FBSDKShareDialogModeShareSheet;
//    [dialog show];
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
                
                ProfileOwnerModel *model = [[ProfileOwnerModel alloc]init];
                model.Name = [resultDic valueForKey:@"name"];
                
                //--Get profile picture
                NSDictionary *pictureDict = [[resultDic objectForKey:@"picture"] objectForKey:@"data"];
                NSString *pictureURL = [pictureDict objectForKey:@"url"];
                model.ProfileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]]];
                
                //--Get cover picture
                NSString *coverURL = [[resultDic objectForKey:@"cover"] objectForKey:@"source"];
                model.CoverImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:coverURL]]];
                
                
                if([resultDic valueForKey:@"id"]&&[[resultDic valueForKey:@"id"]isKindOfClass:[NSString class]]){
                    facebook_id=[resultDic valueForKey:@"id"];
                }
                [AppDelegate sharedDelegate].profileOwner = model;
//                NSLog(@"%@",@{ @"email" :email,@"gender" : gender,@"facebook_id" : facebook_id,@"first_name" : first_name,@"last_name" : last_name});
                
                ServiceConnector *serviceConnector = [[ServiceConnector alloc] init];
                serviceConnector.delegate = self;
                [serviceConnector postTest:@"login" authorization_id:facebook_id access_token:accessToken authority_type:@"2" app_name:@"yousay_ios" app_version:@"1.0.16" device_info:@"iPhone"];
                
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error!", nil) message:NSLocalizedString(@"There is an Error While logging in! Please try Again.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil]show];
            }];
}

#pragma mark - ServiceConnectorDelegate -

-(void)requestReturnedData:(NSData *)data{ //activated when data is returned
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithJSONData:data];
//    output.text = dictionary.JSONString; // set the textview to the raw string value of the data recieved
    if([[dictionary valueForKey:@"message"] isEqualToString:@"success"])
    {
//        UITabBarController *tabar= [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
//
//        FacebookStyleViewController *dest = [tabar.viewControllers objectAtIndex:0];
//       dest.profileDictionary = [dictionary valueForKey:@"profile"];
//        [self.navigationController pushViewController:tabar animated:NO];
//        
//        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainPageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainPageViewController"];
        vc.profileDictionary = [dictionary valueForKey:@"profile"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    NSLog(@"yuouSay : %@",dictionary);
    
    [SVProgressHUD dismiss];

}

- (IBAction)dummyButton:(id)sender {
    NSLog(@"open AddNewSay");
//    AddNewSayViewController *newSayVC = [[AddNewSayViewController alloc]init];
//    [self.navigationController pushViewController:newSayVC animated:YES];
//    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainPageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainPageViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
