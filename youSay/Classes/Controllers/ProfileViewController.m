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
#import "constant.h"
#import "url.h"
#import "HTTPReq.h"
#import "SlideNavigationController.h"
#import "UIImageView+Networking.h"

#define kColor10 [UIColor colorWithRed:241.0/255.0 green:171.0/255.0 blue:15.0/255.0 alpha:1.0]
#define kColor20 [UIColor colorWithRed:243.0/255.0 green:183.0/255.0 blue:63.0/255.0 alpha:1.0]
#define kColor30 [UIColor colorWithRed:186.0/255.0 green:227.0/255.0 blue:86.0/255.0 alpha:1.0]
#define kColor40 [UIColor colorWithRed:82.0/255.0 green:209.0/255.0 blue:131.0/255.0 alpha:1.0]
#define kColor50 [UIColor colorWithRed:108.0/255.0 green:196.0/255.0 blue:140.0/255.0 alpha:1.0]
#define kColor60 [UIColor colorWithRed:68.0/255.0 green:188.0/255.0 blue:168.0/255.0 alpha:1.0]
#define kColor70 [UIColor colorWithRed:47.0/255.0 green:181.0/255.0 blue:160.0/255.0 alpha:1.0]
#define kColor80 [UIColor colorWithRed:53.0/255.0 green:184.0/255.0 blue:202.0/255.0 alpha:1.0]
#define kColor90 [UIColor colorWithRed:31.0/255.0 green:175.0/255.0 blue:197.0/255.0 alpha:1.0]
#define kColor100 [UIColor colorWithRed:1.0/255.0 green:172.0/255.0 blue:197.0/255.0 alpha:1.0]
#define kColorDefault [UIColor colorWithRed:209.0/255.0 green:209.0/255.0 blue:209.0/255.0 alpha:1.0]

