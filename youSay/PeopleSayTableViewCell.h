//
//  PeopleSayTableViewCell.h
//  BLKFlexibleHeightBar Demo
//
//  Created by BDP on 10/21/15.
//  Copyright (c) 2015 Bryan Keller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleSayTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *peopleSayTitleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewProfilePic;
@property (nonatomic, strong) IBOutlet UIView *peopleSayView;
@property (nonatomic, strong) IBOutlet UILabel *peopleSayLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *likesLabel;
@property (nonatomic, strong) IBOutlet UIButton *btnHide;
@end

