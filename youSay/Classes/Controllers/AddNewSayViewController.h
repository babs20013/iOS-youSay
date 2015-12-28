//
//  AddNewSayViewController.h
//  youSay
//
//  Created by Muliana on 04/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileOwnerModel.h"

@interface AddNewSayViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITextView *addSayTextView;
@property (nonatomic, strong) IBOutlet UIView *textViewBG;
@property (nonatomic, strong) IBOutlet UIView *profileView;
@property (nonatomic, strong) IBOutlet UIView *chooseBGView;
@property (nonatomic, strong) IBOutlet UIView *colorContainer;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIImageView *profileImg;
@property (nonatomic, strong) IBOutlet UIImageView *coverImg;
@property (nonatomic, strong) IBOutlet UILabel *profileLabel;
@property (nonatomic, strong) IBOutlet UILabel *placeholderLabel;
@property (nonatomic, strong) ProfileOwnerModel *model;
@property (nonatomic, strong) NSDictionary *colorDict;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint *textConstraint;
@end