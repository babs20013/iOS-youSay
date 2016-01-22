//
//  FeedViewController.h
//  youSay
//
//  Created by Muliana on 26/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedViewController.h"
#import "WhoLikeThisViewController.h"

@interface FeedViewController : GAITrackedViewController  <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, LikeListDelegate, FBSDKSharingDelegate>

- (void) refreshFeed:(NSNotification *)notif;


@end