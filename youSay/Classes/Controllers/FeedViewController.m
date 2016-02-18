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
#import "FriendModel.h"
#import "CustomActivityProvider.h"

#define kColorSearch [UIColor colorWithRed:42.0/255.0 green:180.0/255.0 blue:202.0/255.0 alpha:1.0]


@interface FeedViewController ()
{
    NSMutableArray *arrayFeed;
    NSMutableArray *arraySearch;
    BOOL isScrollBounce;
    int index;
    BOOL isNoMoreFeed;
    BOOL isLikeListReleased;
    BOOL isRequesting;
    BOOL isShowRecentSearch;
    NSString *sayShared;
    NSString *profile;
    BOOL isSearching;
    BOOL isSearchingFB;
    BOOL isAfterShareFB;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITableView *searchUserTableView;
@property (nonatomic, weak) IBOutlet UIButton *btnClear;
@property (nonatomic, strong) IBOutlet UITextField * txtSearch;
@property (nonatomic, strong) IBOutlet UIView * searchView;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *btnViewConstraint;
@property (nonatomic, weak) IBOutlet UIButton *btnCancel;
@property (nonatomic, weak) IBOutlet UIButton *btnRightMenu;
@property (nonatomic, weak) IBOutlet UIView *viewButton;
@property (nonatomic, weak) IBOutlet UILabel *lblRecentSearch;
@property (strong, nonatomic) IQURLConnection *userSearchRequest;

@end

@implementation FeedViewController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    isScrollBounce = YES;
    [self.searchView setHidden:YES];
    [self.tableView setHidden:NO];
    [self.btnRightMenu setHidden:NO];
    [self.btnCancel setHidden:YES];
    self.btnViewConstraint.constant = 30;
    [self.viewButton needsUpdateConstraints];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([[AppDelegate sharedDelegate].profileOwner UserID]) {
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Search"];
        NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"%K like %@",@"id", [[AppDelegate sharedDelegate].profileOwner UserID]];
        [fetchRequest setPredicate:predicateID];
        
        [AppDelegate sharedDelegate].arrRecentSeacrh = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    }


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Feed";
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
    self.txtSearch.textColor = [UIColor whiteColor];
    self.txtSearch.leftViewMode = UITextFieldViewModeAlways;
    self.txtSearch.layer.cornerRadius = round(self.txtSearch.frame.size.height / 2);
    self.txtSearch.layer.borderWidth = 1;
    self.txtSearch.layer.borderColor = kColorSearch.CGColor;
    self.txtSearch.autocorrectionType = UITextAutocorrectionTypeNo;
    
    UIButton *clearTextButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
    [clearTextButton setImage:[UIImage imageNamed:@"ClearText"] forState:UIControlStateNormal];
    [clearTextButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    [clearTextButton addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
    [self.txtSearch setRightView:clearTextButton];
    [self.txtSearch setClearButtonMode:UITextFieldViewModeNever];
    [self.txtSearch setRightViewMode:UITextFieldViewModeAlways];
    
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Search" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.txtSearch.attributedPlaceholder = str;
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshFeed:)
                                                 name:@"refreshpage"
                                               object:nil];
    
    self.btnViewConstraint.constant = 30;
    [self.viewButton needsUpdateConstraints];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Request

