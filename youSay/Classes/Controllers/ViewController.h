//
//  ViewController.h
//  youSay
//
//  Created by macbokpro on 10/20/15.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ServiceConnector.h"
#import "SlideNavigationController.h"

@interface ViewController : UIViewController  <ServiceConnectorDelegate,SlideNavigationControllerDelegate>


@end

