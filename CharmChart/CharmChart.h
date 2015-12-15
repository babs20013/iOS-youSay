//
//  CharmChart.h
//  youSay
//
//  Created by muthiafirdaus on 14/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharmChart : UIView
typedef enum {
    ChartStateDefault,
    ChartStateEdit,
    ChartStateLock,
    ChartStateViewing
} ChartState;

@property (assign,nonatomic) ChartState state;
@property (assign,nonatomic) NSInteger score;
@property (copy,nonatomic) NSString *title;

@end
