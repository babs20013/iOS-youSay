//
//  CarmsTableViewCell.h
//  BLKFlexibleHeightBar Demo
//
//  Created by BDP on 10/21/15.
//  Copyright (c) 2015 Bryan Keller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarmsTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIView * charmView1;
@property (nonatomic, strong) IBOutlet UIView * charmView2;
@property (nonatomic, strong) IBOutlet UIView * charmView3;
@property (nonatomic, strong) IBOutlet UIView * charmView4;
@property (nonatomic, strong) IBOutlet UIView * charmView5;

@property (nonatomic, strong) IBOutlet UILabel * charmLabel1;
@property (nonatomic, strong) IBOutlet UILabel * charmLabel2;
@property (nonatomic, strong) IBOutlet UILabel * charmLabel3;
@property (nonatomic, strong) IBOutlet UILabel * charmLabel4;
@property (nonatomic, strong) IBOutlet UILabel * charmLabel5;

@property (nonatomic, strong) IBOutlet UILabel * charmScoreLabel1;
@property (nonatomic, strong) IBOutlet UILabel * charmScoreLabel2;
@property (nonatomic, strong) IBOutlet UILabel * charmScoreLabel3;
@property (nonatomic, strong) IBOutlet UILabel * charmScoreLabel4;
@property (nonatomic, strong) IBOutlet UILabel * charmScoreLabel5;
@end
