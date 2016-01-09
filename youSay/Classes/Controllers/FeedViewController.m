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
#import "ReportSayViewController.h"
#import "WhoLikeThisViewController.h"
#import "WhoLikeListTableViewCell.h"

@interface FeedViewController ()
{
    NSMutableArray *arrayFeed;
    NSArray *arraySearch;
    BOOL isScrollBounce;
    int index;
    BOOL isNoMoreFeed;
    BOOL isLikeListReleased;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITableView *searchUserTableView;
@property (nonatomic, weak) IBOutlet UIButton *btnClear;
@property (nonatomic, strong) IBOutlet UITextField * txtSearch;
@property (nonatomic, strong) IBOutlet UIView * searchView;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@end

@implementation FeedViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshFeed:)
                                                 name:@"refreshpage"
                                               object:nil];
    
    isScrollBounce = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isLikeListReleased = NO;
    arrayFeed = [[NSMutableArray alloc]init];
    index = 1;
    [self requestFeed:[NSString stringWithFormat:@"%i", index]];
    [_txtSearch addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
    UIImageView *imgMagnifyingGlass = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 15)];
    imgMagnifyingGlass.image = [UIImage imageNamed:@"search"];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [leftView addSubview:imgMagnifyingGlass];
    self.txtSearch.leftView = leftView;
    self.txtSearch.leftViewMode = UITextFieldViewModeAlways;
    self.txtSearch.layer.cornerRadius = round(self.txtSearch.frame.size.height / 2);
    self.txtSearch.layer.borderWidth = 1;
    self.txtSearch.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.searchUserTableView.layer.cornerRadius = 0.015 * self.searchUserTableView.bounds.size.width;
    self.searchUserTableView.layer.masksToBounds = YES;
    self.searchUserTableView.layer.borderWidth = 1;
    self.searchUserTableView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
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
                if ([startFrom integerValue] == 1 && arrResult.count > 0) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
            else if ([[dictResult valueForKey:@"message"] isEqualToString:@"invalid user token"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Say" message:[dictResult valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [self logout];
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

- (void)requesLikeSay:(id)sender{
    NSMutableDictionary *feedDict = [[NSMutableDictionary alloc]init];
    feedDict = [[arrayFeed objectAtIndex:[sender tag]] mutableCopy];
    
    NSMutableDictionary *dictRequest =  [[NSMutableDictionary alloc]init];
    [dictRequest setObject:REQUEST_LIKE_SAY forKey:@"request"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner UserID] forKey:@"user_id"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner token]  forKey:@"token"];
    [dictRequest setObject:[feedDict objectForKey:@"say_id"] forKey:@"say_id"];
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:dictRequest completionBlock:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                NSInteger count = [[feedDict objectForKey:@"like_count"] integerValue]+1;
                [feedDict setObject:@"yes" forKey:@"like_status"];
                [feedDict setObject:[NSNumber numberWithInteger:count] forKey:@"like_count"];
                [arrayFeed replaceObjectAtIndex:[sender tag] withObject:feedDict];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:[sender tag]]] withRowAnimation:UITableViewRowAnimationNone];
            }
            else if ([[dictResult valueForKey:@"message"] isEqualToString:@"invalid user token"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Say" message:[dictResult valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [self logout];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Say" message:[dictResult valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                UIButton *button = (UIButton*)sender;
                UIView *view = button.superview; //Cell contentView
                FeedTableViewCell *cell = (FeedTableViewCell *)view.superview;
                [cell.btnLikes setSelected:NO];
                NSInteger likeCount = [[cell.lblLikes text]integerValue] - 1;
                [cell.lblLikes setText:[NSString stringWithFormat:@"%li", (long)likeCount]];
            }
        }
        else if (error)
        {
            UIButton *button = (UIButton*)sender;
            UIView *view = button.superview; //Cell contentView
            FeedTableViewCell *cell = (FeedTableViewCell *)view.superview;
            [cell.btnLikes setSelected:NO];
            NSInteger likeCount = [[cell.lblLikes text]integerValue] - 1;
            [cell.lblLikes setText:[NSString stringWithFormat:@"%li", (long)likeCount]];
        }
        else{
            UIButton *button = (UIButton*)sender;
            UIView *view = button.superview; //Cell contentView
            FeedTableViewCell *cell = (FeedTableViewCell *)view.superview;
            [cell.btnLikes setSelected:NO];
            NSInteger likeCount = [[cell.lblLikes text]integerValue] - 1;
            [cell.lblLikes setText:[NSString stringWithFormat:@"%li", (long)likeCount]];
        }
    }];
}

