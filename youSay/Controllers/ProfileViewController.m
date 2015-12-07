//
//  ProfileViewController.m
//  youSay
//
//  Created by Muliana on 07/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "ProfileTableViewCell.h"
#import "PeopleSayTableViewCell.h"
#import "ProfileOwnerModel.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate> {
    ProfileOwnerModel *profileModel;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ProfileViewController

@synthesize profileDictionary;
@synthesize imgViewCover;
@synthesize imgViewProfilePicture;
@synthesize btnHeart;
@synthesize btnStar;
@synthesize profileTblCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    profileModel = [AppDelegate sharedDelegate].profileOwner;
    self.tableView.delegate = self;
    
//    imgViewProfilePicture.image = profileModel.ProfileImage;
//    imgViewCover.image = profileModel.CoverImage;
//    imgViewProfilePicture.layer.cornerRadius = 0.5 * imgViewProfilePicture.bounds.size.width;
//    imgViewProfilePicture.layer.masksToBounds = YES;
//    imgViewProfilePicture.layer.borderWidth = 1;
//    imgViewProfilePicture.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 400;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ProfileTableViewCell";
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(indexPath.section == 0)
    {
        static NSString *cellIdentifier = @"ProfileTableViewCell";
        ProfileTableViewCell *cel = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cel.imgViewCover.image = profileModel.CoverImage;
        cel.imgViewProfilePicture.image = profileModel.ProfileImage;
        cel.imgViewProfilePicture.layer.cornerRadius = 0.5 * imgViewProfilePicture.bounds.size.width;
        cel.imgViewProfilePicture.layer.masksToBounds = YES;
        cel.imgViewProfilePicture.layer.borderWidth = 1;
        cel.imgViewProfilePicture.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;

        cel.lblName.text = profileModel.Name;
        return cel;
    }
    
    else if (indexPath.section == 1)
    {
        static NSString *cellIdentifier = @"PeopleSayTableViewCell";
        PeopleSayTableViewCell *cel = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cel.peopleSayLabel.text = [NSString stringWithFormat:@"What people said about %@:",[profileDictionary valueForKey:@"name"]];
        return cel;
    }
   
    return cell;
}




@end
