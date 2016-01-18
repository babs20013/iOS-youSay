//
//  NotificationViewController.h
//  youSay
//
//  Created by Muliana on 18/01/2016.
//  Copyright © 2016 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NotificationViewController;
@protocol NoticationDelegate <NSObject>
- (void) RouteToPageFromNotification:(NSString*)userID;
@end

@interface NotificationViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tblView;
@property (nonatomic, strong) NSString *say_id;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *profileWidthConstraint;
@property (nonatomic, weak) id <NoticationDelegate> delegate;


@end