//
//  UICheckBox.m
//  youSay
//
//  Created by muthiafirdaus on 05/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "UICheckBox.h"
@interface UICheckBox(){
    UIImageView *imageState;
}
@end

@implementation UICheckBox

- (instancetype)init
{
    return [self initWithStateSelected:NO frame:CGRectMake(0, 0, 25, 25)];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithStateSelected:(BOOL)selected frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.selected = selected;
        [self setup];
    }
    return self;
}
-(void)setup{
    [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    [self addTarget:self action:@selector(onTouch) forControlEvents:UIControlEventTouchUpInside];

    imageState = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self addSubview:imageState];
}
-(void)layoutSubviews{
    [self updateUI];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, imageState.frame.size.width, self.frame.size.height);
}

-(void)updateState{
    self.selected = !self.selected;
    [self updateUI];
}
-(void)updateUI{
    
    if (self.selected) {
        imageState.image = [UIImage imageNamed:@"checked"];
    }
    else{
        imageState.image = [UIImage imageNamed:@"unchecked"];
    }
}
-(void)onTouch{
    [self updateState];
}


-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    if ([keyPath isEqualToString:@"selected"])
    {
        [self updateUI];
    }
    else
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
}


@end
