//
//  CommonHelper.m
//  youSay
//
//  Created by muthiafirdaus on 10/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "CommonHelper.h"

@implementation CommonHelper
+(id)instantiateViewControllerWithIdentifier:(NSString*)identifier storyboard:(NSString*)storyboard bundle:(NSBundle*)bundle{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboard bundle:bundle];
    return [sb instantiateViewControllerWithIdentifier:identifier];
}
@end
