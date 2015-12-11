//
//  MenuViewController.m
//  youSay
//
//  Created by muthiafirdaus on 10/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "MenuViewController.h"
#import "SlideNavigationController.h"
@interface MenuViewController ()
{
    NSArray *arrayMenu;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrayMenu = [[NSArray alloc]initWithObjects:@"Settings",@"Report", @"Logout", @"Invite Friends", nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableLeadingConstraint.constant =70;
    [SlideNavigationController sharedInstance].portraitSlideOffset = self.tableLeadingConstraint.constant+20;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITable View
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];

    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    [cell.textLabel setText:[arrayMenu objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        FBSDKLoginManager *fb = [[FBSDKLoginManager alloc]init];
        [fb logOut];
        [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
    }
    if (indexPath.row == 3) //InviteFriends
    {
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
            FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
            content.appLinkURL = [NSURL URLWithString:@"https://www.mydomain.com/myapplink"];
            content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];
            [FBSDKAppInviteDialog showFromViewController:self.parentViewController withContent:content delegate:self];
        }];
    }
}

#pragma mark - FBInviteDelegate
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results {
    
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error {
    
}


@end
