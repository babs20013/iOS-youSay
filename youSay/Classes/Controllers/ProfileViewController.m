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
#import "CommonHelper.h"
#import "UIImageView+Networking.h"
#import "ProfileOwnerModel.h"
#import "RequestModel.h"
#import "SelectCharmsViewController.h"

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
    UIImageView *imgViewRank;
    UIImageView *imgViewPopularity;
    ChartState chartState;
    BOOL isFriendProfile;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ProfileViewController

@synthesize profileDictionary;
@synthesize colorDictionary;
@synthesize saysArray;


- (void)viewWillAppear:(BOOL)animated {
    NSString *completeUrl=[NSString stringWithFormat:@"https://graph.facebook.com/"];
    [self loadFaceBookData:completeUrl param:@{@"fields":@"email,picture,name,first_name,last_name,gender,cover",@"access_token":[FBSDKAccessToken currentAccessToken].tokenString}];    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    chartState = ChartStateDefault;
    isFriendProfile = NO;
    
    CharmChart *chart = [[CharmChart alloc]init];
    chart.delegate = self;
    
    dictHideSay = [[NSMutableDictionary alloc] init];
    profileModel = [AppDelegate sharedDelegate].profileOwner;
    imgViewRank = [[UIImageView alloc]init];
    imgViewPopularity = [[UIImageView alloc]init];
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


#pragma mark - Load Login credential

-(void)loadFaceBookData:(NSString*)fbURLString param:(NSDictionary*)param
{
    AFHTTPClient * client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:fbURLString]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"text/html"];
    [client getPath:@"me"
         parameters:param
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                NSString* facebook_id=@"";
                
                profileModel = [[ProfileOwnerModel alloc]init];
                profileModel.Name = [resultDic valueForKey:@"name"];
                profileModel.UserID = [resultDic objectForKey:@"user_id"];
                profileModel.FacebookToken = [FBSDKAccessToken currentAccessToken].tokenString;
                profileModel.FacebookID = [resultDic objectForKey:@"id"];
                
                //--Get profile picture
                NSDictionary *pictureDict = [[resultDic objectForKey:@"picture"] objectForKey:@"data"];
                NSString *pictureURL = [pictureDict objectForKey:@"url"];
                profileModel.ProfileImage = pictureURL;
                
                //--Get cover picture
                NSString *coverURL = [[resultDic objectForKey:@"cover"] objectForKey:@"source"];
                profileModel.CoverImage = coverURL;
                
                if([resultDic valueForKey:@"id"]&&[[resultDic valueForKey:@"id"]isKindOfClass:[NSString class]]){
                    facebook_id=[resultDic valueForKey:@"id"];
                }
                [self requestLogin];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error!", nil) message:NSLocalizedString(@"There is an Error While logging in! Please try Again.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil]show];
            }];
}

- (void)requestLogin {
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Loading..."];
    UIColor *blackColor = [UIColor colorWithWhite:0.42f alpha:0.4f];
    [SVProgressHUD setBackgroundColor:blackColor];
    
    RequestModel *loginReq = [[RequestModel alloc]init];
    loginReq.request = REQUEST_LOGIN;
    loginReq.authorization_id = profileModel.FacebookID;
    loginReq.authority_type = AUTHORITY_TYPE_FB;
    loginReq.authority_access_token = profileModel.FacebookToken;
    loginReq.app_name = APP_NAME;
    loginReq.app_version = APP_VERSION;
    loginReq.device_info = @"iPhone 5";
    
    
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:loginReq completionBlock:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                profileModel.UserID = [dictResult valueForKey:@"user_id"];
                profileModel.token = [dictResult valueForKey:@"token"];
                [AppDelegate sharedDelegate].profileOwner = profileModel;
                profileDictionary = [result objectForKey:@"profile"];
                [self requestSayColor];
            }
        }
        else if (error)
        {
        }
        else{
            
        }
    }];
}

