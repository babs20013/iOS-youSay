//
//  ProfileOwnerModel.h
//  youSay
//
//  Created by Muliana on 07/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileOwnerModel : NSObject
@property (nonatomic,strong) NSString *Name;
@property (nonatomic,strong) UIImage *CoverImage;
@property (nonatomic,strong) UIImage *ProfileImage;
@property (nonatomic,assign) BOOL Selected;


@end