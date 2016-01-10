//
//  ProfileViewController.h
//  youSay
//
//  Created by Muliana on 07/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharmView.h"
#import "SelectCharmsViewController.h"
#import "AddNewSayViewController.h"
#import "WhoLikeThisViewController.h"

@interface ProfileViewController : UIViewController <UITextViewDelegate, FBSDKAppInviteDialogDelegate, CharmChartDelegate, UIScrollViewDelegate, CharmSelectionDelegate, UIGestureRecognizerDelegate, AddNewSayDelegate, LikeListDelegate>

@property (nonatomic,strong) ProfileOwnerModel *profileModel;
@property (nonatomic,strong) NSDictionary * profileDictionary;
@property (nonatomic,strong) NSDictionary * colorDictionary;
@property (nonatomic, strong) NSMutableArray * saysArray;
@property (nonatomic, strong) NSMutableArray * charmsArray;
@property (nonatomic, strong) IBOutlet UITextField * txtSearch;
@property (nonatomic, strong) IBOutlet UIView * searchView;
@property (nonatomic, readwrite) BOOL isFriendProfile;
@property (nonatomic, readwrite) BOOL isFromFeed;
@property (nonatomic, readwrite) BOOL isRequestingProfile;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *btnViewConstraint;
@property (nonatomic, strong) NSString *requestedID;
@property (nonatomic, strong) UIButton *btnAddSay;

- (void)setIsRefresh:(BOOL)isRefresh;
- (void) refreshPage:(NSNotification *)notif;

@end