- (void)requesUnlikeSay:(id)sender{
    NSMutableDictionary *feedDict = [[NSMutableDictionary alloc]init];
    feedDict = [[arrayFeed objectAtIndex:[sender tag]] mutableCopy];
    
    
    NSMutableDictionary *dictRequest =  [[NSMutableDictionary alloc]init];
    [dictRequest setObject:REQUEST_UNLIKE_SAY forKey:@"request"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner UserID] forKey:@"user_id"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner token]  forKey:@"token"];
    [dictRequest setObject:[feedDict objectForKey:@"say_id"] forKey:@"say_id"];
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:dictRequest completionBlock:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                NSInteger count = [[feedDict objectForKey:@"like_count"] integerValue]-1;
                [feedDict setObject:@"no" forKey:@"like_status"];
                [feedDict setObject:[NSNumber numberWithInteger:count] forKey:@"like_count"];
                [arrayFeed replaceObjectAtIndex:[sender tag] withObject:feedDict];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:[sender tag]]] withRowAnimation:UITableViewRowAnimationNone];
            }
            else if ([[dictResult valueForKey:@"message"] isEqualToString:@"invalid user token"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Say" message:[dictResult valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [self logout];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Say" message:[dictResult valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                UIButton *button = (UIButton*)sender;
                UIView *view = button.superview; //Cell contentView
                FeedTableViewCell *cell = (FeedTableViewCell *)view.superview;
                [cell.btnLikes setSelected:YES];
                NSInteger likeCount = [[cell.lblLikes text]integerValue] + 1;
                [cell.lblLikes setText:[NSString stringWithFormat:@"%li", (long)likeCount]];
            }        }
        else if (error)
        {
            UIButton *button = (UIButton*)sender;
            UIView *view = button.superview; //Cell contentView
            FeedTableViewCell *cell = (FeedTableViewCell *)view.superview;
            [cell.btnLikes setSelected:YES];
            NSInteger likeCount = [[cell.lblLikes text]integerValue] + 1;
            [cell.lblLikes setText:[NSString stringWithFormat:@"%li", (long)likeCount]];
        }
        else{
            UIButton *button = (UIButton*)sender;
            UIView *view = button.superview; //Cell contentView
            FeedTableViewCell *cell = (FeedTableViewCell *)view.superview;
            [cell.btnLikes setSelected:YES];
            NSInteger likeCount = [[cell.lblLikes text]integerValue] + 1;
            [cell.lblLikes setText:[NSString stringWithFormat:@"%li", (long)likeCount]];
        }
    }];
}

