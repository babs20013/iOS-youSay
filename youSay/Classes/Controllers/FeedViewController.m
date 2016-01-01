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

@interface FeedViewController ()
{
    NSArray *arrayFeed;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation FeedViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestFeed:@"1"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Request

- (void)requestFeed:(NSString*)startFrom {
    
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
            NSDictionary *dictResult = result;
            
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                arrayFeed = [dictResult objectForKey:@"items"];
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
    NSDictionary *currentSaysDict = [arrayFeed objectAtIndex:indexPath.row];
    NSString *string = [currentSaysDict valueForKey:@"feed_message"];
    CGSize expectedSize = [CommonHelper expectedSizeForString:string width:tableView.frame.size.width-65 font:[UIFont fontWithName:@"Arial" size:14] attributes:nil];
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
    
    CGFloat xAxis = 10;
    [cell.imgViewProfile1 setImageURL:[NSURL URLWithString:@"http://imgs.sfgate.com/blogs/images/sfgate/sfmoms/2009/12/09/shutterstock_14501131625x416.jpg"]];
    cell.imgViewProfile1.layer.cornerRadius = 0.5 * cell.imgViewProfile1.bounds.size.width;
    cell.imgViewProfile1.layer.masksToBounds = YES;
    cell.imgViewProfile1.layer.borderWidth = 1;
    cell.imgViewProfile1.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
    [cell.imgViewProfile2 setImageURL:[NSURL URLWithString:@"http://imgs.sfgate.com/blogs/images/sfgate/sfmoms/2009/12/09/shutterstock_14501131625x416.jpg"]];
    cell.imgViewProfile2.layer.cornerRadius = 0.5 * cell.imgViewProfile2.bounds.size.width;
    cell.imgViewProfile2.layer.masksToBounds = YES;
    cell.imgViewProfile2.layer.borderWidth = 1;
    cell.imgViewProfile2.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
    
    cell.lblSaidAbout.text = [currentSaysDict valueForKey:@"feed_title"];
    
    NSString *string = [currentSaysDict valueForKey:@"feed_message"];
    CGSize expectedSize = [CommonHelper expectedSizeForString:string width:tableView.frame.size.width-65 font:[UIFont fontWithName:@"Arial" size:14] attributes:nil];

    [cell.viewSays setFrame:CGRectMake(cell.viewSays.frame.origin.x, cell.viewSays.frame.origin.y, cell.viewSays.frame.size.width, expectedSize.height)];
    [cell.viewSays setBackgroundColor:[UIColor redColor]];
    
    [cell.lblSays setFrame:CGRectMake(cell.lblSays.frame.origin.x, cell.lblSays.frame.origin.y, cell.lblSays.frame.size.width, expectedSize.height)];
    cell.lblSays.text = string;
    cell.lblDate.text = [currentSaysDict valueForKey:@"time_ago"];
    cell.lblLikes.text = [NSString stringWithFormat:@"%@", [currentSaysDict valueForKey:@"like_count"]];
    return cell;
}

@end