- (void)requestFriendProfile:(NSString*)requestedID {
    NSMutableDictionary *dictRequest =  [[NSMutableDictionary alloc]init];
    [dictRequest setObject:REQUEST_GET_PROFILE forKey:@"request"];
    [dictRequest setObject:profileModel.UserID forKey:@"user_id"];
    [dictRequest setObject:profileModel.token forKey:@"token"];
    [dictRequest setObject:requestedID forKey:@"requested_user_id"];
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:dictRequest completionBlock:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                profileDictionary = [dictResult objectForKey:@"profile"];
                saysArray = [profileDictionary valueForKey:@"says"];
                isFriendProfile = YES;
                if ([[AppDelegate sharedDelegate].profileOwner UserID] == [dictResult objectForKey:@"user_id"]) {
                    isFriendProfile = NO;
                }
                [self.tableView reloadData];
            }
        }
        else if (error)
        {
        }
        else{
            
        }
        [SVProgressHUD dismiss];
    }];
}

- (void)requestSayColor {
    NSMutableDictionary *dictRequest =  [[NSMutableDictionary alloc]init];
    [dictRequest setObject:REQUEST_SAY_COLOR forKey:@"request"];
    [dictRequest setObject:profileModel.UserID forKey:@"user_id"];
    [dictRequest setObject:profileModel.token forKey:@"token"];
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:dictRequest completionBlock:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                colorDictionary = [result objectForKey:@"colors"];
                saysArray = [[NSMutableArray alloc]init];
                saysArray = [profileDictionary valueForKey:@"says"];
                [self.tableView reloadData];
            }
        }
        else if (error)
        {
        }
        else{
            
        }
        [SVProgressHUD dismiss];
    }];
    
}




