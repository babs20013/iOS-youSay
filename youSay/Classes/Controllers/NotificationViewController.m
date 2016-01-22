//
//  NotificationViewController.m
//  youSay
//
//  Created by Muliana on 18/01/2016.
//  Copyright © 2016 macbokpro. All rights reserved.
//

#import "NotificationViewController.h"
#import "UIImageView+Networking.h"
#import "NotificationTableViewCell.h"
#import "CommonHelper.h"
#import "MainPageViewController.h"

@interface NotificationViewController (){
    NSArray *arrNotification;
}
@end

@implementation NotificationViewController
@synthesize say_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Notification";
    [self requestGetNotification:@"1"];
    self.tblView.layer.cornerRadius = 0.015 * self.tblView.bounds.size.width;
    self.tblView.layer.masksToBounds = YES;
    self.tblView.layer.borderWidth = 1;
    self.tblView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView

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
    NSDictionary *dict = [arrNotification objectAtIndex:indexPath.row];
    
    NSArray *arrProfile = [dict objectForKey:@"profiles"];
    NSDictionary *dictProfile;
    if (arrProfile.count > 0) {
        dictProfile = [arrProfile objectAtIndex:0];
    }
    
    NSString *string = [[NSString alloc]initWithString:[[dict objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"%1" withString:[dictProfile objectForKey:@"name"]]];
    CGSize expectedSize = [CommonHelper expectedSizeForString:string width:tableView.frame.size.width-40 font:[UIFont fontWithName:@"Arial" size:12] attributes:nil];
    return expectedSize.height+30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrNotification count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    static NSString *cellIdentifier = @"NotificationTableViewCell";
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (! cell) {
        
        cell = [[NotificationTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSDictionary *dict = [arrNotification objectAtIndex:indexPath.row];
    
    NSArray *arrProfile = [dict objectForKey:@"profiles"];
    NSDictionary *dictProfile;
    if (arrProfile.count > 0) {
        dictProfile = [arrProfile objectAtIndex:0];
    }
    
    NSString *string = [[NSString alloc]initWithString:[[dict objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"%1" withString:[dictProfile objectForKey:@"name"]]];
    if (string == nil){
        string = @"";
    }
    NSString *urlString = [dict objectForKey:@"avatar"];
    [cell.profileView setImageURL:[NSURL URLWithString:urlString]];
    cell.profileView.layer.cornerRadius = cell.profileView.frame.size.width/2;
    cell.profileView.layer.masksToBounds = YES;
    cell.profileView.layer.borderWidth = 1;
    cell.profileView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
    
    cell.notificationDesc.text = string;
    [cell.notificationDesc setFont:[UIFont fontWithName:@"Arial" size:12]];
    [cell.notificationDesc setTextColor:[UIColor darkGrayColor]];
    [cell.notificationDesc setNumberOfLines:0];
    
    cell.notificationDate.text = [dict objectForKey:@"time_ago"];
    [cell.notificationDate setFont:[UIFont fontWithName:@"Arial" size:10]];
    [cell.notificationDate setTextColor:[UIColor lightGrayColor]];
    
    CGSize expectedSize = [CommonHelper expectedSizeForString:string width:tableView.frame.size.width-40 font:[UIFont fontWithName:@"Arial" size:12] attributes:nil];
    
    if (urlString.length == 0){
        cell.notificationDesc.frame = CGRectMake(13, 8, expectedSize.width+400, expectedSize.height);
        [cell.profileView setHidden:YES];
        if (expectedSize.width < tableView.frame.size.width-40) {
            cell.notificationDesc.text = [NSString stringWithFormat:@"%@                                                                                         ",string];
        }
    }
    else {
        [cell.profileView setHidden:NO];
    }    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [arrNotification objectAtIndex:indexPath.row];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainPageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainPageViewController"];
    vc.isFromFeed = YES;
    vc.requestedID = [[AppDelegate sharedDelegate].profileOwner UserID];//[dictProfile objectForKey:@"profile_id"];
    vc.sayID = [dict objectForKey:@"say_id"];
    //vc.numOfNotification = 30;
    vc.colorDictionary = [AppDelegate sharedDelegate].colorDict;
    vc.profileModel = [AppDelegate sharedDelegate].profileOwner;
    [self.navigationController pushViewController:vc animated:YES];
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        if ([self.delegate performSelector:@selector(RouteToPageFromNotification:) withObject:[dict objectForKey:@"user_id"]]) {
//            [self.delegate RouteToPageFromNotification:[dict objectForKey:@"user_id"]];
//        }
//    }];
}

#pragma mark Request

- (void)requestGetNotification:(NSString*)startFrom  {
    ShowLoader();
    
    NSMutableDictionary *dictRequest =  [[NSMutableDictionary alloc]init];
    [dictRequest setObject:REQUEST_GET_NOTIFICATION forKey:@"request"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner UserID] forKey:@"user_id"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner token] forKey:@"token"];
    [dictRequest setObject:@"yousay_ios" forKey:@"app_name"];
    [dictRequest setObject:@"1.0" forKey:@"app_version"];
    [dictRequest setObject:@"10" forKey:@"max_items"];
    [dictRequest setObject:startFrom forKey:@"start_from"];
    [dictRequest setObject:@"1" forKey:@"sort"];
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:dictRequest completionBlock:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                arrNotification = [dictResult objectForKey:@"items"];
                self.tableHeightConstraint.constant = arrNotification.count * 50;
                [self.tblView needsUpdateConstraints];
                [self.tblView reloadData];
                
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
                [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark Method

- (void)logout {
    FBSDKLoginManager *fb = [[FBSDKLoginManager alloc]init];
    [fb logOut];
    [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
}


@end