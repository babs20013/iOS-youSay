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

//#define kMinVerticalGap 1
//#define kMinHorizontalGap 5
//#define kChartLabelHeight 29

#define kMinVerticalGap 2
#define kMinHorizontalGap 20
#define kChartLabelHeight 40

#define kDefaultFontArialBold @"Arial-BoldMT"
#define kDefaultFontArial @"Arial"


@interface CharmChart(){
    NSMutableArray *boxes;
    UILabel *lblScore;
}
@end
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
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger roundedScore = [self roundedScore];
    
    boxes = [NSMutableArray array];
    for (int i = 0; i<kMaximumScore; i++) {
        CGFloat barValue = ((i+1) * 10);

        UIView *valueBox = [[UIView alloc]initWithFrame:CGRectMake(kMinHorizontalGap/2,self.frame.size.height- (i*([self boxSize].height+kMinVerticalGap) + [self boxSize].height)-kChartLabelHeight, [self boxSize].width, [self boxSize].height)];
        [valueBox setBackgroundColor:kColorDefault];
        [valueBox setHidden:YES];
        valueBox.tag = i+1;
        if (( roundedScore >= 0 && roundedScore >= barValue )) {
            [valueBox setBackgroundColor:[self getColor:i+1]];
            [valueBox setHidden:NO];
        }
        valueBox.layer.cornerRadius = 0.03 * valueBox.bounds.size.width;
        valueBox.layer.masksToBounds = YES;
        [self addSubview:valueBox];
        
        if (_state == ChartStateEdit) {        }
        else if (_state == ChartStateViewing ){
            if ( _score == 0 ) {
                [valueBox setBackgroundColor:[self getColor:0]];
                [valueBox setHidden:NO];
            }
        }
        else if ( _state == ChartStateRate){
            if (_rated) {
                
            }
            else{
                _score = 0;//
                //if not rated change val to 0 so able to rate
                [valueBox setHidden:NO];
                [valueBox setBackgroundColor:[self getColor:0]];

            }
        }

        [boxes addObject:valueBox];
    }
    
    if (_state == ChartStateRate && _rated == YES) {
        CGFloat widthHeightLock = [self boxSize].height*2-3;
        CGFloat originalY = 10*([self boxSize].height+kMinVerticalGap) + [self boxSize].height-kChartLabelHeight;
        UIImageView *imgLocked = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lock"]];
        imgLocked.frame = CGRectMake((self.frame.size.width-widthHeightLock)/2,
                                     originalY+(2*[self boxSize].height-widthHeightLock)/2+2,
                                     widthHeightLock,
                                     widthHeightLock);
        [self addSubview:imgLocked];
    }
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-kChartLabelHeight+5, self.frame.size.width, kChartLabelHeight)];
    [lblTitle setText:_title];
    [lblTitle setFont:[UIFont fontWithName:kDefaultFontArial size:10]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:kChartTitleLabelColor];
    lblTitle.numberOfLines = 0;
    

    CGRect frame = lblTitle.frame;
    [lblTitle sizeToFit];
    frame.size.height = lblTitle.frame.size.height;
    lblTitle.frame = CGRectMake(0, self.frame.size.height-kChartLabelHeight+5, self.frame.size.width, lblTitle.frame.size.height);
    [self addSubview:lblTitle];
    
    float position = ceil(roundedScore/10)+1;
    if ((_state == ChartStateViewing && _score == 0 ) || (_state ==  ChartStateRate && !_rated) ){
        position = 11;
    }
    lblScore = [[UILabel alloc]initWithFrame:CGRectMake(kMinHorizontalGap/2,self.frame.size.height- (position*([self boxSize].height+kMinVerticalGap))-kChartLabelHeight, [self boxSize].width, [self boxSize].height)];
    if (_rated){
        [lblScore setText:[NSString stringWithFormat:@"%ld",(long)_score]];
    }
    else {
        [lblScore setText:_state ==  ChartStateRate ? @"0" : [NSString stringWithFormat:@"%ld",(long)_score]];
    }
    
    [lblScore setFont:[UIFont fontWithName:kDefaultFontArialBold size:13]];
    if (position > 10 && _state ==  ChartStateRate) {
        [lblScore setHidden:YES];
    }
    lblScore.textAlignment = NSTextAlignmentCenter;
    [lblScore setTextColor:kChartScoreLabelColor];
    [self addSubview:lblScore];

    UIButton *btnClose = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-([self boxSize].height+3)-4, lblScore.frame.origin.y + 6, ([self boxSize].height+3), ([self boxSize].height+3))];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"charm-close"] forState:UIControlStateNormal];
    [btnClose setImage:[UIImage imageNamed:@"charm-close"] forState:UIControlStateNormal];
    [btnClose addTarget:self
                 action:@selector(btnCloseClicked: withCharm:)
       forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnClose];
    [btnClose setHidden:YES];
    if (_state == ChartStateEdit) {
        [btnClose setHidden:NO];
    }
    
    if (_state == ChartStateRate && !_rated) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchChart:)];
        tap.delegate      =   self;
        [self addGestureRecognizer:tap];
        tap = nil;
        
        UIPanGestureRecognizer *longPress = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchAndPanChart:)];
        longPress.delegate      =   self;
        [self addGestureRecognizer:longPress];
        longPress = nil;

    }
}

