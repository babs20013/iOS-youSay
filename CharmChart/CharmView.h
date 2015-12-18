//
//  CharmView.h
//  youSay
//
//  Created by muthiafirdaus on 16/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharmChart.h"

@class CharmView;
@protocol CharmChartDelegate <NSObject>

//Edit Mode
-(void)didBeginEditing:(CharmView*)charm ;
-(void)showSelectionOfCharm:(NSString*)charmout;
@end

@interface CharmView : UIView<UIGestureRecognizerDelegate, CharmDelegate>

@property (assign,nonatomic) ChartState state;
@property (assign,nonatomic) id<CharmChartDelegate> delegate;
@property (strong,nonatomic) NSMutableArray *chartScores;
@property (strong,nonatomic) NSMutableArray *chartNames;

-(void)beginEditing;
-(void)endEditing;
@end
