//
//  ProfileViewController.h
//  youSay
//
//  Created by Muliana on 07/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UITextViewDelegate>

@property (nonatomic,strong) NSDictionary * profileDictionary;
@property (nonatomic, strong) NSMutableArray * saysArray;
@end