- (void)requestUser:(NSString*)searchString withSearchID:(NSString*)searchID {
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Loading..."];
    UIColor *blackColor = [UIColor colorWithWhite:0.42f alpha:0.4f];
    [SVProgressHUD setBackgroundColor:blackColor];
    
    NSMutableDictionary *dictRequest =  [[NSMutableDictionary alloc]init];
    [dictRequest setObject:REQUEST_SEARCH_USER forKey:@"request"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner UserID] forKey:@"user_id"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner token] forKey:@"token"];
    [dictRequest setObject:searchString forKey:@"search_text"];
    [dictRequest setObject:AUTHORITY_TYPE_FB forKey:@"authority_type"];
    [dictRequest setObject:[FBSDKAccessToken currentAccessToken].tokenString forKey:@"authority_access_token"];
    [dictRequest setObject:searchID forKey:@"search_id"];
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:dictRequest completionBlock:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                arraySearch = [dictResult objectForKey:@"yousay_users"];
                self.tableHeightConstraint.constant = arraySearch.count*50;
                [self.searchUserTableView needsUpdateConstraints];
                [self.searchUserTableView reloadData];
            }
            else if ([[dictResult valueForKey:@"message"] isEqualToString:@"invalid user token"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Say" message:[dictResult valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [self logout];
            }
            else if ([[dictResult valueForKey:@"rc"] integerValue] == 602) {
                //If search is still in progress, keep searching
                [self requestUser:searchString withSearchID:searchID];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Say" message:[dictResult valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [self dismissViewControllerAnimated:YES completion:nil];
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
    if (tableView == self.searchUserTableView) {
        return 50;
    }
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
    if (tableView == self.searchUserTableView) {
        return 0;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor lightGrayColor];
    
    return footerView;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchUserTableView) {
        return 1;
    }
    return arrayFeed.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchUserTableView) {
        return arraySearch.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchUserTableView) {
        return [self consctructTableForSearchUser:tableView withIndexPath:indexPath];
    }
    return [self consctructTableForFeed:tableView withIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchUserTableView) {
        NSDictionary *dict = [arraySearch objectAtIndex:indexPath.row];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainPageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainPageViewController"];
        vc.isFriendProfile = YES;
        vc.isFromFeed = YES;
        vc.requestedID = [dict objectForKey:@"user_id"];
        vc.colorDictionary = [AppDelegate sharedDelegate].colorDict;
        vc.profileModel = [AppDelegate sharedDelegate].profileOwner;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (UITableViewCell*)consctructTableForFeed:(UITableView*)tableView withIndexPath:(NSIndexPath*)indexPath {
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
        NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:[[currentSaysDict valueForKey:@"feed_title"] stringByReplacingOccurrencesOfString:@"%1" withString:[profile1 objectForKey:@"name"]]];
        cell.lblSaidAbout.attributedText = attributedText;
        [cell.btnProfile1 setTag:indexPath.section];
        [cell.btnLblProfile1 setTag:indexPath.section];
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
        [cell.btnLikes setTag:indexPath.section];
        if ([[currentSaysDict objectForKey:@"like_status"] isEqualToString:@"yes"]) {
            [cell.btnLikes setSelected:YES];
        }
        else {
            [cell.btnLikes setSelected:NO];
        }
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
        [cell.btnLblProfile2 setTag:indexPath.section];
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
    
    if ([cell.lblLikes.text integerValue] < 1) {
        [cell.btnLikeCount setEnabled:NO];
    }
    else {
        [cell.btnLikeCount setEnabled:YES];
        [cell.btnLikeCount setTag:[[currentSaysDict valueForKey:@"say_id"] integerValue]];
    }
    
    cell.layer.cornerRadius = 0.005 * cell.bounds.size.width;
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
    
    return cell;
}

