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

@interface FeedViewController ()
{

}
@end

@implementation FeedViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Request

- (void)requestAddSay {
    
    NSMutableDictionary *dictRequest =  [[NSMutableDictionary alloc]init];
    [dictRequest setObject:REQUEST_FEED forKey:@"request"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner UserID] forKey:@"user_id"];
    [dictRequest setObject:[[AppDelegate sharedDelegate].profileOwner token]  forKey:@"token"];
    [dictRequest setObject:@"" forKey:@"app_name"];
    [dictRequest setObject:@"test add say" forKey:@"text"];
    [dictRequest setObject:@"1" forKey:@"color"];
    
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:dictRequest completionBlock:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                //[dictHideSay removeAllObjects];
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
    return 100;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FeedTableViewCell";
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    UIImageView *profileFriends = [[UIImageView alloc]initWithFrame:CGRectMake(30, 20, 40, 40)];
    [profileFriends setImageURL:[NSURL URLWithString:@"http://imgs.sfgate.com/blogs/images/sfgate/sfmoms/2009/12/09/shutterstock_14501131625x416.jpg"]];
    [viewHeader addSubview:profileFriends];
    [cell addSubview:viewHeader];
    
   // [cell.lblTest setText:@"This is feed"];
    return cell;
}

@end
