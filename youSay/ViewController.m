//
//  ViewController.m
//  youSay
//
//  Created by macbokpro on 10/20/15.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

#import <TPKeyboardAvoidingScrollView.h>

#define TCMBaseURL @"http://examdroid.com:8383"


@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)faceBookAction:(id)sender {
    
    [[UIApplication sharedApplication]
     canOpenURL:[NSURL URLWithString:@"TestA://"]];
    
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
                
                
                NSString * accessToken = [FBSDKAccessToken currentAccessToken].tokenString;
                
                if([accessToken isKindOfClass:[NSString class]]){
                    NSString *completeUrl=[NSString stringWithFormat:@"https://graph.facebook.com/"];
                    [self loadFaceBookData:completeUrl param:@{@"fields":@"email,name,first_name,last_name,gender",@"access_token":accessToken}];
                }
                
            }
        }
    }];
}

-(void)loadFaceBookData:(NSString*)fbURLString param:(NSDictionary*)param
{
    
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Loading..."];
    UIColor *blackColor = [UIColor colorWithWhite:0.42f alpha:0.4f];
    [SVProgressHUD setBackgroundColor:blackColor];
    
    AFHTTPClient * client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:fbURLString]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"text/html"];
    [client getPath:@"me"
         parameters:param
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                NSString* email=@"";
                NSString* facebook_id=@"";
                NSString* first_name=@"";
                NSString* last_name=@"";
                NSString* gender=@"";
                
                if([resultDic valueForKey:@"email"]&&[[resultDic valueForKey:@"email"]isKindOfClass:[NSString class]]){
                    email=[resultDic valueForKey:@"email"];
                }
                if([resultDic valueForKey:@"first_name"]&&[[resultDic valueForKey:@"first_name"]isKindOfClass:[NSString class]]){
                    first_name=[resultDic valueForKey:@"first_name"];
                }
                if([resultDic valueForKey:@"last_name"]&&[[resultDic valueForKey:@"last_name"]isKindOfClass:[NSString class]]){
                    last_name=[resultDic valueForKey:@"last_name"];
                }
                if([resultDic valueForKey:@"gender"]&&[[resultDic valueForKey:@"gender"]isKindOfClass:[NSString class]]){
                    gender=[resultDic valueForKey:@"gender"];
                }
                if([resultDic valueForKey:@"id"]&&[[resultDic valueForKey:@"id"]isKindOfClass:[NSString class]]){
                    facebook_id=[resultDic valueForKey:@"id"];
                }
                NSLog(@"%@",@{ @"email" :email,@"gender" : gender,@"facebook_id" : facebook_id,@"first_name" : first_name,@"last_name" : last_name});
                
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                        facebook_id, @"facebookID",
                                        first_name, @"firstName",
                                        last_name, @"lastName",
                                        email, @"email",
                                        nil];
                
              /*  AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:
                                        [NSURL URLWithString:TCMBaseURL]];
                
                [client postPath:@"/loginWithFacebook" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSString *text = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    NSData *jsonData = [text dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[[json valueForKey:@"response"] valueForKey:@"userId"] forKey:@"userID"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                            stringForKey:@"userID"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[json valueForKey:@"token"]  forKey:@"token"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[[json valueForKey:@"response"] valueForKey:@"accountType"] forKey:@"accountType"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1"  forKey:@"UserLoggedInWithFacebook"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    
//                    if([[[json valueForKey:@"response"] valueForKey:@"newUserCreated"] isEqualToString:@"false"])
//                    {
//                        [self performSegueWithIdentifier:@"MenuToLogInSuccessfulIdentifier" sender:self];
//                    }
//                    else
//                    {
//                        [self performSegueWithIdentifier:@"customModalToSignUpWelcomeScreen" sender:self];
//                    }
                    
                    NSLog(@"Faceboo Respone is : %@", text);
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@", [error localizedDescription]);
                }];*/
                
                [SVProgressHUD dismiss];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error!", nil) message:NSLocalizedString(@"There is an Error While logging in! Please try Again.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil]show];
            }];
}


@end
