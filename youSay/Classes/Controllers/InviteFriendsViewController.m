//
//  InviteFriendsViewController.m
//  youSay
//
//  Created by Muliana on 05/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "UICheckBox.h"
#import "UIHelper.h"
#import "FriendModel.h"

@interface InviteFriendsViewController (){
    UITextField *txtSearchFriends;
    NSArray *arrayFriendList;
}
@end

@implementation InviteFriendsViewController
@synthesize arrFriends;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrFriends = [[NSMutableArray alloc]init];
    [self loadFriendList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initiateDisplay {
    for (int i = 0; i < arrayFriendList.count; i++) {
        NSDictionary *dictFrienDetail = [arrayFriendList objectAtIndex:i];
        FriendModel *model = [[FriendModel alloc] init];
        model.Name = [dictFrienDetail objectForKey:@"name"];
        model.Selected = NO;
        
        NSDictionary *picture = [dictFrienDetail objectForKey:@"picture"];
        NSDictionary *pictureData = [picture objectForKey:@"data"];
        NSURL *url = [NSURL URLWithString:[pictureData objectForKey:@"url"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        model.ProfileImage = [[UIImage alloc] initWithData:data];
        
        model.Location = @"Last Vegas";
        [arrFriends addObject:model];
    }
    
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
    btnCheckAll.callback = ^(BOOL checked){
        for (FriendModel*m in arrFriends) {
            m.Selected = checked;
        }
        [self.tblFriends reloadData];
    };
    
    UILabel *lblSearchAll = [[UILabel alloc]initWithFrame:CGRectMake(txtSearchFriends.frame.origin.x+txtSearchFriends.frame.size.width+10, txtSearchFriends.frame.origin.y, 30, txtSearchFriends.frame.size.height)];
    [lblSearchAll setText:@"Select All"];
    [lblSearchAll setFont:[UIFont systemFontOfSize:12]];
    [lblSearchAll sizeToFit];
    lblSearchAll.frame = CGRectMake(self.view.frame.size.width-btnCheckAll.frame.size.width-10 - lblSearchAll.frame.size.width-5, 10, lblSearchAll.frame.size.width, 35);
    [self.searchView addSubview:lblSearchAll];
    
    UIImageView *imgMagnifyingGlass = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 15, 15)];
    imgMagnifyingGlass.image = [UIImage imageNamed:@"search"];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [leftView addSubview:imgMagnifyingGlass];
    txtSearchFriends = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - lblSearchAll.frame.size.width - btnCheckAll.frame.size.width -30, 35)];
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
    
    //Footer View
    UIButton *btnInvite = [UIHelper flatButtonWithTitle:@"Invite" frame:CGRectMake(10, 0, self.view.frame.size.width-20, self.footerView.frame.size.height-10)];
    [self.footerView addSubview:btnInvite];
}

- (void)loadFriendList {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"153149751711359?fields=taggable_friends"
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        NSDictionary *dictresult = result;
        NSDictionary *taggableFriend = [dictresult objectForKey:@"taggable_friends"];
        arrayFriendList = [taggableFriend objectForKey:@"data"];
        [self initiateDisplay];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrFriends count];;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* CellId = @"CellFriend";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    
    FriendModel *model = [arrFriends objectAtIndex:indexPath.row];

    UIImageView *imgFriendPhoto = (UIImageView *)[cell viewWithTag:100];
    imgFriendPhoto.image = model.ProfileImage;
    imgFriendPhoto.layer.cornerRadius = imgFriendPhoto.frame.size.width/2;
    imgFriendPhoto.layer.masksToBounds = YES;
    imgFriendPhoto.layer.borderWidth = 1;
    imgFriendPhoto.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;

    UIView *checkView = (UIView *)[cell viewWithTag:101];
    [[checkView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];

    UICheckBox *checkBox  = [[UICheckBox alloc]initWithStateSelected:model.Selected frame:CGRectMake(0, 0, 25, 25)];
    [checkBox setTag:indexPath.row];
    [checkView addSubview:checkBox];
    [checkBox setChecked:model.Selected];
    __weak FriendModel *weakModel = model;
    
    checkBox.callback =  ^(BOOL checked){
        weakModel.Selected = checked;
    };
    
    UILabel *lblName = (UILabel *)[cell viewWithTag:102];
    [lblName setText:model.Name];
    
    UILabel *lblLocation = (UILabel *)[cell viewWithTag:103];
    [lblLocation setText:model.Location];
    
    return cell;
}


@end