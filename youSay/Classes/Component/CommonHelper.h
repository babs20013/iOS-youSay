//
//  CommonHelper.h
//  youSay
//
//  Created by muthiafirdaus on 10/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonHelper : NSObject
+(id)instantiateViewControllerWithIdentifier:(NSString*)identifier storyboard:(NSString*)storyboard bundle:(NSBundle*)bundle;
@end
