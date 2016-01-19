//
//  CustomActivityProvider.m
//  youSay
//
//  Created by Muliana on 19/01/2016.
//  Copyright © 2016 macbokpro. All rights reserved.
//

#import "CustomActivityProvider.h"
#import "UIImageView+Networking.h"

@interface CustomActivityProvider ()
@end

@implementation CustomActivityProvider

- (id) activityViewController:(UIActivityViewController *)activityViewController
          itemForActivityType:(NSString *)activityType
{
    if ( [activityType isEqualToString:UIActivityTypeMail] ) {
        return _imageToShare;
    }
    return nil;
}
- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController { return @""; }
@end