- (void)requestFeed:(NSString*)startFrom {
    isRequesting = YES;
    ShowLoader();
    
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
        HideLoader();
        isRequesting = NO;
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
                [AppDelegate sharedDelegate].num_of_new_notifications = [[dictResult valueForKey:@"num_of_new_notifications"] integerValue];
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kNotificationUpdateNotification object:nil];
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
    isRequesting = YES;
    NSMutableDictionary *dictRequest =  [[NSMutableDictionary alloc]init];
    [dictRequest setObject:REQUEST_SEARCH_USER forKey:@"request"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner UserID] forKey:@"user_id"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner token] forKey:@"token"];
    [dictRequest setObject:searchString forKey:@"search_text"];
    [dictRequest setObject:AUTHORITY_TYPE_FB forKey:@"authority_type"];
    [dictRequest setObject:[FBSDKAccessToken currentAccessToken].tokenString forKey:@"authority_access_token"];
    [dictRequest setObject:searchID forKey:@"search_id"];
    
    
    _userSearchRequest =  [HTTPReq  postRequestWithPath:@"" class:nil object:dictRequest completionBlock:^(id result, NSError *error) {
        
        if (result)
        {
            HideLoader();
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                
                isSearchingFB = YES;
                if ([dictResult objectForKey:@"yousay_users"]) {
                    NSString *searchid = [dictResult objectForKey:@"search_id"];
                    [self requestUser:searchString withSearchID:searchid];
                    NSArray *tempArr = [dictResult objectForKey:@"yousay_users"];
                    for (int i = 0; i < tempArr.count; i++) {
                        NSDictionary *dict = [tempArr objectAtIndex:i];
                        FriendModel *model = [[FriendModel alloc]init];
                        model.Name = [dict objectForKey:@"name"];
                        model.ProfileImage = [dict objectForKey:@"image_url"];
                        model.userID = [dict objectForKey:@"user_id"];
                        model.isNeedProfile = NO;
                        if (arraySearch == nil) {
                            arraySearch = [[NSMutableArray alloc]init];
                        }
                        [arraySearch addObject:model];
                    }
                    [self.searchUserTableView reloadData];
                }
                else if ([dictResult objectForKey:@"facebook_users"]) {
                    isSearchingFB = NO;
                    isRequesting = NO;
                    NSArray *tempArr = [[dictResult objectForKey:@"facebook_users"] allObjects];
                    for (int i = 0; i < tempArr.count; i++) {
                        NSDictionary *dict = [tempArr objectAtIndex:i];
                        FriendModel *model = [[FriendModel alloc]init];
                        model.Name = [dict objectForKey:@"name"];
                        model.userID = [dict objectForKey:@"id"];
                        NSDictionary *dictPic = [[dict objectForKey:@"picture"] objectForKey:@"data"];
                        model.ProfileImage = [dictPic objectForKey:@"url"];
                        model.CoverImage = [[dict objectForKey:@"cover"] objectForKey:@"source"];
                        if (model.CoverImage == nil) {
                            model.CoverImage = DEFAULT_COVER_IMG;
                        }
                        if (model.ProfileImage == nil) {
                            model.ProfileImage = DEFAULT_PROFILE_IMG;
                        }
                        model.isNeedProfile = YES;
                        if (arraySearch == nil) {
                            arraySearch = [[NSMutableArray alloc]init];
                        }
                        //--Check if the facebook user is already a yousay user
                        
                        [arraySearch addObject:model];
                        
                    }
                    
                    if (arraySearch.count == 0) {
                        [self.lblRecentSearch setText:@"No Profiles Found"];
                    }
                    [self.searchUserTableView reloadData];
                    
                    [AppDelegate sharedDelegate].num_of_new_notifications = [[dictResult valueForKey:@"num_of_new_notifications"] integerValue];
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:kNotificationUpdateNotification object:nil];
                }
            }
            else if ([[dictResult valueForKey:@"message"] isEqualToString:@"invalid user token"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Say" message:[dictResult valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [self logout];
            }
            else if ([[dictResult valueForKey:@"rc"] integerValue] == 602) {
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
            HideLoader();
            isRequesting = NO;
        }
        else{
            HideLoader();
            isRequesting = NO;
        }
    }];
}

- (void)requestFacebookUser:(NSString*)searchString withSearchID:(NSString*)searchID {
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
    }];
}

