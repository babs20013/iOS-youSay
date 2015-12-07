//
//  ProfileTableViewCell.h
//  BLKFlexibleHeightBar Demo
//
//  Created by BDP on 10/21/15.
//  Copyright (c) 2015 Bryan Keller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *imgViewCover;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewProfilePicture;
@property (nonatomic, strong) IBOutlet UIButton *newbie;
@property (nonatomic, strong) IBOutlet UIButton *popular;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@end
