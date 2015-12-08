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

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate> {
    ProfileOwnerModel *profileModel;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ProfileViewController

@synthesize profileDictionary;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    profileModel = [AppDelegate sharedDelegate].profileOwner;
    self.tableView.delegate = self;
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.tintColor = [UIColor clearColor];
    [self.view addSubview:searchBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO-- Should be dynamic based on the iPhone device height
    return 511;
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
        
        //--Profile Box
        cel.imgViewCover.image = profileModel.CoverImage;
        cel.imgViewProfilePicture.image = profileModel.ProfileImage;
        cel.imgViewProfilePicture.layer.cornerRadius = 0.5 * cel.imgViewProfilePicture.bounds.size.width;
        cel.imgViewProfilePicture.layer.masksToBounds = YES;
        cel.imgViewProfilePicture.layer.borderWidth = 1;
        cel.imgViewProfilePicture.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;

        cel.lblName.text = @"name";//profileModel.Name;
        NSInteger popularity = [[profileDictionary objectForKey:@"popularity"] integerValue];
        NSInteger wiz = [[profileDictionary objectForKey:@"rank"] integerValue];
        [cel.newbie setTitle:[NSString stringWithFormat:@"%ld", (long)wiz] forState:UIControlStateNormal];
        [cel.popular setTitle:[NSString stringWithFormat:@"%ld", (long)popularity] forState:UIControlStateNormal];
        
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
        
        [cel.viewCharm1 addSubview:[self getCharmsDisplay:cel.viewCharm1.frame.size.height withScore:10]];
        [cel.viewCharm2 addSubview:[self getCharmsDisplay:cel.viewCharm2.frame.size.height withScore:80]];
        [cel.viewCharm3 addSubview:[self getCharmsDisplay:cel.viewCharm3.frame.size.height withScore:75]];
        [cel.viewCharm4 addSubview:[self getCharmsDisplay:cel.viewCharm4.frame.size.height withScore:64]];
        [cel.viewCharm5 addSubview:[self getCharmsDisplay:cel.viewCharm5.frame.size.height withScore:73]];
        
        cel.selectionStyle = UITableViewCellSelectionStyleNone;
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

- (UIView*)getCharmsDisplay:(CGFloat)chartHeight withScore:(NSInteger)score {
    UIView *viewToAttach = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, chartHeight)];
    viewToAttach.backgroundColor = [UIColor whiteColor];
    CGFloat heightPerUnit = chartHeight/11;
    
    for (int i=10; i<=score;) {
        int multiplier = (100-i)/10 +1;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, multiplier*heightPerUnit+1, 50, heightPerUnit-1)];
        view.layer.cornerRadius = 0.1 * view.bounds.size.width;
        view.layer.masksToBounds = YES;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
        
        view.backgroundColor = [self getColor:i];
        [viewToAttach addSubview:view];
        i=i+10;
    }
 
    if (score%10 > 0) {
        int multiplier = (100-(score+(score%10)))/10+1;
        int fractionHeight = (heightPerUnit/10)*(score%10)-1;
        
        UIView *viewHalf = [[UIView alloc]initWithFrame:CGRectMake(0, (multiplier+1)*heightPerUnit-fractionHeight, 50, fractionHeight)];
        viewHalf.layer.cornerRadius = 0.1 * viewHalf.bounds.size.width;
        viewHalf.layer.masksToBounds = YES;
        viewHalf.layer.borderWidth = 1;
        viewHalf.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
        viewHalf.backgroundColor = [self getColor:score+10-(score%10)];
        [viewToAttach addSubview:viewHalf];
    }
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
            color = kColor10;
            break;
    }
    return color;
}




@end