#define kColorLabel [UIColor colorWithRed:27.0/255.0 green:174.0/255.0 blue:198.0/255.0 alpha:1.0]
#define kColorBG [UIColor colorWithRed:180.0/255.0 green:185.0/255.0 blue:187.0/255.0 alpha:1.0]

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate> {
    ProfileOwnerModel *profileModel;
    NSMutableDictionary *dictHideSay;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ProfileViewController

@synthesize profileDictionary;
@synthesize colorDictionary;
@synthesize saysArray;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dictHideSay = [[NSMutableDictionary alloc] init];
    profileModel = [AppDelegate sharedDelegate].profileOwner;
    self.tableView.delegate = self;
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.tintColor = [UIColor clearColor];
    //[self.view addSubview:searchBar];
    
    saysArray = [[NSMutableArray alloc]init];
    saysArray = [profileDictionary valueForKey:@"says"];
    
    
    UIImageView *imgMagnifyingGlass = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 15)];
    imgMagnifyingGlass.image = [UIImage imageNamed:@"search"];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [leftView addSubview:imgMagnifyingGlass];
    self.txtSearch.leftView = leftView;
    self.txtSearch.leftViewMode = UITextFieldViewModeAlways;
    self.txtSearch.layer.cornerRadius = round(self.txtSearch.frame.size.height / 2);
    self.txtSearch.layer.borderWidth = 1;
    self.txtSearch.layer.borderColor = [UIColor whiteColor].CGColor;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark TableView

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *thisView = [[UIView alloc]init];
    thisView.backgroundColor = [UIColor whiteColor];//kColorBG;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 20)];
    label.text = [NSString stringWithFormat:@"What people SAID about %@", profileModel.Name];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont fontWithName:@"Arial" size:14];
    [thisView addSubview:label];
    return thisView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *thisView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 35)];
    thisView.backgroundColor = kColorBG;
    if (section == 1) {
        UIButton *btnAddSay = [[UIButton alloc]initWithFrame:CGRectMake(70, -30, 60, 60)];
        btnAddSay.titleLabel.text = @"klklkl";
        [btnAddSay.imageView setImage:[UIImage imageNamed:@"AddButton"]];
        [thisView addSubview:btnAddSay];
    }
    return thisView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO-- Should be dynamic based on the iPhone device height
    if (indexPath.section == 0) {
        if ((self.view.frame.size.height - 59) < 501)
            return 501;
        return self.view.frame.size.height - 59;
    }
    else if (indexPath.section == 1) {
        NSString *index = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        if ([[dictHideSay objectForKey:index] isEqualToString:@"isHide"]) {
            return 300;
        }
        return 230;
    }
    else if (indexPath.section == 2) {
        return 65;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    if ([saysArray count]>0){
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return saysArray.count;}
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ProfileTableViewCell";
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(indexPath.section == 0)
    {
        static NSString *cellIdentifier = @"ProfileTableViewCell";
        ProfileTableViewCell *cel = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        //--Profile Box
        CGRect rect = CGRectMake(0,0,310,100);
        UIGraphicsBeginImageContext( rect.size );
        [profileModel.CoverImage drawInRect:rect];
        UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *imageData = UIImagePNGRepresentation(picture1);
        UIImage *img=[UIImage imageWithData:imageData];

        cel.imgViewCover.image = img;
        
        cel.imgViewProfilePicture.image = profileModel.ProfileImage;
        cel.imgViewProfilePicture.layer.cornerRadius = 0.5 * cel.imgViewProfilePicture.bounds.size.width;
        cel.imgViewProfilePicture.layer.masksToBounds = YES;
        cel.imgViewProfilePicture.layer.borderWidth = 1;
        cel.imgViewProfilePicture.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;

        cel.lblName.text = profileModel.Name;
        NSInteger popularity = [[profileDictionary objectForKey:@"popularity"] integerValue];
        NSInteger wiz = [[profileDictionary objectForKey:@"rank"] integerValue];
        [cel.newbie setTitle:[NSString stringWithFormat:@"%ld", (long)wiz] forState:UIControlStateNormal];
        [cel.popular setTitle:[NSString stringWithFormat:@"%ld", (long)popularity] forState:UIControlStateNormal];
        [cel.newbie setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[profileDictionary objectForKey:@"popularity_picture"]]]] forState:UIControlStateNormal];
        [cel.popular setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[profileDictionary objectForKey:@"rank_picture"]]]] forState:UIControlStateNormal];
        cel.lblRankLevel.text = [profileDictionary objectForKey:@"rank_level"];
        cel.lblPopularityLevel.text = [profileDictionary objectForKey:@"popularity_level"];
        
        //--Charms Box
        NSArray * charmsArray = [profileDictionary valueForKey:@"charms"];
        NSDictionary * dict1 = [charmsArray objectAtIndex:0];
        cel.lblCharm1.text = [dict1 valueForKey:@"name"];
        NSInteger score = [[dict1 valueForKey:@"rate"] integerValue];
        
        NSDictionary * dict2 = [charmsArray objectAtIndex:1];
        cel.lblCharm2.text = [dict2 valueForKey:@"name"];
        NSInteger score2 = [[dict2 valueForKey:@"rate"] integerValue];
        
        NSDictionary * dict3 = [charmsArray objectAtIndex:2];
        cel.lblCharm3.text = [dict3 valueForKey:@"name"];
        NSInteger score3 = [[dict3 valueForKey:@"rate"] integerValue];
        
        NSDictionary * dict4 = [charmsArray objectAtIndex:3];
        cel.lblCharm4.text = [dict4 valueForKey:@"name"];
        NSInteger score4 = [[dict4 valueForKey:@"rate"] integerValue];
        
        NSDictionary * dict5 = [charmsArray objectAtIndex:4];
        cel.lblCharm5.text = [dict5 valueForKey:@"name"];
        NSInteger score5 = [[dict5 valueForKey:@"rate"] integerValue];
        
        [cel.viewCharm1 addSubview:[self getCharmsDisplay:cel.viewCharm1.frame.size.height withScore:score]];
        [cel.viewCharm2 addSubview:[self getCharmsDisplay:cel.viewCharm2.frame.size.height withScore:score2]];
        [cel.viewCharm3 addSubview:[self getCharmsDisplay:cel.viewCharm3.frame.size.height withScore:score3]];
        [cel.viewCharm4 addSubview:[self getCharmsDisplay:cel.viewCharm4.frame.size.height withScore:score4]];
        [cel.viewCharm5 addSubview:[self getCharmsDisplay:cel.viewCharm5.frame.size.height withScore:score5]];
        
        cel.selectionStyle = UITableViewCellSelectionStyleNone;
        return cel;
    }
    
    else if (indexPath.section == 1)
    {
        static NSString *cellIdentifier = @"PeopleSayTableViewCell";
        PeopleSayTableViewCell *cel = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSDictionary *currentSaysDict = [saysArray objectAtIndex:indexPath.row];
        NSString *colorIndex = [NSString stringWithFormat:@"%@",[currentSaysDict objectForKey:@"say_color"]];

        [cel.imgViewProfilePic setImageURL:[NSURL URLWithString:[currentSaysDict objectForKey:@"profile_image"]]];
        cel.imgViewProfilePic.layer.cornerRadius = 0.5 * cel.imgViewProfilePic.bounds.size.width;
        cel.imgViewProfilePic.layer.masksToBounds = YES;
        cel.imgViewProfilePic.layer.borderWidth = 1;
        cel.imgViewProfilePic.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
        cel.peopleSayTitleLabel.text = [NSString stringWithFormat:@"%@ said about", [currentSaysDict objectForKey:@"by"]];
        cel.dateLabel.text = [currentSaysDict objectForKey:@"date"];
        cel.likesLabel.text = [NSString stringWithFormat:@"%@",[currentSaysDict objectForKey:@"like_count"]];
        cel.peopleSayLabel.text = [currentSaysDict objectForKey:@"text"];
        cel.btnHide.tag = indexPath.row;
        cel.btnUndo.tag = indexPath.row;
        NSDictionary *indexDict = [colorDictionary objectForKey:colorIndex];
        [cel.peopleSayView setBackgroundColor:[self colorWithHexString: [indexDict objectForKey:@"back"]]];
        [cel.peopleSayLabel setTextColor:[self colorWithHexString: [indexDict objectForKey:@"fore"]]];                                          
        
        NSString *index = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        if ([[dictHideSay objectForKey:index] isEqualToString:@"isHide"]) {
            [cel.hideSayView setHidden:NO];
        }
        else {
            [cel.hideSayView setHidden:YES];
        }
        cel.selectionStyle = UITableViewCellSelectionStyleNone;
        return cel;
    }
    else if (indexPath.section == 2) {
        
        static NSString *cellIdentifier = @"AddTableViewCell";
        UITableViewCell *cel = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        UIButton *btnAddSay = [[UIButton alloc]initWithFrame:CGRectMake(tableView.bounds.origin.x, 0, 60, 60)];
        [btnAddSay.imageView setImage:[UIImage imageNamed:@"AddButton"]];
        [cel addSubview:btnAddSay];
        return cel;
    }
   
    return cell;
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    cString = [cString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (UIView*)getCharmsDisplay:(CGFloat)chartHeight withScore:(NSInteger)score {
    
    UIView *viewToAttach = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, chartHeight)];
    viewToAttach.backgroundColor = [UIColor whiteColor];
    CGFloat heightPerUnit = chartHeight/11.5;
    
    int roundedScore = 0;
    if (score%10 < 5) {
        roundedScore = score/10*10;
    }
    else {
        roundedScore = score/10*10+10;
    }
    
    for (int i=10; i<= roundedScore;) {
        int multiplier = (100-i)/10 +1;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, multiplier*heightPerUnit+1, 50, heightPerUnit-1)];
        view.layer.cornerRadius = 0.05 * view.bounds.size.width;
        view.layer.masksToBounds = YES;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
        
        view.backgroundColor = [self getColor:i];
        [viewToAttach addSubview:view];
        i=i+10;
        
        if (i > roundedScore) {
            UILabel *lblScore = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.origin.y - 25, 50, 30)];
            lblScore.text = [NSString stringWithFormat:@"%li", (long)score];
            lblScore.textColor = kColorLabel;
            lblScore.textAlignment = NSTextAlignmentCenter;
            lblScore.font = [UIFont systemFontOfSize:14.0 weight:bold];
            [viewToAttach addSubview:lblScore];
        }
    }
    
    if (score == 0) {
        for (int i=0; i<10; i++) {
            int multiplier = (10-i);
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, multiplier*heightPerUnit+1, 50, heightPerUnit-1)];
            view.layer.cornerRadius = 0.07 * view.bounds.size.width;
            view.layer.masksToBounds = YES;
            view.layer.borderWidth = 1;
            view.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
            
            view.backgroundColor = [self getColor:-1];
            [viewToAttach addSubview:view];
        }
    }
 
