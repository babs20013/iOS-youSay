
//
//  ProfileTableViewCell.m
//  BLKFlexibleHeightBar Demo
//
//  Created by BDP on 10/21/15.
//  Copyright (c) 2015 Bryan Keller. All rights reserved.
//

#import "ProfileTableViewCell.h"

@implementation ProfileTableViewCell
@synthesize imgViewCover, imgViewProfilePicture, newbie, popular, lblName;
@synthesize lblCharm1, lblCharm2, lblCharm3, lblCharm4, lblCharm5;
@synthesize viewCharm1, viewCharm2, viewCharm3, viewCharm4, viewCharm5;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
