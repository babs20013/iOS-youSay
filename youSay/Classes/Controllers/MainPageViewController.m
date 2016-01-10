//
//  MainPageViewController.m
//  youSay
//
//  Created by Muliana on 06/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "MainPageViewController.h"
#import "AppDelegate.h"


@interface MainPageViewController (){
    NSUInteger numberOfTabs;
    BOOL isClick;
}

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    numberOfTabs = 3;
    
    self.dataSource = self;
    self.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ViewPagerDataSource

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return numberOfTabs;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    NSArray *arrTabString = [NSArray arrayWithObjects:@"Feed", @"Profile", @"Notifications", nil];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:12.0];
    label.text = [arrTabString objectAtIndex:index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    if(index == 0){
        FeedViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedViewController"];
        if (isClick == YES) {
            isClick = NO;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"refreshpage" object:nil];
        }
        
       return cvc;
        
    }
    else if (index == 1){
        ProfileViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        cvc.colorDictionary = self.colorDictionary;
        cvc.profileDictionary = self.profileDictionary;
        cvc.isFriendProfile = _isFriendProfile;
        cvc.isFromFeed = _isFromFeed;
        cvc.friendModel = _friendModel;
        cvc.profileModel = _profileModel;
        
        if (_isFromFeed == YES && _friendModel == nil) {
            _isFromFeed = NO;
            [cvc requestProfile:_requestedID];
        }
        else if (_isFromFeed == YES && _friendModel){
            if (_friendModel.isNeedProfile == YES) {
                [cvc requestCreateProfile:_friendModel];
            }
            else {
                [cvc requestProfile:_friendModel.userID];
            }
        }
        else if (isClick == YES && _isFromFeed == NO && _requestedID == nil) {
            [cvc setIsFriendProfile:NO];
            cvc.isFromFeed = NO;
            isClick = NO;
            cvc.requestedID = nil;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"notification" object:nil];
        }
        return cvc;
    }
    else if (index == 2){
        UIViewController *vc= [[UIViewController alloc]init];
        return vc;
    }
    else {
        UIViewController *vc= [[UIViewController alloc]init];
        return vc;
    }
}


#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 1.0;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
        case ViewPagerOptionTabLocation:
            return 0.0;
        case ViewPagerOptionTabHeight:
            return 49.0;
        case ViewPagerOptionTabOffset:
            return 0.0;
        case ViewPagerOptionTabWidth:
            return self.view.frame.size.width/numberOfTabs;
        case ViewPagerOptionFixFormerTabsPositions:
            return 0.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 0.0;
        default:
            return value;
    }
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor colorWithRed:236/255.f green:157/255.f blue:18/255.f alpha:1];
        case ViewPagerTabsView:
            return [UIColor colorWithRed:0/255.f green:172/255.f blue:196/255.f alpha:1];
        case ViewPagerContent:
            return [UIColor whiteColor];
        default:
            return color;
    }
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index didSwipe:(BOOL)swipe isFromSameTab:(BOOL)tab {
    if (swipe == NO && index==1 && tab == YES) {
        _requestedID = nil;
        isClick = YES;
        _isFromFeed = NO;
        [self viewPager:viewPager contentViewControllerForTabAtIndex:index];
    }
    NSLog(@"index %i", index);
}

@end
