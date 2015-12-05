//
//  InviteFriendsViewController.m
//  youSay
//
//  Created by Muliana on 05/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "UICheckBox.h"
@interface InviteFriendsViewController (){
    UITextField *txtSearchFriends;
}
@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:195/255.f green:205/255.f blue:207/255.f alpha:1]];
    self.tblFriends.layer.cornerRadius = 5;
    self.tblFriends.layer.shadowOffset = CGSizeMake(0, 3);
    self.tblFriends.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tblFriends.layer.shadowRadius = 1.0; //default is 3.0
    self.tblFriends.layer.shadowOpacity = .5;
    self.tblFriends.layer.borderWidth = 1;
    self.tblFriends.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    
    
    //Search View
    
    UICheckBox *btnCheckAll = [[UICheckBox alloc]initWithStateSelected:NO frame:CGRectMake(self.view.frame.size.width - 35, 15, 25, 25)];
    
    UILabel *lblSearchAll = [[UILabel alloc]initWithFrame:CGRectMake(txtSearchFriends.frame.origin.x+txtSearchFriends.frame.size.width+10, txtSearchFriends.frame.origin.y, 30, txtSearchFriends.frame.size.height)];
    [lblSearchAll setText:@"Search All"];
    [lblSearchAll setFont:[UIFont systemFontOfSize:12]];
    [lblSearchAll sizeToFit];
    lblSearchAll.frame = CGRectMake(self.view.frame.size.width-btnCheckAll.frame.size.width-10 - lblSearchAll.frame.size.width-5, 10, lblSearchAll.frame.size.width, 35);
    [self.searchView addSubview:lblSearchAll];
    
    UIImageView *imgMagnifyingGlass = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 15, 15)];
    imgMagnifyingGlass.image = [UIImage imageNamed:@"search"];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [leftView addSubview:imgMagnifyingGlass];
    txtSearchFriends = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 200, 35)];
    [txtSearchFriends setBackgroundColor:[UIColor clearColor]];
    txtSearchFriends.font = [UIFont systemFontOfSize:12];
    txtSearchFriends.placeholder = @"Invite friends";
    txtSearchFriends.leftView = leftView;
    txtSearchFriends.leftViewMode = UITextFieldViewModeAlways;
    txtSearchFriends.layer.cornerRadius = 17.5;
    txtSearchFriends.layer.borderWidth = 1;
    txtSearchFriends.layer.borderColor = [UIColor grayColor].CGColor;
    [self.searchView addSubview:txtSearchFriends];
    
    [self.searchView addSubview:btnCheckAll];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* CellId = @"CellFriend";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    
    UIImageView *imgFriendPhoto = (UIImageView *)[cell viewWithTag:100];
    imgFriendPhoto.image = [UIImage imageNamed:@"Color"];
    imgFriendPhoto.layer.cornerRadius = imgFriendPhoto.frame.size.width/2;
    imgFriendPhoto.layer.masksToBounds = YES;
    imgFriendPhoto.layer.borderWidth = 1;
    imgFriendPhoto.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;

    UICheckBox *checkBox = (UICheckBox *)[cell viewWithTag:101];
    checkBox.selected = YES;
    return cell;
}

@end