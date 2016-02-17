//
//  PageControl.h
//
//
//  Created by Morten Heiberg on November 1, 2010.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageControlDelegate;

@interface PageControl : UIView 
{
@private
    NSInteger _currentPage;
    NSInteger _numberOfPages;
    UIColor *dotColorCurrentPage;
    UIColor *dotColorOtherPage;
    NSObject<PageControlDelegate> *delegate;
}

// Set these to control the PageControl.
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;

// Customize these as well as the backgroundColor property.
@property (nonatomic, retain) UIColor *dotColorCurrentPage;
@property (nonatomic, retain) UIColor *dotColorOtherPage;

// Optional delegate for callbacks when user taps a page dot.
@property (nonatomic, strong) NSObject<PageControlDelegate> *delegate;

@end

@protocol PageControlDelegate<NSObject>
@optional
- (void)pageControlPageDidChange:(PageControl *)pageControl;
@end