- (UITableViewCell*)consctructTableForSearchUser:(UITableView*)tableView withIndexPath:(NSIndexPath*)indexPath {
    static NSString *cellIdentifier = @"WhoLikeListTableViewCell";
    WhoLikeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (! cell) {
        
        cell = [[WhoLikeListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSDictionary *dict = [arraySearch objectAtIndex:indexPath.row];
    NSString *urlString = [dict objectForKey:@"image_url"];
    [cell.profileView setImageURL:[NSURL URLWithString:urlString]];
    cell.profileView.layer.cornerRadius = cell.profileView.frame.size.width/2;
    cell.profileView.layer.masksToBounds = YES;
    cell.profileView.layer.borderWidth = 1;
    cell.profileView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
    
    [cell.profileName setText:[dict objectForKey:@"name"]];
    
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

-(IBAction)btnLikesClicked:(UIButton*)sender{
    NSLog(@"btnLikes : %ld", (long)[sender tag]);
    UIButton *button = (UIButton*)sender;
    button.selected = !button.selected;
    
    if ([button isSelected]) {
        UIView *view = button.superview; //Cell contentView
        FeedTableViewCell *cell = (FeedTableViewCell *)view.superview;
        NSInteger likeCount = [[cell.lblLikes text] integerValue] + 1;
        [cell.lblLikes setText:[NSString stringWithFormat:@"%li", (long)likeCount]];
        [self requesLikeSay:sender];
    }
    else {
        UIView *view = button.superview; //Cell contentView
        FeedTableViewCell *cell = (FeedTableViewCell *)view.superview;
        NSInteger likeCount = [[cell.lblLikes text] integerValue] - 1;
        [cell.lblLikes setText:[NSString stringWithFormat:@"%li", (long)likeCount]];
        [self requesUnlikeSay:sender];
    }
}

- (IBAction)btnReportClicked:(id)sender {
    ReportSayViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReportSayViewController"];
    NSDictionary *dict = [arrayFeed objectAtIndex:[sender tag]];
    vc.say_id = [dict objectForKey:@"say_id"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)btnLikeCountClicked:(id)sender {
    WhoLikeThisViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WhoLikeThisViewController"];
    vc.delegate = self;
    vc.say_id = [NSString stringWithFormat:@"%li", (long)[sender tag]];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)btnClearSearchClicked:(id)sender {
    NSLog(@"clear user search");
}

- (void) refreshFeed:(NSNotification *)notif {
    arrayFeed = [[NSMutableArray alloc]init];
    index = 1;
    isNoMoreFeed = NO;
    [self requestFeed:[NSString stringWithFormat:@"%i", index]];
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
    [self highlightProfileName1:sender];
}

-(IBAction)btnProfile2Clicked:(UIButton*)sender{
    [self highlightProfileName2:sender];
}

-(IBAction)btnLblProfile1Clicked:(UIButton*)sender{
    [self highlightProfileName1:sender];
}

-(IBAction)btnLblProfile2Clicked:(UIButton*)sender{
    [self highlightProfileName2:sender];
}

- (void)highlightProfileName1:(UIButton*)sender {
    UIButton *button = (UIButton*)sender;
    
    NSDictionary *value = [arrayFeed objectAtIndex:[sender tag]];
    NSArray *arrayProfile = [value objectForKey:@"profiles"];
    NSDictionary *requestedProfile = [arrayProfile objectAtIndex:0];
    
    UIView *view = button.superview; //Cell contentView
    FeedTableViewCell *cell = (FeedTableViewCell *)view.superview;
    
    NSMutableAttributedString *text =
    [[NSMutableAttributedString alloc]
     initWithString:cell.lblSaidAbout.text];
    NSString *name =  [requestedProfile objectForKey:@"name"];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor lightGrayColor]
                 range:NSMakeRange(0,name.length)];
    [cell.lblSaidAbout setAttributedText: text];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainPageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainPageViewController"];
    vc.isFriendProfile = YES;
    vc.isFromFeed = YES;
    vc.requestedID = [requestedProfile objectForKey:@"profile_id"];
    vc.colorDictionary = [AppDelegate sharedDelegate].colorDict;
    vc.profileModel = [AppDelegate sharedDelegate].profileOwner;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)highlightProfileName2:(UIButton*)sender {
    UIButton *button = (UIButton*)sender;
    UIView *view = button.superview; //Cell contentView
    FeedTableViewCell *cell = (FeedTableViewCell *)view.superview;
    [cell.lblSaidAbout2 setTextColor:[UIColor lightGrayColor]];
    [cell.lblSaidAbout2 setHighlighted:YES];
    
    NSDictionary *value = [arrayFeed objectAtIndex:[sender tag]];
    NSArray *arrayProfile = [value objectForKey:@"profiles"];
    NSDictionary *requestedProfile = [arrayProfile objectAtIndex:1];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainPageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainPageViewController"];
    vc.isFriendProfile = YES;
    vc.isFromFeed = YES;
    vc.requestedID = [requestedProfile objectForKey:@"profile_id"];
    vc.colorDictionary = [AppDelegate sharedDelegate].colorDict;
    vc.profileModel = [AppDelegate sharedDelegate].profileOwner;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)logout {
    FBSDKLoginManager *fb = [[FBSDKLoginManager alloc]init];
    [fb logOut];
    [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
}

#pragma mark LikeListDelegate

- (void) ListDismissedAfterClickProfile:(NSString*)userID {
    if (!isLikeListReleased) {
        isLikeListReleased = !isLikeListReleased;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainPageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainPageViewController"];
        vc.isFriendProfile = YES;
        vc.isFromFeed = YES;
        vc.requestedID = userID;
        vc.colorDictionary = [AppDelegate sharedDelegate].colorDict;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)dealloc {
    //[super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [_btnClear setHidden:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [_btnClear setHidden:NO];
    return YES;
}

- (void)textFieldDidChange:(UITextField*)textField {
    [textField becomeFirstResponder];
    if ([textField.text length] > 0) {
        [self.tableView setHidden:YES];
        [self.searchView setHidden:NO];
        [self requestUser:textField.text withSearchID:@""];
    }
    else {
        [textField resignFirstResponder];
        [self.searchView setHidden:YES];
        [self.tableView setHidden:NO];
    }
}

#pragma mark Keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
    } else {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
    }
    
    self.searchUserTableView.contentInset = contentInsets;
    self.searchUserTableView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.searchUserTableView.contentInset = UIEdgeInsetsZero;
    self.searchUserTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

@end
