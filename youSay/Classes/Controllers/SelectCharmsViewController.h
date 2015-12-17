//
//  SelectCharmsViewController.h
//  youSay
//
//  Created by Muliana on 17/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCharmsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) id parent;
@property (nonatomic, strong) IBOutlet UITableView *tblView;
@property (nonatomic, strong) NSString *charmOut;
@end