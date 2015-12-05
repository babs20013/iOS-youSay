//
//  FriendModel.h
//  youSay
//
//  Created by muliana on 05/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject
@property (nonatomic,strong) NSString *Name;
@property (nonatomic,strong) NSString *Location;
@property (nonatomic,strong) UIImage *ProfileImage;
@property (nonatomic,assign) BOOL Selected;


@end
