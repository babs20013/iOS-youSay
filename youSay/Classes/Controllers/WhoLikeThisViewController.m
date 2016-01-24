//
//  WhoLikeThisViewController.m
//  youSay
//
//  Created by Muliana on 07/01/2016.
//  Copyright © 2016 macbokpro. All rights reserved.
//

#import "WhoLikeThisViewController.h"
#import "UIImageView+Networking.h"
#import "WhoLikeListTableViewCell.h"

@interface WhoLikeThisViewController (){
    NSArray *arrLikeList;
}
@end

@implementation WhoLikeThisViewController
@synthesize say_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"WhoLikeList";
    [self.tblView setDataSource:self];
    [self.tblView setDelegate:self];
    [self requestGetLikeList];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrLikeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    static NSString *cellIdentifier = @"WhoLikeListTableViewCell";
    WhoLikeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (! cell) {
        
        cell = [[WhoLikeListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSDictionary *dict = [arrLikeList objectAtIndex:indexPath.row];
    NSString *urlString = [dict objectForKey:@"avatar"];
    [cell.profileView setImageURL:[NSURL URLWithString:urlString]];
    cell.profileView.layer.cornerRadius = cell.profileView.frame.size.width/2;
    cell.profileView.layer.masksToBounds = YES;
    cell.profileView.layer.borderWidth = 1;
    cell.profileView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;

    [cell.profileName setText:[dict objectForKey:@"profileName"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [arrLikeList objectAtIndex:indexPath.row];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate performSelector:@selector(ListDismissedAfterClickProfile:) withObject:[dict objectForKey:@"user_id"]]) {
            [self.delegate ListDismissedAfterClickProfile:[dict objectForKey:@"user_id"]];
        }
    }];
}

#pragma mark Request

- (void)requestGetLikeList {
    ShowLoader();
    
    NSMutableDictionary *dictRequest =  [[NSMutableDictionary alloc]init];
    [dictRequest setObject:REQUEST_GET_LIKE_LIST forKey:@"request"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner UserID] forKey:@"user_id"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner token] forKey:@"token"];
    [dictRequest setObject:say_id forKey:@"say_id"];
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:dictRequest completionBlock:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                arrLikeList = [dictResult objectForKey:@"profiles"];
                self.tableHeightConstraint.constant = arrLikeList.count * 50;
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

#pragma mark IBAction

- (IBAction)btnBackClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Method

- (void)logout {
    FBSDKLoginManager *fb = [[FBSDKLoginManager alloc]init];
    [fb logOut];
    [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
}


@end