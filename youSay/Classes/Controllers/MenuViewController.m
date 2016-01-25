//
//  MenuViewController.m
//  youSay
//
//  Created by muthiafirdaus on 10/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "MenuViewController.h"
#import "SlideNavigationController.h"
#import "ShowWebVC.h"
@interface MenuViewController ()
{
    NSArray *arrayMenu;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrayMenu = [[NSArray alloc]initWithObjects:@"Contact Us",@"Privacy Policy", @"Invite Friends", @"Logout",nil];
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
    if (indexPath.row == 0) {
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
            ShowWebVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowWebVC"];
            //initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            [vc setUrl:@"https://yousayweb.com/yousay/contact_us.php"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [nav setNavigationBarHidden:YES];
            [[SlideNavigationController sharedInstance] presentViewController:nav animated:YES completion:nil];}];
        
    }
    else if (indexPath.row == 1){
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
            ShowWebVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowWebVC"];
            //initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            [vc setUrl:@"https://yousayweb.com/yousay/privacy_policy.php"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [nav setNavigationBarHidden:YES];
            [[SlideNavigationController sharedInstance] presentViewController:nav animated:YES completion:nil];}];
    }
    else if (indexPath.row == 2) //InviteFriends
    {
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
            FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
            content.appLinkURL = [NSURL URLWithString:@"http://yousayweb.com/yousay/profileshare.html"];
            content.appInvitePreviewImageURL = [NSURL URLWithString:@"http://yousayweb.com/yousay/images/Invite_Friends.png"];
            [FBSDKAppInviteDialog showFromViewController:self.parentViewController withContent:content delegate:self];
        }];
    }
    else if (indexPath.row == 3) {
        FBSDKLoginManager *fb = [[FBSDKLoginManager alloc]init];
        [fb logOut];
        [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
    }
    
}

#pragma mark - FBInviteDelegate
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results {
    
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"YouSay" message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


@end
