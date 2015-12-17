//
//  SelectCharmsViewController.m
//  youSay
//
//  Created by Muliana on 17/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "SelectCharmsViewController.h"
#import "AppDelegate.h"

@interface SelectCharmsViewController ()
{
    NSArray *arrayCharms;
}

@end

@implementation SelectCharmsViewController

@synthesize parent;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor greenColor]];
    // Do any additional setup after loading the view.
    [self getAllCharms];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAllCharms {
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Loading..."];
    UIColor *blackColor = [UIColor colorWithWhite:0.42f alpha:0.4f];
    [SVProgressHUD setBackgroundColor:blackColor];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc]init];
    [dictRequest setObject:REQUEST_GET_ALL_CHARMS forKey:@"request"];
    [dictRequest setObject:[AppDelegate sharedDelegate].profileOwner.UserID forKey:@"user_id"];
    [dictRequest setObject:[AppDelegate sharedDelegate].profileOwner.token  forKey:@"token"];
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:dictRequest completionBlock:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                arrayCharms = [result objectForKey:@"charms"];
                [self.tblView reloadData];
            }
            [SVProgressHUD dismiss];
        }
        else if (error)
        {
        }
        else{
            
        }
    }];
}

- (void)requestChangeCharm {
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Loading..."];
    UIColor *blackColor = [UIColor colorWithWhite:0.42f alpha:0.4f];
    [SVProgressHUD setBackgroundColor:blackColor];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc]init];
    [dictRequest setObject:REQUEST_CHANGE_CHARM forKey:@"request"];
    [dictRequest setObject:[AppDelegate sharedDelegate].profileOwner.UserID forKey:@"user_id"];
    [dictRequest setObject:[AppDelegate sharedDelegate].profileOwner.token  forKey:@"token"];
    [dictRequest setObject:@"athletic" forKey:@"charm_in"]; //Name of the charms that user choose
    [dictRequest setObject:@"cuddly" forKey:@"charm_out"]; //Name of the chamrs that user wants to change(delete)
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:dictRequest completionBlock:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    [parent didMoveToParentViewController:parent];
                }];
            }
        }
        else if (error)
        {
        }
        else{
            
        }
        [SVProgressHUD show];
    }];
    
}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arrayCharms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    static NSString *SimpleTableIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: SimpleTableIdentifier];
    
    if(cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: SimpleTableIdentifier];
    }
    NSDictionary *charm = [arrayCharms objectAtIndex:indexPath.row];
    cell.textLabel.text = [charm objectForKey:@"name"];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self requestChangeCharm];
}

- (IBAction)btnCancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end;