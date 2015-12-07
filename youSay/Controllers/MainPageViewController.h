//
//  MainPageViewController.h
//  youSay
//
//  Created by Muliana on 06/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"
#import "FacebookStyleViewController.h"
#import "InviteFriendsViewController.h"
@interface MainPageViewController : ViewPagerController<ViewPagerDataSource, ViewPagerDelegate>
@property (nonatomic,strong) NSDictionary * profileDictionary;
@property (nonatomic, strong) NSMutableArray * saysArray;

@end