- (void)requestGetSayImage:(NSString *)sayID withDescription:(NSString*)desc isFB:(BOOL)isFacebook{
    ShowLoader();
    
    NSMutableDictionary *dictRequest =  [[NSMutableDictionary alloc]init];
    [dictRequest setObject:REQUEST_GET_SAY_IMG forKey:@"request"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner UserID] forKey:@"user_id"];
    [dictRequest setObject:sayID forKey:@"say_id"];
    sayShared = sayID;
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:dictRequest completionBlock:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                if (isFacebook == YES) {
                    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
                    NSString *url = [NSString stringWithFormat:@"http://yousayweb.com/yousay/profileshare.html?profile=%@&sayid=%@&imageid=%@", profile, sayID, [dictResult valueForKey:@"image_id"]];
                    content.contentTitle = desc;
                    content.imageURL = [NSURL URLWithString:[dictResult objectForKey:@"url"]];
                    content.contentURL = [NSURL URLWithString:url];
                    content.contentDescription = @"Click to find out more about yourself";
                    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
                    dialog.fromViewController = self;
                    dialog.shareContent = content;
                    dialog.mode = FBSDKShareDialogModeNative;
                    if (![dialog canShow]) {
                        // fallback presentation when there is no FB app
                        dialog.mode = FBSDKShareDialogModeFeedBrowser;
                    }
                    HideLoader();
                    [dialog show];
                    dialog.delegate = self;
                }
                else {
                    UIImageView *imgView = [[UIImageView alloc]init];
                    NSString *url = [NSString stringWithFormat:@"http://yousayweb.com/yousay/profileshare.html?profile=%@&sayid=%@&imageid=%@", profile,sayID, [dictResult valueForKey:@"image_id"]];
                    ShowLoader();
                    [imgView setImageURL:[NSURL URLWithString:[dictResult objectForKey:@"url"]] withCompletionBlock:^(BOOL succes, UIImage *image, NSError *error) {
                        HideLoader();
                        CustomActivityProvider *activityProvider = [[CustomActivityProvider alloc]initWithPlaceholderItem:@""];
                        activityProvider.urlString = url;
                        NSArray *activityItems = [NSArray arrayWithObjects:image, activityProvider, desc, nil];
                        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
                        activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                        [self presentViewController:activityViewController animated:YES completion:nil];
                        
                        [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
                            if (!completed) return;
                            [self requestSayShared:sayShared];
                        }];
                        
                        
                    }];
                }
                
            }
            else if ([[dictResult valueForKey:@"message"] isEqualToString:@"invalid user token"]) {
                HideLoader();
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Say" message:[dictResult valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [self logout];
            }
            else {
                HideLoader();
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Say" message:[dictResult valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else if (error)
        {
            HideLoader();
        }
        else{
            HideLoader();
        }
    }];
}

- (void)requestSayShared:(NSString *)sharedSayID {
    ShowLoader();
    
    NSMutableDictionary *dictRequest =  [[NSMutableDictionary alloc]init];
    [dictRequest setObject:REQUEST_SAY_SHARED forKey:@"request"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner UserID] forKey:@"user_id"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner token] forKey:@"token"];
    [dictRequest setObject:sharedSayID forKey:@"shared_say_id"];
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:dictRequest completionBlock:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                NSMutableDictionary *event =
                [[GAIDictionaryBuilder createEventWithCategory:@"Action"
                                                        action:@"shareSay"
                                                         label:@"shareSay"
                                                         value:nil] build];
                [[GAI sharedInstance].defaultTracker send:event];
                [[GAI sharedInstance] dispatch];
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
        HideLoader();
    }];
}


