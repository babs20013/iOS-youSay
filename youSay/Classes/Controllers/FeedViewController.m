//
//  FeedViewController.m
//  youSay
//
//  Created by Muliana on 26/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedTableViewCell.h"
#import "UIImageView+Networking.h"
#import "AppDelegate.h"
#import "CommonHelper.h"
#import "SlideNavigationController.h"
#import "ProfileViewController.h"
#import "MainPageViewController.h"
#import "ViewPagerController.h"

@interface FeedViewController ()
{
    NSMutableArray *arrayFeed;
    BOOL isScrollBounce;
    int index;
    BOOL isNoMoreFeed;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation FeedViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    arrayFeed = [[NSMutableArray alloc]init];
    index = 1;
    isScrollBounce = YES;
    [self requestFeed:[NSString stringWithFormat:@"%i", index]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
#pragma mark - Request

- (void)requestFeed:(NSString*)startFrom {
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Loading..."];
    UIColor *blackColor = [UIColor colorWithWhite:0.42f alpha:0.4f];
    [SVProgressHUD setBackgroundColor:blackColor];
    
    NSMutableDictionary *dictRequest =  [[NSMutableDictionary alloc]init];
    [dictRequest setObject:REQUEST_FEED forKey:@"request"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner UserID] forKey:@"user_id"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner token]  forKey:@"token"];
    [dictRequest setObject:@"yousay_ios" forKey:@"app_name"];
    [dictRequest setObject:@"1.0" forKey:@"app_version"];
    [dictRequest setObject:@"10" forKey:@"max_items"];
    [dictRequest setObject:startFrom forKey:@"start_from"];
    [dictRequest setObject:@"1" forKey:@"sort"];
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:dictRequest completionBlock:^(id result, NSError *error) {
        if (result)
        {
            isScrollBounce = YES;
            NSDictionary *dictResult = result;
            
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                index = index+10;
                NSArray *arrResult = [dictResult objectForKey:@"items"];
                if (arrResult.count == 0) {
                    isNoMoreFeed = YES;
                }
                [arrayFeed addObjectsFromArray:arrResult];
                [self.tableView reloadData];
            }
            else if ([[dictResult valueForKey:@"message"] isEqualToString:@"invalid user token"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Say" message:[dictResult valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Say" message:[dictResult valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *currentSaysDict = [arrayFeed objectAtIndex:indexPath.section];
    NSString *string = [currentSaysDict valueForKey:@"feed_message"];
    CGSize expectedSize = [CommonHelper expectedSizeForString:string width:tableView.frame.size.width-65 font:[UIFont fontWithName:@"Arial" size:14] attributes:nil];
    NSArray *arrProfiles = [currentSaysDict objectForKey:@"profiles"];
    if (arrProfiles.count == 1) {
        return 105;
    }
    return expectedSize.height+115;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor lightGrayColor];
    
    return footerView;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arrayFeed.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FeedTableViewCell";
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (! cell) {
        
        cell = [[FeedTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSDictionary *currentSaysDict = [arrayFeed objectAtIndex:indexPath.section];
    NSArray *arrProfiles = [currentSaysDict objectForKey:@"profiles"];
    NSString *string = [currentSaysDict valueForKey:@"feed_message"];
     CGSize expectedSize = [CommonHelper expectedSizeForString:string width:tableView.frame.size.width-65 font:[UIFont fontWithName:@"Arial" size:14] attributes:nil];
    
    if (arrProfiles.count>0) {
        NSDictionary *profile1 = [arrProfiles objectAtIndex:0];
        [cell.imgViewProfile1 setImageURL:[NSURL URLWithString:[profile1 objectForKey:@"avatar"]]];
        cell.imgViewProfile1.layer.cornerRadius = 0.5 * cell.imgViewProfile1.bounds.size.width;
        cell.imgViewProfile1.layer.masksToBounds = YES;
        cell.imgViewProfile1.layer.borderWidth = 1;
        cell.imgViewProfile1.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
        cell.lblSaidAbout.text = [[currentSaysDict valueForKey:@"feed_title"] stringByReplacingOccurrencesOfString:@"%1" withString:[profile1 objectForKey:@"name"]];
        [cell.btnProfile1 setTag:indexPath.section];
    }
    
    if (arrProfiles.count == 1) {
        [cell.imgViewProfile2 setHidden:YES];
        [cell.lblSaidAbout2 setHidden:YES];
        [cell.viewSays setHidden:YES];
        [cell.btnReport setHidden:YES];
        [cell.btnShare setHidden:YES];
        [cell.btnLikes setHidden:YES];
        [cell.lblLikes setHidden:YES];
//        [cell.lblSaidAbout setFrame:CGRectMake(cell.lblSaidAbout.frame.origin.x, cell.lblSaidAbout.frame.origin.x, cell.lblSaidAbout.frame.size.width+200, cell.lblSaidAbout.frame.size.height)];
    }
    else if (arrProfiles.count == 2){
        [cell.imgViewProfile2 setHidden:NO];
        [cell.lblSaidAbout2 setHidden:NO];
        [cell.viewSays setHidden:NO];
        [cell.btnReport setHidden:NO];
        [cell.btnShare setHidden:NO];
        [cell.btnLikes setHidden:NO];
        [cell.lblLikes setHidden:NO];

        [cell.viewSays setFrame:CGRectMake(cell.viewSays.frame.origin.x, cell.viewSays.frame.origin.y, cell.viewSays.frame.size.width, expectedSize.height)];
        
        NSDictionary *profile2 = [arrProfiles objectAtIndex:1];
        string = [string stringByReplacingOccurrencesOfString:@"%2"
                                                   withString:@""];

        [cell.imgViewProfile2 setImageURL:[NSURL URLWithString:[profile2 objectForKey:@"avatar"]]];
        cell.imgViewProfile2.layer.cornerRadius = 0.5 * cell.imgViewProfile2.bounds.size.width;
        cell.imgViewProfile2.layer.masksToBounds = YES;
        cell.imgViewProfile2.layer.borderWidth = 1;
        cell.imgViewProfile2.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
        [cell.lblSaidAbout2 setText:[profile2 objectForKey:@"name"]];
        [cell.lblSaidAbout2 setNumberOfLines:0];
        
        cell.lblSaidAbout.text = [cell.lblSaidAbout.text stringByReplacingOccurrencesOfString:@"%2" withString:@""];
        [cell.btnProfile2 setTag:indexPath.section];
    }
    NSString *key = [NSString stringWithFormat:@"%@",[currentSaysDict objectForKey:@"say_color"]];
    NSDictionary *dicColor = [AppDelegate sharedDelegate].colorDict;
    NSDictionary *indexDict = [dicColor objectForKey:key];
   
    [cell.viewSays setBackgroundColor:[self colorWithHexString: [indexDict objectForKey:@"back"]]];
    
    [cell.lblSays setFrame:CGRectMake(cell.lblSays.frame.origin.x, cell.lblSays.frame.origin.y, cell.lblSays.frame.size.width, expectedSize.height)];
    [cell.lblSays setTextColor:[self colorWithHexString:[indexDict objectForKey:@"fore"]]];
    cell.lblSays.text = string;
    cell.lblDate.text = [currentSaysDict valueForKey:@"time_ago"];
    cell.lblLikes.text = [NSString stringWithFormat:@"%@", [currentSaysDict valueForKey:@"like_count"]];
    //TODO -- change button to red
    if ([[currentSaysDict objectForKey:@"like_status"] isEqualToString:@"yes"]) {
        //[cell.btnLikes setBackgroundColor:[UIColor redColor]];
    }
    cell.layer.cornerRadius = 0.005 * cell.bounds.size.width;
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
    
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

-(IBAction)btnOpenMenu:(UIButton*)sender{
    [[SlideNavigationController sharedInstance]openMenu:MenuRight withCompletion:nil];
}

#pragma mark - ScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height) && isScrollBounce) {
        if (!isNoMoreFeed) {
            isScrollBounce = NO;
            [self requestFeed:[NSString stringWithFormat:@"%i", index]];
        }
    }
}

-(IBAction)btnProfile1Clicked:(UIButton*)sender{
    NSLog(@"btnProfile : %ld", (long)[sender tag]);

    NSDictionary *value = [arrayFeed objectAtIndex:[sender tag]];
    NSArray *arrayProfile = [value objectForKey:@"profiles"];
    NSDictionary *requestedProfile = [arrayProfile objectAtIndex:0];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainPageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainPageViewController"];
    vc.isFriendProfile = YES;
    vc.requestedID = [requestedProfile objectForKey:@"profile_id"];
    vc.colorDictionary = [AppDelegate sharedDelegate].colorDict;
    vc.profileModel = [AppDelegate sharedDelegate].profileOwner;
    [self.navigationController pushViewController:vc animated:YES];
    [vc selectTabAtIndex:1];
}

-(IBAction)btnProfile2Clicked:(UIButton*)sender{
    NSLog(@"btnProfile : %ld", (long)[sender tag]);
    
    NSDictionary *value = [arrayFeed objectAtIndex:[sender tag]];
    NSArray *arrayProfile = [value objectForKey:@"profiles"];
    NSDictionary *requestedProfile = [arrayProfile objectAtIndex:1];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainPageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainPageViewController"];
    vc.isFriendProfile = YES;
    vc.requestedID = [requestedProfile objectForKey:@"profile_id"];
    vc.colorDictionary = [AppDelegate sharedDelegate].colorDict;
    vc.profileModel = [AppDelegate sharedDelegate].profileOwner;
    [self.navigationController pushViewController:vc animated:YES];
    [vc selectTabAtIndex:1];
}


@end
