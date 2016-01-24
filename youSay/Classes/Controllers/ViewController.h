//
//  ViewController.h
//  youSay
//
//  Created by Muliana on 10/20/15.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SlideNavigationController.h"

@interface ViewController : GAITrackedViewController  <SlideNavigationControllerDelegate, FBSDKAppInviteDialogDelegate>


@end