#pragma mark UITableView

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
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
    if (tableView == self.searchUserTableView && isSearchingFB == YES) {
        return 60;
    }
    else if (tableView == self.tableView){
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:185.0/255.0 blue:187.0/255.0 alpha:1.0];
    if (tableView == self.searchUserTableView & isSearchingFB == YES) {
        MBProgressHUD *loading = [[MBProgressHUD alloc]initWithView:footerView];
        [loading setFrame:footerView.frame];
        [loading setBackgroundColor:[UIColor clearColor]];
        [loading setLabelText:@"Searching users"];
        [loading setLabelFont:[UIFont fontWithName:@"Arial" size:12]];
        [loading setAlpha:0.5];
        [footerView addSubview:loading];
//        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 30)];
//        lbl.font = [UIFont fontWithName:@"Arial" size:12];
//        lbl.textColor = [UIColor whiteColor];
//        lbl.text = @"Searching for Facebook user";
//        [footerView addSubview:lbl];
        [loading show:YES];
    }
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
    if (tableView == self.searchUserTableView && isShowRecentSearch == NO) {
        return arraySearch.count;
    }
    else if (tableView == self.searchUserTableView && isShowRecentSearch == YES) {
        if ([[AppDelegate sharedDelegate].arrRecentSeacrh count] == 0) {
            [self.btnClear setHidden:YES];
        }
        else {
            [self.btnClear setHidden:NO];
        }
        return [[AppDelegate sharedDelegate].arrRecentSeacrh count];
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
        [_userSearchRequest cancel];
        //--Add the profile to recent search
        if (![AppDelegate sharedDelegate].arrRecentSeacrh) {
            [AppDelegate sharedDelegate].arrRecentSeacrh = [[NSMutableArray alloc]init];
        }
        FriendModel *model;
        if (isShowRecentSearch == YES) {
            NSManagedObject *recentSearchClicked = [[AppDelegate sharedDelegate].arrRecentSeacrh objectAtIndex:indexPath.row];
            model = [[FriendModel alloc]init];
            model.Name = [recentSearchClicked valueForKey:@"name"];
            model.ProfileImage = [recentSearchClicked valueForKey:@"profileImage"];
            model.CoverImage = [recentSearchClicked valueForKey:@"coverImage"];
            model.userID = [recentSearchClicked valueForKey:@"userID"];
        }
        else {
            model = [arraySearch objectAtIndex:indexPath.row];
            //[self convertModelToObject:model];
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainPageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainPageViewController"];
        vc.isFriendProfile = NO;
        vc.isFromFeed = YES;
        vc.friendModel = model;
        vc.colorDictionary = [AppDelegate sharedDelegate].colorDict;
    
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
        NSURL *avatar = [NSURL URLWithString:[profile1 objectForKey:@"avatar"]];
        if  (avatar && [avatar scheme] && [avatar host]) {
            [cell.imgViewProfile1 setImageURL:avatar];
        }
        else {
            [cell.imgViewProfile1 setImageURL:[NSURL URLWithString:@"http://2.bp.blogspot.com/-6QyJDHjB5XE/Uscgo2DVBdI/AAAAAAAACS0/DFSFGLBK_fY/s1600/facebook-default-no-profile-pic.jpg"]];
        }
       
        cell.imgViewProfile1.layer.cornerRadius = 0.5 * cell.imgViewProfile1.bounds.size.width;
        cell.imgViewProfile1.layer.masksToBounds = YES;
        cell.imgViewProfile1.layer.borderWidth = 1;
        cell.imgViewProfile1.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
        NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:[[currentSaysDict valueForKey:@"feed_title"] stringByReplacingOccurrencesOfString:@"%1" withString:[profile1 objectForKey:@"name"]]];
        if (attributedText == nil){
            attributedText = [[NSAttributedString alloc]initWithString:@""];
        }
        //cell.lblSaidAbout.attributedText = attributedText;
        cell.lblSaidAbout.text = [profile1 objectForKey:@"name"];
        [cell.btnProfile1 setTag:indexPath.section];
        [cell.btnLblProfile1 setTag:indexPath.section];
        [cell.btnReport setTag:indexPath.section];
        [cell.btnShare setTag:indexPath.section];
        [cell.btnShareFB setTag:indexPath.section];
    }
    
    if (arrProfiles.count == 0) {
        [cell.lblSaidAbout setText:@""];
        [cell.lblSaidAbout2 setText:@""];
        [cell.btnReport setHidden:YES];
        [cell.btnShare setHidden:YES];
        [cell.btnShareFB setHidden:YES];
        [cell.btnLikes setHidden:YES];
        [cell.lblLikes setHidden:YES];
        [cell.imgViewProfile1 setHidden:YES];
        [cell.imgViewProfile2 setHidden:YES];
        if (string == nil) {
            [cell.viewSays setHidden:YES];
        }
    }
    
    if (arrProfiles.count == 1) {
        [cell.imgViewProfile1 setHidden:NO];
        [cell.imgViewProfile2 setHidden:YES];
        [cell.lblSaidAbout2 setHidden:YES];
        [cell.viewSays setHidden:YES];
        [cell.btnReport setHidden:YES];
        [cell.btnShare setHidden:YES];
        [cell.btnShareFB setHidden:YES];
        [cell.btnLikes setHidden:YES];
        [cell.lblLikes setHidden:YES];
        //        [cell.lblSaidAbout setFrame:CGRectMake(cell.lblSaidAbout.frame.origin.x, cell.lblSaidAbout.frame.origin.x, cell.lblSaidAbout.frame.size.width+200, cell.lblSaidAbout.frame.size.height)];
    }
    else if (arrProfiles.count == 2){
        [cell.imgViewProfile1 setHidden:NO];
        [cell.imgViewProfile2 setHidden:NO];
        [cell.lblSaidAbout2 setHidden:NO];
        [cell.viewSays setHidden:NO];
        [cell.btnReport setHidden:NO];
        [cell.btnShare setHidden:NO];
        [cell.btnShareFB setHidden:NO];
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
        
//        NSURL *avatar = [NSURL URLWithString:[profile2 objectForKey:@"avatar"]];
//        if  (avatar && [avatar scheme] && [avatar host]) {
//            [cell.imgViewProfile2 setImageURL:[NSURL URLWithString:[profile2 objectForKey:@"avatar"]]];
//        }
//        else {
//            [cell.imgViewProfile2 setImageURL:[NSURL URLWithString:@"http://2.bp.blogspot.com/-6QyJDHjB5XE/Uscgo2DVBdI/AAAAAAAACS0/DFSFGLBK_fY/s1600/facebook-default-no-profile-pic.jpg"]];
//        }
//        
//        
//        cell.imgViewProfile2.layer.cornerRadius = 0.5 * cell.imgViewProfile2.bounds.size.width;
//        cell.imgViewProfile2.layer.masksToBounds = YES;
//        cell.imgViewProfile2.layer.borderWidth = 1;
//        cell.imgViewProfile2.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
//        
        [cell.lblSaidAbout2 setText:[profile2 objectForKey:@"name"]];
        [cell.lblSaidAbout2 setNumberOfLines:0];
        if (![profile2 objectForKey:@"name"]) {
            [cell.lblSaidAbout2 setText:@""];
        }
        
        cell.lblSaidAbout.text = [cell.lblSaidAbout.text stringByReplacingOccurrencesOfString:@"%2" withString:@""];
        [cell.btnProfile2 setTag:indexPath.section];
        [cell.btnLblProfile2 setTag:indexPath.section];
    }
    NSString *key = [NSString stringWithFormat:@"%@",[currentSaysDict objectForKey:@"say_color"]];
    NSDictionary *dicColor = [AppDelegate sharedDelegate].colorDict;
    NSDictionary *indexDict = [dicColor objectForKey:key];
    
    [cell setBackgroundColor:[self colorWithHexString: [indexDict objectForKey:@"back"]]];
    
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
    FriendModel *model;
    if (isShowRecentSearch == YES) {
        [self.lblRecentSearch setText:@"Recent Search"];
        NSManagedObject *recentSearch = [[AppDelegate sharedDelegate].arrRecentSeacrh objectAtIndex:indexPath.row];
        NSURL *image = [NSURL URLWithString:[recentSearch valueForKey:@"profileImage"]];
        if (image && [image scheme] && [image host]) {
            [cell.profileView setImageURL:image];
        }
        else {
            [cell.profileView setImageURL:[NSURL URLWithString:@"http://2.bp.blogspot.com/-6QyJDHjB5XE/Uscgo2DVBdI/AAAAAAAACS0/DFSFGLBK_fY/s1600/facebook-default-no-profile-pic.jpg"]];
        }
        
        cell.profileView.layer.cornerRadius = cell.profileView.frame.size.width/2;
        cell.profileView.layer.masksToBounds = YES;
        cell.profileView.layer.borderWidth = 1;
        cell.profileView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
        
        [cell.profileName setText:[recentSearch valueForKey:@"name"]];
    }
    else {
        [self.lblRecentSearch setText:@"Profiles Found"];
        model = [arraySearch objectAtIndex:indexPath.row];
        [cell.profileView setImageURL:[NSURL URLWithString:model.ProfileImage]];
        cell.profileView.layer.cornerRadius = cell.profileView.frame.size.width/2;
        cell.profileView.layer.masksToBounds = YES;
        cell.profileView.layer.borderWidth = 1;
        cell.profileView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
        
        [cell.profileName setText:model.Name];
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
    arraySearch= [[NSMutableArray alloc]init];
    NSManagedObjectContext *context = [self managedObjectContext];
    for (int i = 0; i < [[AppDelegate sharedDelegate].arrRecentSeacrh count]; i++) {
        [context deleteObject:[[AppDelegate sharedDelegate].arrRecentSeacrh objectAtIndex:i]];
    }
    [AppDelegate sharedDelegate].arrRecentSeacrh = [[NSMutableArray alloc]init];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
    [context deletedObjects];
    
    [self.searchUserTableView reloadData];
}

