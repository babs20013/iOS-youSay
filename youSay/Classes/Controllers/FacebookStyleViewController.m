//
//  FacebookStyleViewController.m
//  BLKFlexibleHeightBar Demo
//
//  Created by Bryan Keller on 3/7/15.
//  Copyright (c) 2015 Bryan Keller. All rights reserved.
//

#import "FacebookStyleViewController.h"

#import "FacebookStyleBar.h"
#import "FacebookStyleBarBehaviorDefiner.h"
#import "ProfileTableViewCell.h"
#import "LongPressTableViewCell.h"
#import "PeopleSayTableViewCell.h"
#import "MessageTableViewCell.h"

#import "SquareCashStyleBar.h"
#import "SquareCashStyleBehaviorDefiner.h"
#import "BLKDelegateSplitter.h"

@interface FacebookStyleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) SquareCashStyleBar *myCustomBar;
@property (nonatomic) BLKDelegateSplitter *delegateSplitter;

@end

@implementation FacebookStyleViewController
@synthesize  profileDictionary, saysArray;
- (void)viewDidLoad
{
    saysArray = [[NSMutableArray alloc] init];
    saysArray = [profileDictionary valueForKey:@"says"];
    
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBar.hidden = YES;

    self.myCustomBar = [[SquareCashStyleBar alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), 100.0)];
    
    SquareCashStyleBehaviorDefiner *behaviorDefiner = [[SquareCashStyleBehaviorDefiner alloc] init];
    [behaviorDefiner addSnappingPositionProgress:0.0 forProgressRangeStart:0.0 end:0.5];
    [behaviorDefiner addSnappingPositionProgress:1.0 forProgressRangeStart:0.5 end:1.0];
    behaviorDefiner.snappingEnabled = YES;
    behaviorDefiner.elasticMaximumHeightAtTop = YES;
    self.myCustomBar.behaviorDefiner = behaviorDefiner;
    
    // Configure a separate UITableViewDelegate and UIScrollViewDelegate (optional)
    self.delegateSplitter = [[BLKDelegateSplitter alloc] initWithFirstDelegate:behaviorDefiner secondDelegate:self];
    self.tableView.delegate = (id<UITableViewDelegate>)self.delegateSplitter;
    
    [self.view addSubview:self.myCustomBar];
    
    // Setup the table view
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.contentInset = UIEdgeInsetsMake(self.myCustomBar.maximumBarHeight, 0.0, 0.0, 0.0);
    // Setup the bar
    
    // Add a close button to the bar
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.userInteractionEnabled = YES;
    closeButton.tintColor = [UIColor whiteColor];
    [closeButton setImage:[UIImage imageNamed:@"Close.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialCloseButtonLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] init];
    initialCloseButtonLayoutAttributes.frame = CGRectMake(self.myCustomBar.frame.size.width - 35.0, 26.5, 30.0, 30.0);
    initialCloseButtonLayoutAttributes.zIndex = 1024;
    
    [closeButton addLayoutAttributes:initialCloseButtonLayoutAttributes forProgress:0.0];
    [closeButton addLayoutAttributes:initialCloseButtonLayoutAttributes forProgress:40.0/(105.0-20.0)];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalCloseButtonLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialCloseButtonLayoutAttributes];
    finalCloseButtonLayoutAttributes.transform = CGAffineTransformMakeTranslation(0.0, -0.3*(105-20));
    finalCloseButtonLayoutAttributes.alpha = 0.0;
    
    [closeButton addLayoutAttributes:finalCloseButtonLayoutAttributes forProgress:0.8];
    [closeButton addLayoutAttributes:finalCloseButtonLayoutAttributes forProgress:1.0];
    
    [self.myCustomBar addSubview:closeButton];
    
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    UITapGestureRecognizer * tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];

}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)closeViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - UITableViewDataSource methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 4)
    return saysArray.count;
    else
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
        switch (indexPath.section) {
            case 0:
            {
                return 95;
            }
           break;
            case 1:
            {
                return 200;
            }
                break;
            case 2:
            {
                return 44;
            }
                break;
            case 3:
            {
                return 80;
            }
                break;
            case 4:
            {
                return 80;
            }
                break;
        }
     return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ProfileTableViewCell";
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(indexPath.section == 0)
    {
        static NSString *cellIdentifier = @"ProfileTableViewCell";
        ProfileTableViewCell *cel = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        cel.nameLabel.text = [profileDictionary valueForKey:@"name"];
//        cel.popularLabel.text = [NSString stringWithFormat:@"%@",[profileDictionary valueForKey:@"popularity"]];
//        cel.rankLabel.text = [NSString stringWithFormat:@"%@",[profileDictionary valueForKey:@"rank"]];
//        
//        UIImage* myImage = [UIImage imageWithData:
//                            [NSData dataWithContentsOfURL:
//                             [NSURL URLWithString: [profileDictionary valueForKey:@"picture"]]]];
//        cel.profileImageView.image = myImage;
        return cel;
    }