//    if (score%10 >= 5) {
//        int multiplier = (100-(score+(score%10)))/10+1;
//       // int fractionHeight = (heightPerUnit/10)*(score%10)-1;
//        
//        UIView *viewHalf = [[UIView alloc]initWithFrame:CGRectMake(0, (multiplier+1)*heightPerUnit+1, 50, heightPerUnit-1)];
//        viewHalf.layer.cornerRadius = 0.07 * viewHalf.bounds.size.width;
//        viewHalf.layer.masksToBounds = YES;
//        viewHalf.layer.borderWidth = 1;
//        viewHalf.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
//        viewHalf.backgroundColor = [self getColor:score+10-(score%10)];
//        [viewToAttach addSubview:viewHalf];
//        
//        UILabel *lblScore = [[UILabel alloc] initWithFrame:CGRectMake(0, viewHalf.frame.origin.y - 25, 50, 30)];
//        lblScore.text = [NSString stringWithFormat:@"%i", score];
//        lblScore.textColor = kColorLabel;
//        lblScore.textAlignment = NSTextAlignmentCenter;
//        lblScore.font = [UIFont systemFontOfSize:14.0 weight:bold];
//        [viewToAttach addSubview:lblScore];
//    }
//    
    return viewToAttach;
}


- (UIColor*)getColor:(NSInteger)index {
    UIColor *color;
    switch (index) {
        case 10:
            color = kColor10;
            break;
        case 20:
            color = kColor20;
            break;
        case 30:
            color = kColor30;
            break;
        case 40:
            color = kColor40;
            break;
        case 50:
            color = kColor50;
            break;
        case 60:
            color = kColor60;
            break;
        case 70:
            color = kColor70;
            break;
        case 80:
            color = kColor80;
            break;
        case 90:
            color = kColor90;
            break;
        case 100:
            color = kColor100;
            break;
        default:
            color = kColorDefault;
            break;
    }
    return color;
}