- (IBAction)btnCancelSearchClicked:(id)sender {
    [self.txtSearch resignFirstResponder];
    [self.searchView setHidden:YES];
    [self.tableView setHidden:NO];
    [self.btnRightMenu setHidden:NO];
    [self.btnCancel setHidden:YES];
    self.btnViewConstraint.constant = 30;
    [self.viewButton needsUpdateConstraints];
}

- (void) refreshFeed:(NSNotification *)notif {
    arrayFeed = [[NSMutableArray alloc]init];
    index = 1;
    isNoMoreFeed = NO;
    if (isRequesting == NO) {
        [self requestFeed:[NSString stringWithFormat:@"%i", index]];
    }
}

- (void)convertModelToObject:(FriendModel*)model {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Search"
                                              inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"%K like %@", @"id", [[AppDelegate sharedDelegate].profileOwner UserID]];
    [request setPredicate:predicateID];
    
    NSError *Fetcherror;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&Fetcherror] mutableCopy];
    
    if (!mutableFetchResults) {
        // error handling code.
    }
    
    if ([[mutableFetchResults valueForKey:@"userID"]
         containsObject:model.userID]) {
        //notify duplicates
        return;
    }
    else
    {
        // Create a new managed object
        NSManagedObject *newSearch = [NSEntityDescription insertNewObjectForEntityForName:@"Search" inManagedObjectContext:context];
        
        [newSearch setValue:model.Name forKey:@"name"];
        [newSearch setValue:model.ProfileImage  forKey:@"profileImage"];
        [newSearch setValue:model.CoverImage  forKey:@"coverImage"];
        [newSearch setValue:model.userID  forKey:@"userID"];
        [newSearch setValue:[[AppDelegate sharedDelegate].profileOwner UserID]  forKey:@"id"];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        //No need to add here, we will add it inside the ProfileViewController
      //  [[AppDelegate sharedDelegate].arrRecentSeacrh addObject:newSearch];
    }
}

