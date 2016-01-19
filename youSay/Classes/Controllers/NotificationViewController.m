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

@interface NotificationViewController (){
    NSArray *arrNotification;
}
@end

@implementation NotificationViewController
@synthesize say_id;

- (void)viewDidLoad {
    [super viewDidLoad];
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

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Remove seperator inset
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    // Prevent the cell from inheriting the Table View's margin settings
//    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
//    
//    // Explictly set your cell's layout margins
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrNotification count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    static NSString *cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (! cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
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
    UIImageView *profileView = [[UIImageView alloc]init];
    [profileView setImageURL:[NSURL URLWithString:urlString]];
    profileView.layer.cornerRadius = profileView.frame.size.width/2;
    profileView.layer.masksToBounds = YES;
    profileView.layer.borderWidth = 1;
    profileView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
    
    UILabel *lblNotifDesc = [[UILabel alloc]init];
    lblNotifDesc.text = string;
    [lblNotifDesc setFont:[UIFont fontWithName:@"Arial" size:12]];
    [lblNotifDesc setTextColor:[UIColor darkGrayColor]];
    [lblNotifDesc setNumberOfLines:0];
    
    UILabel *lblDate = [[UILabel alloc]init];
    lblDate.text = [dict objectForKey:@"time_ago"];
    [lblDate setFont:[UIFont fontWithName:@"Arial" size:10]];
    [lblDate setTextColor:[UIColor lightGrayColor]];
    
    CGSize expectedSize = [CommonHelper expectedSizeForString:string width:tableView.frame.size.width-40 font:[UIFont fontWithName:@"Arial" size:12] attributes:nil];
    
    if (urlString.length == 0){
        lblNotifDesc.frame = CGRectMake(13, 8, expectedSize.width, expectedSize.height);
        lblDate.frame = CGRectMake(13, expectedSize.height+8, 300, 15);
        [cell addSubview:lblNotifDesc];
        [cell addSubview:lblDate];
    }
    else {
        profileView.frame = CGRectMake(13, 8, 45, 45);
        lblNotifDesc.frame = CGRectMake(66, 8, expectedSize.width, expectedSize.height);
        lblDate.frame = CGRectMake(66, expectedSize.height+8, 300, 15);
        [cell addSubview:profileView];
        [cell addSubview:lblNotifDesc];
        [cell addSubview:lblDate];
    }

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 69, tableView.frame.size.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [cell addSubview:line];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [arrNotification objectAtIndex:indexPath.row];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate performSelector:@selector(RouteToPageFromNotification:) withObject:[dict objectForKey:@"user_id"]]) {
            [self.delegate RouteToPageFromNotification:[dict objectForKey:@"user_id"]];
        }
    }];
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