-(CGSize)boxSize{
    return CGSizeMake(self.frame.size.width-kMinHorizontalGap, ((self.frame.size.width-kMinHorizontalGap)/3));
}

-(NSInteger)roundedScore{
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
    return roundedScore;
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

//-(void)changeStateOfChart{
//    for (UIView *box in boxes) {
//        [self wiggleAnimation:box];
//    }
//}
//
//-(void)wiggleAnimation:(UIView*)v{
//    if (_state == ChartStateEdit) {
//        CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-2.0));
//        CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(2.0));
//        
//        v.transform = leftWobble;  // starting point
//        
//        [UIView beginAnimations:@"wobble" context:nil];
//        [UIView setAnimationRepeatAutoreverses:YES]; // important
//        [UIView setAnimationRepeatCount:INFINITY];
//        [UIView setAnimationDuration:0.1];
//        [UIView setAnimationDelegate:self];
//        v.layer.speed = 0.1;
//
//        //    [UIView setAnimationDidStopSelector:@selector(wobbleEnded:finished:context:)];
//        
//        v.transform = rightWobble; // end here & auto-reverse
//        
//        [UIView commitAnimations];
//    }
//    else{
//        //Stop Wiggling
//        v.transform = CGAffineTransformIdentity;
//    }
//}

-(void)updateRateOnPoint:(CGPoint)point{
//    NSLog(@"Touch & Pan - %@",NSStringFromCGPoint(point));
    UIView *bottomBox = [boxes objectAtIndex:0];
    CGFloat bottomY = bottomBox.frame.origin.y + (bottomBox.frame.size.height+kMinVerticalGap);
    CGFloat perPoint = (((bottomY-((UIView*)[boxes lastObject]).frame.origin.y ) / kMaximumScore)/10);
    CGFloat increase = (bottomY - point.y)/perPoint;
//    NSLog(@"Increase: %@",[NSString stringWithFormat:@"%f",increase]);
    
    if (increase < 0) {
        self.score = 0;
    }
    else if (increase > 100){
        self.score = 100;//max
    }
    else{
        self.score = ceilf(increase);
    }
    
    NSInteger roundedScore = 0;
    if (self.score < 10) {
        roundedScore = 10;
    }
    else if (self.score%10 < 5) {
        roundedScore = self.score/10*10;
    }
    else {
        roundedScore = self.score/10*10+10;
    }
    
    float position = ceil(roundedScore/10)+1;
    if (position <= 1) {
        position = 2;
    }
    else if (position > 10){
        position= 11;//max
    }
    [lblScore setHidden:NO];
    lblScore.frame = CGRectMake(kMinHorizontalGap/2,self.frame.size.height- (position*([self boxSize].height+kMinVerticalGap))-kChartLabelHeight, [self boxSize].width, [self boxSize].height);
    [lblScore setText:[NSString stringWithFormat:@"%ld",(long)self.score]];
    
    for (UIView *box in boxes) {
        if (box.tag < position ) {
            [box setHidden:NO];
            [box setBackgroundColor:[self getColor:box.tag]];
        }else{
            [box setHidden:YES];
            [box setBackgroundColor:[self getColor:0]];
        }
    }

}
- (IBAction)btnCloseClicked:(id)sender withCharm:(NSString*)selectedCharm{
    if([self.delegate respondsToSelector:@selector(showCharmsSelection: withIndex:)]) {
        [self.delegate showCharmsSelection:_title withIndex:_index];
    }

}

- (void)onTouchAndPanChart:(UIPanGestureRecognizer*)sender {
    CGPoint touchPoint = [sender locationInView: self];
    [self updateRateOnPoint:touchPoint];
}

- (void)onTouchChart:(UITapGestureRecognizer*)sender {
    CGPoint touchPoint = [sender locationInView: self];
     [self updateRateOnPoint:touchPoint];
}

@end