#pragma mark TableView

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *thisView = [[UIView alloc]init];
    thisView.backgroundColor = [UIColor whiteColor];//kColorBG;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 30)];
    label.text = [NSString stringWithFormat:@"What people SAID about %@", profileModel.Name];
    label.numberOfLines = 2;
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
        if (self.view.frame.size.height >= 667) {//6+
            return self.view.frame.size.height - 155;
        }
        else if (self.view.frame.size.height >= 568) {//6
            return self.view.frame.size.height - 110;
        }
        else if (self.view.frame.size.height >= 480) {//5
            return self.view.frame.size.height - 60;
        }
        else{//4
            return self.view.frame.size.height + 25;
        }
    }
    else if (indexPath.section == 1) {
        NSString *index = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        if ([[dictHideSay objectForKey:index] isEqualToString:@"isHide"]) {
            return 90;
        }
        NSDictionary *currentSaysDict = [saysArray objectAtIndex:indexPath.row];
        NSString *string = [currentSaysDict valueForKey:@"text"];
        CGSize expectedSize = [CommonHelper expectedSizeForString:string width:tableView.frame.size.width-65 font:[UIFont fontWithName:@"Arial" size:14] attributes:nil];
        return 70 + expectedSize.height + 30 + 20;
    }
    else if (indexPath.section == 2) {
        return 65;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    if (chartState == ChartStateEdit) {
        return 1;
    }
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
        ProfileOwnerModel *model = [[ProfileOwnerModel alloc]init];
        
        if  ([[AppDelegate sharedDelegate].profileOwner UserID] == profileModel.UserID &&
             isFriendProfile == NO){
            model = profileModel;
        }
        else {
            model.Name = [profileDictionary objectForKey:@"name"];
            model.ProfileImage = [profileDictionary objectForKey:@"picture"];
            model.CoverImage = [profileDictionary objectForKey:@"cover_url"];
           // chartState = ChartStateViewing;
        }
        //--Profile Box
        [cel.imgViewCover setImageURL:[NSURL URLWithString:model.CoverImage]];
        cel.imgViewCover.layer.cornerRadius = 0.015 * cel.imgViewCover.bounds.size.width;
        cel.imgViewCover.layer.masksToBounds = YES;
        cel.imgViewCover.layer.borderWidth = 1;
        cel.imgViewCover.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
        
        
        [cel.imgViewProfilePicture setImageURL:[NSURL URLWithString:model.ProfileImage]];
        cel.imgViewProfilePicture.layer.cornerRadius = 0.5 * cel.imgViewProfilePicture.bounds.size.width;
        cel.imgViewProfilePicture.layer.masksToBounds = YES;
        cel.imgViewProfilePicture.layer.borderWidth = 1;
        cel.imgViewProfilePicture.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;

        cel.lblName.text = model.Name;
        NSInteger popularity = [[profileDictionary objectForKey:@"popularity"] integerValue];
        NSInteger wiz = [[profileDictionary objectForKey:@"rank"] integerValue];
        [cel.newbie setTitle:[NSString stringWithFormat:@"%ld", (long)wiz] forState:UIControlStateNormal];
        [cel.popular setTitle:[NSString stringWithFormat:@"%ld", (long)popularity] forState:UIControlStateNormal];
        
        [cel.newbie setBackgroundImage:imgViewRank.image forState:UIControlStateNormal];
        [cel.popular setBackgroundImage:imgViewPopularity.image forState:UIControlStateNormal];
        
        [imgViewRank setImageURL:[NSURL URLWithString:[profileDictionary objectForKey:@"rank_picture"]] withCompletionBlock:^(BOOL succes, UIImage *image, NSError *error) {
            ProfileTableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
            if (updateCell) {
                [cel.newbie setBackgroundImage:image forState:UIControlStateNormal];
            }
        }];
        [imgViewPopularity setImageURL:[NSURL URLWithString:[profileDictionary objectForKey:@"popularity_picture"]] withCompletionBlock:^(BOOL succes, UIImage *image, NSError *error) {
            ProfileTableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
            if (updateCell) {
                [cel.popular setBackgroundImage:image forState:UIControlStateNormal];
            }
        }];
        cel.lblRankLevel.text = [profileDictionary objectForKey:@"rank_level"];
        cel.lblPopularityLevel.text = [profileDictionary objectForKey:@"popularity_level"];
        
        cel.charmView.layer.cornerRadius = 0.015 * cel.charmView.bounds.size.width;
        cel.charmView.layer.masksToBounds = YES;
        cel.charmView.layer.borderWidth = 1;
        cel.charmView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
//        
//        CGFloat totalWidth = cel.charmView.bounds.size.width;
//        CGFloat charmWidth = totalWidth / 110 * 100 / 5;
//        CGFloat spaceBetweenCharm = (totalWidth - charmWidth)/4;
//        CGFloat height = 183;
//        
//        cel.viewCharm1.frame = CGRectMake(0, 0, charmWidth, height);
//        cel.viewCharm2.frame = CGRectMake(charmWidth+spaceBetweenCharm, 0, charmWidth, height);
//        cel.viewCharm3.frame = CGRectMake(2*charmWidth+2*spaceBetweenCharm, 0, charmWidth, height);
//        cel.viewCharm4.frame = CGRectMake(3*charmWidth+3*spaceBetweenCharm, 0, charmWidth, height);
//        cel.viewCharm5.frame = CGRectMake(4*charmWidth+4*spaceBetweenCharm, 0, charmWidth, height);
        
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
        
        CGFloat w = (tableView.frame.size.width - 40-28) / 5;
        CGFloat h = (( w/3 )+2)*13;
        CGRect f1 =  CGRectMake(0, 0, w,h);
        
//        CharmChart *chart = [[CharmChart alloc]initWithFrame:f1];
//        chart.state = ChartStateDefault;
//        chart.score = 100;
//        chart.title = [dict1 valueForKey:@"name"];
//        
//        CharmChart *chart1 = [[CharmChart alloc]initWithFrame:f1];
//        chart1.state = ChartStateDefault;
//        chart1.score = score2;
//        chart1.title = [dict2 valueForKey:@"name"];
//
//        
//        CharmChart *chart2 = [[CharmChart alloc]initWithFrame:f1];
//        chart2.state = ChartStateDefault;
//        chart2.score = score3;
//        chart2.title = [dict3 valueForKey:@"name"];
//        
//        CharmChart *chart3 = [[CharmChart alloc]initWithFrame:f1];
//        chart3.state = ChartStateDefault;
//        chart3.score = 100;
//        chart3.title = [dict4 valueForKey:@"name"];
//        
//        CharmChart *chart4 = [[CharmChart alloc]initWithFrame:f1];
//        chart4.state = ChartStateDefault;
//        chart4.score = 100;
//        chart4.title = [dict5 valueForKey:@"name"];
        
        
        //[cel.charmChartView setBackgroundColor:[UIColor blackColor]];
        [[cel.charmChartView subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];

        cel.charmChartView.delegate = self;
        cel.charmChartView.chartScores  =  [NSMutableArray arrayWithObjects:[@(score) stringValue],[@(score2) stringValue],[@(score3) stringValue],[@(score4) stringValue],[@(score5) stringValue], nil];
        cel.charmChartView.chartNames  =  [NSMutableArray arrayWithObjects:[dict1 valueForKey:@"name"],[dict2 valueForKey:@"name"],[dict3 valueForKey:@"name"],[dict4 valueForKey:@"name"],[dict5 valueForKey:@"name"], nil];
        
        cel.charmChartView.state = chartState;
        
        if (chartState == ChartStateEdit) {
            [cel.longPressInfoView setHidden:YES];
            [cel.lblShare setHidden:YES];
            [cel.btnShare setHidden:YES];
            [cel.imgVShare setHidden:YES];
            [cel.buttonEditView setHidden:NO];
        }
        else if (isFriendProfile == YES) {
            [cel.longPressInfoView setHidden:YES];
            [cel.lblShare setHidden:YES];
            [cel.btnShare setHidden:YES];
            [cel.imgVShare setHidden:YES];
            [cel.buttonEditView setHidden:YES];
        }
        else{
            [cel.longPressInfoView setHidden:NO];
            [cel.lblShare setHidden:NO];
            [cel.btnShare setHidden:NO];
            [cel.imgVShare setHidden:NO];
            [cel.buttonEditView setHidden:YES];
        }
        cel.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        return cel;
    }
    
    else if (indexPath.section == 1)
    {
        static NSString *cellIdentifier = @"PeopleSayTableViewCell";
        PeopleSayTableViewCell *cel = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSDictionary *currentSaysDict = [saysArray objectAtIndex:indexPath.row];
        NSString *colorIndex = [NSString stringWithFormat:@"%@",[currentSaysDict objectForKey:@"say_color"]];
        
        cel.mainView.layer.cornerRadius = 0.015 * cel.mainView.bounds.size.width;
        cel.mainView.layer.masksToBounds = YES;
        cel.mainView.layer.borderWidth = 1;
        cel.mainView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
        
        

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
        cel.btnProfile.tag = indexPath.row;
        NSDictionary *indexDict = [colorDictionary objectForKey:colorIndex];
        [cel.peopleSayView setBackgroundColor:[self colorWithHexString: [indexDict objectForKey:@"back"]]];
        [cel.peopleSayLabel setTextColor:[self colorWithHexString: [indexDict objectForKey:@"fore"]]];                                          
        [cel.peopleSayLabel sizeToFit];
        CGSize expectedSize = [CommonHelper expectedSizeForLabel:cel.peopleSayLabel attributes:nil];
        cel.peopleSayLabel.frame = CGRectMake(cel.peopleSayLabel.frame.origin.x, cel.peopleSayLabel.frame.origin.y, expectedSize.width, expectedSize.height);
        cel.peopleSayView.frame =CGRectMake(cel.peopleSayView.frame.origin.x, cel.peopleSayView.frame.origin.y, expectedSize.width, expectedSize.height);
        
        NSString *index = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        if ([[dictHideSay objectForKey:index] isEqualToString:@"isHide"]) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            UIView *hideView = [[UIView alloc]initWithFrame:CGRectMake(15, 10, tableView.frame.size.width-30, [tableView rectForRowAtIndexPath:indexPath].size.height - 20)];
            [hideView setBackgroundColor:[UIColor colorWithRed:205/255.f green:205/255.f blue:205/255.f alpha:1]];
            UILabel *lblHideInfo = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, hideView.frame.size.width-40, 20)];
            [lblHideInfo setText:@"this say will be hidden from your profile"];
            [lblHideInfo setFont:[UIFont fontWithName:@"Arial" size:12]];
            [lblHideInfo setTextAlignment:NSTextAlignmentCenter];
            [lblHideInfo setTextColor:[UIColor darkGrayColor]];
            [hideView addSubview:lblHideInfo];
            
            UIButton *btnUndo = [[UIButton alloc]initWithFrame:CGRectMake((hideView.frame.size.width-50)/2, lblHideInfo.frame.origin.y+lblHideInfo.frame.size.height+0, 50, 25)];
            btnUndo.tag = indexPath.row;
            [btnUndo addTarget:self action:@selector(btnUndoClicked:) forControlEvents:UIControlEventTouchUpInside];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Undo"
                            attributes:
                                            @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                              NSForegroundColorAttributeName: [UIColor colorWithRed:23/255.f green:174/255.f blue:201/255.f alpha:1],
                                              NSFontAttributeName: [UIFont fontWithName:@"Arial" size:14]}]];
            [btnUndo setAttributedTitle:attributedString forState:UIControlStateNormal];
            [hideView addSubview:btnUndo];

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:hideView];
            return cell;
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
    
    NSInteger roundedScore = 0;
    if (score < 10) {
        roundedScore = 10;
    }
    else if (score%10 < 5) {
        roundedScore = score/10*10;
    }
    else {
        roundedScore = score/10*10+10;
    }
    
    for (int i=10; i<= roundedScore;) {
        int multiplier = (100-i)/10 +1;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, multiplier*heightPerUnit+1, 50, heightPerUnit-1)];
        view.layer.cornerRadius = 0.03 * view.bounds.size.width;
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
    
