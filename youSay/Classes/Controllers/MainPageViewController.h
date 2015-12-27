//
//  MainPageViewController.h
//  youSay
//
//  Created by Muliana on 06/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"
#import "InviteFriendsViewController.h"
#import "ProfileViewController.h"
#import "FeedViewController.h"

@interface MainPageViewController : ViewPagerController<ViewPagerDataSource, ViewPagerDelegate>
@property (nonatomic,strong) NSDictionary * profileDictionary;
@property (nonatomic,strong) NSDictionary * colorDictionary;
@property (nonatomic, strong) NSMutableArray * saysArray;

@end