- (IBAction)btnHideClicked:(id)sender {
    NSLog(@"btnClick : %ld", (long)[sender tag]);
    NSString *index = [NSString stringWithFormat:@"%ld", (long)[sender tag]];
    [dictHideSay setObject:@"isHide" forKey:index];
    [self.tableView reloadData];

}

- (IBAction)btnUndoClicked:(id)sender {
    NSLog(@"btnUndo : %ld", (long)[sender tag]);
    NSString *index = [NSString stringWithFormat:@"%ld", (long)[sender tag]];
    [dictHideSay setObject:@"isNoHide" forKey:index];
    [self.tableView reloadData];
}

- (IBAction)btnReportClicked:(id)sender {
    NSLog(@"btnReport : %ld", (long)[sender tag]);
    
}

- (IBAction)btnShareClicked:(id)sender {
    NSLog(@"btnShare : %ld", (long)[sender tag]);
    
}

- (IBAction)btnLikesClicked:(id)sender {
    NSLog(@"btnLikes : %ld", (long)[sender tag]);
    //TODO Change the button to liked or no-liked
}

-(IBAction)btnOpenMenu:(UIButton*)sender{
    [[SlideNavigationController sharedInstance]openMenu:MenuRight withCompletion:nil];
}

#pragma mark - FBInviteDelegate
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results {

}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error {

}


@end
