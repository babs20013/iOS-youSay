//
//  UITooltip.m
//  youSay
//
//  Created by muthiafirdaus on 09/05/2016.
//  Copyright © 2016 macbokpro. All rights reserved.
//

#import "UITooltip.h"
@interface UITooltip(){
    CGRect tooltipFrame;
    CGFloat marginTop ;
    CGFloat marginLeft ;

    CGFloat buttonMarginTop ;
    CGFloat buttonMarginLeft ;

}
@end

@implementation UITooltip

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)layoutSubviews{
//    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    imgView.image = [UIImage imageNamed:self.backgroundImage];//[[UIImageView alloc]initWithImage:[UIImage imageNamed:self.backgroundImage]];
//    imgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    imgView.contentMode = UIViewContentModeScaleAspectFill;

    UIGraphicsBeginImageContext(self.frame.size);
    [[UIImage imageNamed:[self getImage]] drawInRect:self.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.backgroundColor = [UIColor colorWithPatternImage:image];

    
//    [self addSubview:imgView];
    
    UILabel *LBLTip = [[UILabel alloc]initWithFrame:CGRectMake(5+marginLeft, 5+marginTop, self.frame.size.width-10, self.frame.size.height-10)];
    [LBLTip setTextColor:[UIColor whiteColor]];
    LBLTip.numberOfLines = 0;
    LBLTip.font = [UIFont systemFontOfSize:12];
    [LBLTip setText:self.tooltipText];
    LBLTip.textAlignment = NSTextAlignmentCenter;
    
    [LBLTip sizeToFit];
    [LBLTip setFrame:CGRectMake(LBLTip.frame.origin.x, LBLTip.frame.origin.y, self.frame.size.width-10, LBLTip.frame.size.height)];
//    [LBLTip setBackgroundColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:0.5]];
    [self addSubview:LBLTip];
    
    //Ok Button
    UIButton *BTNOk = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 55+buttonMarginLeft, self.frame.size.height-25+buttonMarginTop, 50, 20)];
    [BTNOk setBackgroundColor:[UIColor whiteColor]];
    BTNOk.titleLabel.font = [UIFont systemFontOfSize:12];
    [BTNOk setTitle:@"OK" forState:UIControlStateNormal];
    BTNOk.layer.cornerRadius = 2;
    BTNOk.layer.masksToBounds = YES;
    [BTNOk setTitleColor:[UIColor colorWithRed:1.0/255.0 green:172.0/255.0 blue:197.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [BTNOk setTitleColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [BTNOk setTitleColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0] forState:UIControlStateSelected];

    [BTNOk addTarget:self action:@selector(butonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:BTNOk];
}

- (void)butonPressed:(UIButton*)button {
    if (self.onTap) {
        self.onTap();
    }
    else{
        [self removeFromSuperview];
    }
}

-(void)onButtonTap:(OnTapActionBlock)block {
    self.onTap = block;
}

-(NSString*)getImage{
    marginTop = 0;
    marginLeft = 0;
    buttonMarginTop = 0;
    buttonMarginLeft = 0;
    if (_tipArrow == TipArrowBottomLeft) {
        buttonMarginTop = -10;
        return @"ToolTip-BottomLeft";
    }
    else if (_tipArrow == TipArrowTopLeft) {
        marginTop = 10;

        return @"ToolTip-TopLeft";
    }
    else if (_tipArrow == TipArrowMiddleRight){
        marginLeft = -5;
        buttonMarginLeft = -8;
        return @"ToolTip-MidRight";
    }
    else{
        return @"";
    }
}

-(void)closeToolTip {
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }
     ];
}


-(void)showToolTip:(UIView*)view {
    [UIView animateWithDuration:1
                     animations:^{
                         self.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [view addSubview:self];
                     }
     ];
}
@end
