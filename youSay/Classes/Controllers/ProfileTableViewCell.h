//
//  ProfileTableViewCell.h
//  BLKFlexibleHeightBar Demo
//
//  Created by BDP on 10/21/15.
//  Copyright (c) 2015 Bryan Keller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharmView.h"
@interface ProfileTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *imgViewCover;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewProfilePicture;
@property (nonatomic, strong) IBOutlet UIButton *newbie;
@property (nonatomic, strong) IBOutlet UIButton *popular;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblCharm1;
@property (nonatomic, strong) IBOutlet UILabel *lblCharm2;
@property (nonatomic, strong) IBOutlet UILabel *lblCharm3;
@property (nonatomic, strong) IBOutlet UILabel *lblCharm4;
@property (nonatomic, strong) IBOutlet UILabel *lblCharm5;
@property (nonatomic, strong) IBOutlet UIView *viewCharm1;
@property (nonatomic, strong) IBOutlet UIView *viewCharm2;
@property (nonatomic, strong) IBOutlet UIView *viewCharm3;
@property (nonatomic, strong) IBOutlet UIView *viewCharm4;
@property (nonatomic, strong) IBOutlet UIView *viewCharm5;
@property (nonatomic, strong) IBOutlet UILabel *lblRankLevel;
@property (nonatomic, strong) IBOutlet UILabel *lblPopularityLevel;
@property (nonatomic, strong) IBOutlet UIView *charmView;
@property (nonatomic, strong) IBOutlet CharmView *charmChartView;

@property (nonatomic, strong) IBOutlet UIView *longPressInfoView;
@property (nonatomic, strong) IBOutlet UIButton *btnShare;
@property (nonatomic, strong) IBOutlet UILabel *lblShare;
@property (nonatomic, strong) IBOutlet UIImageView *imgVShare;

@property (nonatomic, strong) IBOutlet UIView *buttonEditView;

@end