- (IBAction)clearTextField:(id)sender {
    [self.txtSearch setText:@""];
    isShowRecentSearch = YES;
    [self.searchUserTableView reloadData];
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

- (IBAction)btnShareSayClicked:(id)sender {
    NSLog(@"btnShare : %ld", (long)[sender tag]);
    NSDictionary *currentSaysDict = [arrayFeed objectAtIndex:[sender tag]];
    NSArray *arrProfiles = [currentSaysDict objectForKey:@"profiles"];
    NSDictionary *dictProfile1 = [arrProfiles objectAtIndex:0];
    NSDictionary *dictProfile2 = [arrProfiles objectAtIndex:1];
    NSString *desc = [NSString stringWithFormat:@"%@ Said This About %@ on Yousay", [dictProfile1 objectForKey:@"name"] , [dictProfile2 objectForKey:@"name"]];
    if ([[dictProfile2 objectForKey:@"name"] isEqualToString:[[AppDelegate sharedDelegate].profileOwner Name]]) {
        //desc = [NSString stringWithFormat:@"%@ Wrote this cool thing about me on Yousay \nClick to see who wrote about you", [dictProfile1 objectForKey:@"name"]];
        profile = [[AppDelegate sharedDelegate].profileOwner UserID];
    }
    else if ([[dictProfile1 objectForKey:@"name"] isEqualToString:[[AppDelegate sharedDelegate].profileOwner Name]]){
        //desc = [NSString stringWithFormat:@"I wrote something special about %@ on Yousay \nClick to read more and write your own", [dictProfile2 objectForKey:@"name"]];
        profile = [dictProfile2 objectForKey:@"profile_id"];
    }
    else {
        //desc = [NSString stringWithFormat:@"%@ Wrote this cool thing about %@ on Yousay \nClick to see more and write your own", [dictProfile1 objectForKey:@"name"], [dictProfile2 objectForKey:@"name"]];
        profile = [dictProfile2 objectForKey:@"profile_id"];
    }
    [self requestGetSayImage:[currentSaysDict objectForKey:@"say_id"] withDescription:desc isFB:NO];
    
}

- (IBAction)btnShareSayToFBClicked:(id)sender {
    NSLog(@"btnShare : %ld", (long)[sender tag]);
    NSDictionary *currentSaysDict = [arrayFeed objectAtIndex:[sender tag]];
    NSArray *arrProfiles = [currentSaysDict objectForKey:@"profiles"];
    NSDictionary *dictProfile1 = [arrProfiles objectAtIndex:0];
    NSDictionary *dictProfile2 = [arrProfiles objectAtIndex:1];
    NSString *desc = [NSString stringWithFormat:@"%@ wrote something special about %@ on Yousay", [dictProfile1 objectForKey:@"name"], [dictProfile2 objectForKey:@"name"]];
    if ([[dictProfile2 objectForKey:@"name"] isEqualToString:[[AppDelegate sharedDelegate].profileOwner Name]]) {
        //desc = [NSString stringWithFormat:@"%@ Wrote this cool thing about me on Yousay \nClick to see who wrote about you", [dictProfile1 objectForKey:@"name"]];
        profile = [[AppDelegate sharedDelegate].profileOwner UserID];
    }
    else if ([[dictProfile1 objectForKey:@"name"] isEqualToString:[[AppDelegate sharedDelegate].profileOwner Name]]){
       // desc = [NSString stringWithFormat:@"I wrote something special about %@ on Yousay \nClick to read more and write your own", [dictProfile2 objectForKey:@"name"]];
        profile = [dictProfile2 objectForKey:@"profile_id"];
    }
    else {
        //desc = [NSString stringWithFormat:@"%@ Wrote this cool thing about %@ on Yousay \nClick to see more and write your own", [dictProfile1 objectForKey:@"name"], [dictProfile2 objectForKey:@"name"]];
        profile = [dictProfile2 objectForKey:@"profile_id"];
    }
    [self requestGetSayImage:[currentSaysDict objectForKey:@"say_id"] withDescription:[desc uppercaseString] isFB:YES];
    
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"yousayuserid"];
    [defaults setObject:nil forKey:@"yousaytoken"];
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
    [self.tableView setHidden:YES];
    [self.searchView setHidden:NO];
    [_btnClear setHidden:YES];
    isAfterShareFB = NO;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField.text length]==0){
        [self.btnClear setHidden:NO];
        isShowRecentSearch = YES;
        [self.searchUserTableView reloadData];
    }
    [textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    arraySearch = nil;
//    if ([textField.text length]>2){
//        isShowRecentSearch = NO;
//        ShowLoader();
//        [self requestUser:textField.text withSearchID:@""];
//    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField*)textField {
    HideLoader();
    [_userSearchRequest cancel];
    [textField becomeFirstResponder];
    [self.tableView setHidden:YES];
    [self.searchView setHidden:NO];
    self.btnViewConstraint.constant = 50;
    [self.viewButton needsUpdateConstraints];
    
    [self.btnCancel setHidden:NO];
    [self.btnRightMenu setHidden:YES];
    
    if ([textField.text length]==0){
        [self.btnClear setHidden:NO];
        isShowRecentSearch = YES;
        [self.searchUserTableView reloadData];
    }
    else {
        isShowRecentSearch = NO;
        [self.btnClear setHidden:YES];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), queue, ^{
        if ([textField.text length]>2 && isRequesting == NO){
            isRequesting = YES;
            [self.btnClear setHidden:YES];
            arraySearch = nil;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                ShowLoader();
                [self requestUser:textField.text withSearchID:@""];
            }];
        }
    });
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
    