//    else if (indexPath.section == 1)
//    {
//        static NSString *cellIdentifier = @"CarmsTableViewCell";
//        CarmsTableViewCell *cel = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        NSArray * charmsArray = [profileDictionary valueForKey:@"charms"];
//        NSDictionary * dict = [charmsArray objectAtIndex:0];
//        cel.charmLabel1.text = [dict valueForKey:@"name"];
//        int score = [[dict valueForKey:@"rate"] integerValue];
//        score *= 100;
//        cel.charmScoreLabel1.text = [NSString stringWithFormat:@"%d",score];
//        CGRect newFrame = cel.charmView1.frame;
//        newFrame.size.height = (CGFloat)90/100*score;
//        newFrame.origin.y = 90.0 - newFrame.size.height ;
//        [cel.charmView1 setFrame:newFrame];
//        
//        dict = [charmsArray objectAtIndex:1];
//        cel.charmLabel2.text = [dict valueForKey:@"name"];
//        score = [[dict valueForKey:@"rate"] integerValue];
//        score *= 100;
//        cel.charmScoreLabel2.text = [NSString stringWithFormat:@"%d",score];
//        newFrame = cel.charmView2.frame;
//        newFrame.size.height = (CGFloat)90/100*score;
//        newFrame.origin.y = 90.0 - newFrame.size.height ;
//        [cel.charmView2 setFrame:newFrame];
//        
//        dict = [charmsArray objectAtIndex:2];
//        cel.charmLabel3.text = [dict valueForKey:@"name"];
//        score = 70;//[[dict valueForKey:@"rate"] integerValue];
//        score *= 100;
//        cel.charmScoreLabel3.text = [NSString stringWithFormat:@"%d",score];
//        newFrame = cel.charmView3.frame;
//        newFrame.size.height = (CGFloat)90/100*score;
//        newFrame.origin.y = 90.0 - newFrame.size.height ;
//        [cel.charmView3 setFrame:newFrame];
//
//        dict = [charmsArray objectAtIndex:3];
//        cel.charmLabel4.text = [dict valueForKey:@"name"];
//        score = [[dict valueForKey:@"rate"] integerValue];
//        score *= 100;
//        cel.charmScoreLabel4.text = [NSString stringWithFormat:@"%d",score];
//        newFrame = cel.charmView4.frame;
//        newFrame.size.height = (CGFloat)90/100*score;
//        newFrame.origin.y = 90.0 - newFrame.size.height ;
//        [cel.charmView4 setFrame:newFrame];
//
//         dict = [charmsArray objectAtIndex:4];
//        cel.charmLabel5.text = [dict valueForKey:@"name"];
//        score = [[dict valueForKey:@"rate"] integerValue];
//        score *= 100;
//        cel.charmScoreLabel5.text = [NSString stringWithFormat:@"%d",score];
//        newFrame = cel.charmView5.frame;
//        newFrame.size.height = (CGFloat)90/100*score;
//        newFrame.origin.y = 90.0 - newFrame.size.height ;
//        [cel.charmView5 setFrame:newFrame];
//        return cel;
//    }
    else if (indexPath.section == 2)
    {
        static NSString *cellIdentifier = @"LongPressTableViewCell";
        LongPressTableViewCell *cel = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cel == nil) {
        }
        return cel;
    }
    else if (indexPath.section == 3)
    {
        static NSString *cellIdentifier = @"PeopleSayTableViewCell";
        PeopleSayTableViewCell *cel = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cel.peopleSayLabel.text = [NSString stringWithFormat:@"What people said about %@:",[profileDictionary valueForKey:@"name"]];
        return cel;
    }
    else if (indexPath.section == 4)
    {
        static NSString *cellIdentifier = @"MessageTableViewCell";
        MessageTableViewCell *cel = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSDictionary * dict = [saysArray objectAtIndex:indexPath.row];
        cel.userNameLabel.text = [dict valueForKey:@"by"];
        cel.messageLabel.text = [NSString stringWithFormat:@"said: %@",[dict valueForKey:@"text"]];
        cel.likeCountLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"like_count"]];
        [cel.hideButton addTarget:self action:@selector(hideButtonClicked:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [cel.UNDOButton addTarget:self action:@selector(undoButtonClicked:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        return cel;
    }

    return cell;
}


- (void)hideButtonClicked:(UIButton *)sender  withEvent: (UIEvent *) event
{
     MessageTableViewCell *cell = (MessageTableViewCell*)sender.superview.superview; //Since you are adding to cell.contentView, navigate two levels to get cell object
    cell.UNDOView.hidden = false;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSLog(@"did select : %ld",(long)indexPath.row);
}

- (void)undoButtonClicked:(UIButton *)sender  withEvent: (UIEvent *) event
{
    MessageTableViewCell *cell = (MessageTableViewCell*)sender.superview.superview.superview; //Since you are adding to cell.contentView, navigate two levels to get cell object
    cell.UNDOView.hidden = true;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSLog(@"did select : %ld",(long)indexPath.row);
}

@end
