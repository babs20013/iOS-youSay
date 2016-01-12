//
//  AppDelegate.m
//  youSay
//
//  Created by macbokpro on 10/20/15.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "AppDelegate.h"
#import "SlideNavigationController.h"
#import "MenuViewController.h"
#import "CommonHelper.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate () 

@end

@implementation AppDelegate
@synthesize profileOwner;
@synthesize arrRecentSeacrh;

+ (AppDelegate *)sharedDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //--For push notification
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        UIUserNotificationSettings *notificationSetting = [UIUserNotificationSettings settingsForTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
        
        [[UIApplication sharedApplication]  registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSetting];
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }

    MenuViewController *rightMenu = (MenuViewController*)[CommonHelper instantiateViewControllerWithIdentifier:@"MenuViewController" storyboard:@"Main" bundle:nil];
    [SlideNavigationController sharedInstance].rightMenu = rightMenu;
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    NSString *newToken = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    newToken =  [newToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    self.deviceToken =  [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![[defaults objectForKey:@"token"] isEqualToString:self.deviceToken]) {
        [defaults setObject:deviceToken forKey:self.deviceToken];
        _isNewToken = YES;
    }
    
    [defaults synchronize];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

@end
