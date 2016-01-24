//
//  NotificationTableViewCell.h
//  youSay
//
//  Created by Muliana on 18/01/2016.
//  Copyright © 2016 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *profileView;
@property (nonatomic, strong) IBOutlet UILabel *notificationDesc;
@property (nonatomic, strong) IBOutlet UILabel *notificationDate;

@end

