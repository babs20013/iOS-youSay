//
//  ProfileViewController.h
//  youSay
//
//  Created by Muliana on 07/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileTableViewCell.h"

@interface ProfileViewController : UIViewController <UITextViewDelegate>

@property (nonatomic,strong) NSDictionary * profileDictionary;
@property (nonatomic, strong) NSMutableArray * saysArray;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewCover;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewProfilePicture;
@property (nonatomic, strong) IBOutlet UIButton *btnHeart;
@property (nonatomic, strong) IBOutlet UIButton *btnStar;
@property (nonatomic, strong) IBOutlet ProfileTableViewCell *profileTblCell;
@end