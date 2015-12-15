//
//  CharmChart.m
//  youSay
//
//  Created by muthiafirdaus on 14/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "CharmChart.h"

#define kColor10 [UIColor colorWithRed:241.0/255.0 green:171.0/255.0 blue:15.0/255.0 alpha:1.0]
#define kColor20 [UIColor colorWithRed:243.0/255.0 green:183.0/255.0 blue:63.0/255.0 alpha:1.0]
#define kColor30 [UIColor colorWithRed:186.0/255.0 green:227.0/255.0 blue:86.0/255.0 alpha:1.0]
#define kColor40 [UIColor colorWithRed:82.0/255.0 green:209.0/255.0 blue:131.0/255.0 alpha:1.0]
#define kColor50 [UIColor colorWithRed:108.0/255.0 green:196.0/255.0 blue:140.0/255.0 alpha:1.0]
#define kColor60 [UIColor colorWithRed:68.0/255.0 green:188.0/255.0 blue:168.0/255.0 alpha:1.0]
#define kColor70 [UIColor colorWithRed:47.0/255.0 green:181.0/255.0 blue:160.0/255.0 alpha:1.0]
#define kColor80 [UIColor colorWithRed:53.0/255.0 green:184.0/255.0 blue:202.0/255.0 alpha:1.0]
#define kColor90 [UIColor colorWithRed:31.0/255.0 green:175.0/255.0 blue:197.0/255.0 alpha:1.0]
#define kColor100 [UIColor colorWithRed:1.0/255.0 green:172.0/255.0 blue:197.0/255.0 alpha:1.0]
#define kColorDefault [UIColor colorWithRed:209.0/255.0 green:209.0/255.0 blue:209.0/255.0 alpha:1.0]
#define kChartTitleLabelColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0]
#define kChartScoreLabelColor [UIColor colorWithRed:0.0/255.0 green:172.0/255.0 blue:196.0/255.0 alpha:1.0]

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

#define kMaximumScore 10
#define kMinVerticalGap 2
#define kMinHorizontalGap 5
#define kChartLabelHeight 40

#define kDefaultFontArialBold @"Arial-BoldMT"
#define kDefaultFontArial @"Arial"

@implementation CharmChart
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _score = 0;
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];

    NSInteger roundedScore = 0;
    if (_score < 10) {
        roundedScore = 10;
    }
    else if (_score%10 < 5) {
        roundedScore = _score/10*10;
    }
    else {
        roundedScore = _score/10*10+10;
    }
    
//    NSInteger boxCount = _score > 0 ? _score : kMaximumScore;
    for (int i = 0; i<kMaximumScore; i++) {
        CGFloat barValue = ((i+1) * 10);

        UIView *valueBox = [[UIView alloc]initWithFrame:CGRectMake(kMinHorizontalGap/2,self.frame.size.height- (i*([self boxSize].height+kMinVerticalGap) + [self boxSize].height)-kChartLabelHeight, [self boxSize].width, [self boxSize].height)];
        [valueBox setBackgroundColor:kColorDefault];
        [valueBox setHidden:YES];

        if ((_state == ChartStateDefault && roundedScore >= 0 && roundedScore >= barValue )) {
            [valueBox setBackgroundColor:[self getColor:i+1]];
            [valueBox setHidden:NO];
        }
        valueBox.layer.cornerRadius = 0.03 * valueBox.bounds.size.width;
        valueBox.layer.masksToBounds = YES;
//        valueBox.layer.borderWidth = 1;
//        valueBox.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
        [self addSubview:valueBox];
    }
    
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-kChartLabelHeight, self.frame.size.width, kChartLabelHeight)];
    [lblTitle setText:_title];
    [lblTitle setFont:[UIFont fontWithName:kDefaultFontArial size:10]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:kChartTitleLabelColor];
    lblTitle.numberOfLines = 0;
    [self addSubview:lblTitle];
    
    
    
    float position = ceil(roundedScore/10)+1;
    UILabel *lblScore = [[UILabel alloc]initWithFrame:CGRectMake(kMinHorizontalGap/2,self.frame.size.height- (position*([self boxSize].height+kMinVerticalGap))-kChartLabelHeight, [self boxSize].width, [self boxSize].height)];
    [lblScore setText:[NSString stringWithFormat:@"%ld",(long)_score]];
    [lblScore setFont:[UIFont fontWithName:kDefaultFontArialBold size:20]];
    lblScore.textAlignment = NSTextAlignmentCenter;
    [lblScore setTextColor:kChartScoreLabelColor];
    [self addSubview:lblScore];
    
}

-(CGSize)boxSize{
    return CGSizeMake(self.frame.size.width-kMinHorizontalGap, (self.frame.size.width/3));
}

- (UIColor*)getColor:(NSInteger)index {
    UIColor *color;
    switch (index) {
        case 1:
            color = kColor10;
            break;
        case 2:
            color = kColor20;
            break;
        case 3:
            color = kColor30;
            break;
        case 4:
            color = kColor40;
            break;
        case 5:
            color = kColor50;
            break;
        case 6:
            color = kColor60;
            break;
        case 7:
            color = kColor70;
            break;
        case 8:
            color = kColor80;
            break;
        case 9:
            color = kColor90;
            break;
        case 10:
            color = kColor100;
            break;
        default:
            color = kColorDefault;
            break;
    }
    return color;
}

-(void)wiggleView:(UIView*)view{
    CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-2.0));
    CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(2.0));
    
    view.transform = leftWobble;  // starting point
    
    [UIView beginAnimations:@"wobble" context:nil];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:INFINITY];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(wobbleEnded:finished:context:)];
    
    view.transform = rightWobble; // end here & auto-reverse
    
    [UIView commitAnimations];
}

@end
