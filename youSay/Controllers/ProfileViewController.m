//
//  ProfileViewController.m
//  youSay
//
//  Created by Muliana on 07/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"

@interface ProfileViewController ()
@end

@implementation ProfileViewController

@synthesize profileDictionary;
@synthesize imgViewCover;
@synthesize imgViewProfilePicture;
@synthesize btnHeart;
@synthesize btnStar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imgViewProfilePicture.image = [[AppDelegate sharedDelegate].profileOwner ProfileImage];
    imgViewCover.image = [[AppDelegate sharedDelegate].profileOwner CoverImage];
    //[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-xpt1/t31.0-8/s720x720/10518308_10152519375953608_8011464897797594127_o.jpg"]]];
    
    imgViewProfilePicture.layer.cornerRadius = 0.5 * imgViewProfilePicture.bounds.size.width;
    imgViewProfilePicture.layer.masksToBounds = YES;
    imgViewProfilePicture.layer.borderWidth = 1;
    imgViewProfilePicture.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
