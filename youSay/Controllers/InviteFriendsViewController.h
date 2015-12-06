//
//  InviteFriendsViewController.h
//  youSay
//
//  Created by Muliana on 05/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) IBOutlet UITableView *tblFriends;
@property (nonatomic,strong) IBOutlet UIView *searchView;
@property (nonatomic,strong) IBOutlet UIView *footerView;
@property (nonatomic,strong) NSMutableArray *arrFriends;


@end