//
//  WhoLikeThisViewController.h
//  youSay
//
//  Created by Muliana on 07/01/2016.
//  Copyright © 2016 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WhoLikeThisViewController;
@protocol LikeListDelegate <NSObject>
- (void) ListDismissedAfterClickProfile:(NSString*)userID;
@end

@interface WhoLikeThisViewController : GAITrackedViewController  <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tblView;
@property (nonatomic, strong) NSString *say_id;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@property (nonatomic, weak) id <LikeListDelegate> delegate;


@end