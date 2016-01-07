//
//  FeedTableViewCell.h
//  youSay
//
//  Created by Muliana on 26/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UILabel *lblLikes;
@property (nonatomic, strong) IBOutlet UILabel *lblSaidAbout;
@property (nonatomic, strong) IBOutlet UILabel *lblSaidAbout2;
@property (nonatomic, strong) IBOutlet UILabel *lblSays;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewProfile1;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewProfile2;
@property (nonatomic, strong) IBOutlet UIView *viewSays;
@property (nonatomic, strong) IBOutlet UIButton *btnReport;
@property (nonatomic, strong) IBOutlet UIButton *btnShare;
@property (nonatomic, strong) IBOutlet UIButton *btnLikes;
@property (nonatomic, strong) IBOutlet UIButton *btnProfile1;
@property (nonatomic, strong) IBOutlet UIButton *btnProfile2;
@property (nonatomic, strong) IBOutlet UIButton *btnLblProfile1;
@property (nonatomic, strong) IBOutlet UIButton *btnLblProfile2;
@property (nonatomic, strong) IBOutlet UIButton *btnLikeCount;

@end

//
//UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(xAxis, 0, self.view.bounds.size.width-2*xAxis, 50)];
//UIImageView *profileFriends = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 40, 40)];
//[profileFriends setImageURL:[NSURL URLWithString:@"http://imgs.sfgate.com/blogs/images/sfgate/sfmoms/2009/12/09/shutterstock_14501131625x416.jpg"]];
//[viewHeader addSubview:profileFriends];
//
//UILabel *lblSaidAbout = [[UILabel alloc]initWithFrame:CGRectMake(45+xAxis, 20, 100, 40)];
//lblSaidAbout.text = @"said about";
//lblSaidAbout.font = [UIFont fontWithName:@"Arial" size:12];
//lblSaidAbout.textColor = [UIColor darkGrayColor];
//
//
//UIImageView *profileOwner = [[UIImageView alloc]initWithFrame:CGRectMake(150+xAxis, 20, 40, 40)];
//[profileOwner setImageURL:[NSURL URLWithString:@"http://imgs.sfgate.com/blogs/images/sfgate/sfmoms/2009/12/09/shutterstock_14501131625x416.jpg"]];
//
//[viewHeader addSubview:profileFriends];
//[viewHeader addSubview:lblSaidAbout];
//[viewHeader addSubview:profileOwner];
//[cell addSubview:viewHeader];
//
//NSDictionary *currentSaysDict = [arrayFeed objectAtIndex:indexPath.section];
//NSString *string = [currentSaysDict valueForKey:@"feed_message"];
//CGSize expectedSize = [CommonHelper expectedSizeForString:string width:tableView.frame.size.width-65 font:[UIFont fontWithName:@"Arial" size:14] attributes:nil];
//
//
//UIView *viewSay = [[UIView alloc]initWithFrame:CGRectMake(xAxis, 80, cell.frame.size.width-2*xAxis, expectedSize.height)];
//viewSay.backgroundColor = [UIColor redColor];
//UILabel *lblSay = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, viewSay.frame.size.width-20
//                                                           , expectedSize.height)];
//lblSay.text = string;
//[viewSay addSubview:lblSay];
//
//[cell addSubview:viewSay];
//
//UILabel *lblDate = [[UILabel alloc]initWithFrame:CGRectMake(xAxis, viewSay.frame.size.height + viewSay.frame.origin.y+5, 100, 30)];
//lblDate.text = [currentSaysDict valueForKey:@"time_ago"];
//lblDate.font = [UIFont fontWithName:@"Arial" size:12];
//lblDate.textColor = [UIColor darkGrayColor];
//
//[cell addSubview:lblDate];
