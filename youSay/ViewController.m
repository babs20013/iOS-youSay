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


#define TCMBaseURL @"http://examdroid.com:8383"
#define BaseURL @"https://yousayweb.com/yousay/backend/api/"

@interface ViewController ()
{
    NSString * accessToken;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    accessToken = @"";

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
                 accessToken = [FBSDKAccessToken currentAccessToken].tokenString;
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
//                if([resultDic valueForKey:@"access_token"]&&[[resultDic valueForKey:@"access_token"]isKindOfClass:[NSString class]]){
//                    accessToken=[resultDic valueForKey:@"access_token"];
//                }
                
                NSLog(@"%@",@{ @"email" :email,@"gender" : gender,@"facebook_id" : facebook_id,@"first_name" : first_name,@"last_name" : last_name});
                
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
        FacebookStyleViewController *dest = [self.storyboard instantiateViewControllerWithIdentifier:@"FacebookStyleViewController"];
        dest.profileDictionary = [dictionary valueForKey:@"profile"];
        [self.navigationController pushViewController:dest animated:YES];
    }
    
    NSLog(@"yuouSay : %@",dictionary);
    [SVProgressHUD dismiss];

}


@end