//    if (score == 0) {
//        for (int i=0; i<10; i++) {
//            int multiplier = (10-i);
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, multiplier*heightPerUnit+1, 50, heightPerUnit-1)];
//            view.layer.cornerRadius = 0.07 * view.bounds.size.width;
//            view.layer.masksToBounds = YES;
//            view.layer.borderWidth = 1;
//            view.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
//            
//            view.backgroundColor = [self getColor:-1];
//            [viewToAttach addSubview:view];
//        }
//    }
 
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

#pragma mark - IBAction

- (IBAction)btnHideClicked:(id)sender {
    NSLog(@"btnClick : %ld", (long)[sender tag]);
    NSString *index = [NSString stringWithFormat:@"%ld", (long)[sender tag]];
    [dictHideSay setObject:@"isHide" forKey:index];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[sender tag] inSection:1]] withRowAnimation:UITableViewRowAnimationFade];

}

- (IBAction)btnUndoClicked:(id)sender {
    NSLog(@"btnUndo : %ld", (long)[sender tag]);
    NSString *index = [NSString stringWithFormat:@"%ld", (long)[sender tag]];
    [dictHideSay setObject:@"isNoHide" forKey:index];
    //[self.tableView reloadData];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[sender tag] inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
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

-(IBAction)btnDoneEdit:(UIButton*)sender{
    chartState = ChartStateDefault;
    // do some logic
    
    [self.tableView reloadData];

}
-(IBAction)btnCancelEdit:(UIButton*)sender{
    chartState = ChartStateDefault;
    [self.tableView reloadData];

}

-(IBAction)btnProfileClicked:(UIButton*)sender{
    NSLog(@"btnProfile : %ld", (long)[sender tag]);
    NSDictionary *value = [saysArray objectAtIndex:[sender tag]];
    [self requestFriendProfile:[value objectForKey:@"user_id"]];
}
#pragma mark - FBInviteDelegate
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results {

}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error {

}

#pragma mark - Chart Delegate
-(void)didBeginEditing:(CharmView *)charm{
    chartState = charm.state;
    [self.tableView reloadData];
    
}

-(void)showSelectionOfCharm:(NSString*)charmOut {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SelectCharmsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SelectCharmsViewController"];
    vc.parent = self;
    [vc setCharmOut:charmOut];
    //= [[NSString alloc]initWithString:charmOut];//[NSString stringWithFormat:@"%@", charmOut];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"masuk ke parentnnya");
    if ([parent isKindOfClass:[SelectCharmsViewController class]]) {
        [self.tableView reloadData];
    }
}


@end