//    self.searchUserTableView.contentInset = contentInsets;
//    self.searchUserTableView.scrollIndicatorInsets = contentInsets;
    
    [self.btnClear setHidden:NO];
    [self.tableView setHidden:YES];
    [self.searchView setHidden:NO];
    self.btnViewConstraint.constant = 50;
    [self.viewButton needsUpdateConstraints];
    
    [self.btnCancel setHidden:NO];
    [self.btnRightMenu setHidden:YES];

    [self.searchUserTableView reloadData];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.searchUserTableView.contentInset = UIEdgeInsetsZero;
    self.searchUserTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
    if (isAfterShareFB == YES) {
        [self.txtSearch resignFirstResponder];
        [self.searchView setHidden:YES];
        [self.tableView setHidden:NO];
        [self.btnRightMenu setHidden:NO];
        [self.btnCancel setHidden:YES];
        self.btnViewConstraint.constant = 30;
        [self.viewButton needsUpdateConstraints];
        isAfterShareFB = NO;
    }
}

#pragma mark FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    isAfterShareFB = YES;
    [self requestSayShared:sayShared];
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    isAfterShareFB = YES;
    [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error!", nil) message:NSLocalizedString(@"There is an error while sharing! Please try Again.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil]show];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    isAfterShareFB = YES;
}
@end
