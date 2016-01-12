//
//  AppDelegate.h
//  youSay
//
//  Created by macbokpro on 10/20/15.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ProfileOwnerModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ProfileOwnerModel *profileOwner;
@property (strong, nonatomic) NSDictionary *colorDict;
@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSMutableArray *arrRecentSeacrh;
@property (nonatomic, readwrite) BOOL isNewToken;
@property (nonatomic, readwrite) BOOL isFirstLoad;

+ (AppDelegate *)sharedDelegate;

@end

