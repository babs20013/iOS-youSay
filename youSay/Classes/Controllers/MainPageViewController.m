//
//  MainPageViewController.m
//  youSay
//
//  Created by Muliana on 06/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "MainPageViewController.h"
#import "ProfileViewController.h"
@interface MainPageViewController (){
    NSUInteger numberOfTabs;
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
    
    if(index == 0 || index == 2){
        InviteFriendsViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteFriendsViewController"];
        return cvc;
//        UIViewController *vc= [[UIViewController alloc]init];
//        return vc;
    }
    else{
        ProfileViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        
        cvc.profileDictionary = self.profileDictionary;
        cvc.colorDictionary = self.colorDictionary;
        return cvc;
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

@end
