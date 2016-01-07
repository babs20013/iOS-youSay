//
//  WhoLikeThisViewController.h
//  youSay
//
//  Created by Muliana on 07/01/2016.
//  Copyright © 2016 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhoLikeThisViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tblView;
@property (nonatomic, strong) NSString *say_id;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;


@end