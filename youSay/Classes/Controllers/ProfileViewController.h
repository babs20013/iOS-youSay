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

@interface ProfileViewController : UIViewController <UITextViewDelegate, FBSDKAppInviteDialogDelegate, CharmChartDelegate, UIScrollViewDelegate, CharmSelectionDelegate, UIGestureRecognizerDelegate, AddNewSayDelegate>

@property (nonatomic,strong) NSDictionary * profileDictionary;
@property (nonatomic,strong) NSDictionary * colorDictionary;
@property (nonatomic, strong) NSMutableArray * saysArray;
@property (nonatomic, strong) NSMutableArray * charmsArray;
@property (nonatomic, strong) IBOutlet UIButton * btnAddSay;
@property (nonatomic, strong) IBOutlet UITextField * txtSearch;

@end