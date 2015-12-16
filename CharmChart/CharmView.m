//
//  CharmView.m
//  youSay
//
//  Created by muthiafirdaus on 16/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "CharmView.h"
#import "CharmChart.h"
@interface CharmView(){
    NSMutableArray *charts;
}
@end

@implementation CharmView

-(void)layoutSubviews{
    charts = [NSMutableArray array];
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    CGFloat w = roundf(self.frame.size.width / 5);
    CGFloat h = self.frame.size.height;
    
    for (int i=0; i<[_chartScores count]; i++) {
        CGRect chartFrame =  CGRectMake(i*w, 0, w,h);

        CharmChart *chart = [[CharmChart alloc]initWithFrame:chartFrame];
        chart.state = _state;
        chart.score = [[_chartScores objectAtIndex:i] integerValue];
        if ([_chartNames count] > i) {
            chart.title = [_chartNames objectAtIndex:i];
        }
        chart.tag = i;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapAndHoldChart:)];
        longPress.delegate      =   self;
        [chart addGestureRecognizer:longPress];
        longPress = nil;
        [charts addObject:chart];
        [self addSubview:chart];
    }
}

- (void)tapAndHoldChart:(UILongPressGestureRecognizer*)sender {
    if (_state != ChartStateEdit) {
        [self beginEditing];
    }
}

#pragma mark - Editing Methods
-(void)beginEditing{
    _state = ChartStateEdit;
    for (CharmChart *chart in charts) {
        for (UIGestureRecognizer *recognizer in chart.gestureRecognizers) {
            if([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
                [chart removeGestureRecognizer:recognizer];
            }
        }
    }
    
    if ([self.delegate performSelector:@selector(didBeginEditing:) withObject:self]) {
        [self.delegate didBeginEditing:self];
    }
}

-(void)endEditing{
    _state = ChartStateDefault;
    for (CharmChart *chart in charts) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapAndHoldChart:)];
        longPress.delegate      =   self;
        [chart addGestureRecognizer:longPress];
    }
    
    if ([self.delegate performSelector:@selector(didEndEditing:) withObject:self]) {
        [self.delegate didEndEditing:self];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}
@end
