//
//  UICheckBox.h
//  youSay
//
//  Created by muthiafirdaus on 05/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICheckBox : UIButton
@property (nonatomic,assign) BOOL checked;
-(instancetype)initWithStateSelected:(BOOL)selected frame:(CGRect)frame;
@end
