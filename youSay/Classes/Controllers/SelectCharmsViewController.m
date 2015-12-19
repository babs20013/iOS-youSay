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
    BOOL isFiltered;
    NSMutableArray *arrayFilteredCharm;
}

@end

@implementation SelectCharmsViewController

@synthesize parent;
@synthesize charmOut;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor greenColor]];
    // Do any additional setup after loading the view.
    isFiltered = NO;
    [_searchTextField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
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

- (void)requestChangeCharm:(NSString*)charmIn {
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Loading..."];
    UIColor *blackColor = [UIColor colorWithWhite:0.42f alpha:0.4f];
    [SVProgressHUD setBackgroundColor:blackColor];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc]init];
    [dictRequest setObject:REQUEST_CHANGE_CHARM forKey:@"request"];
    [dictRequest setObject:[AppDelegate sharedDelegate].profileOwner.UserID forKey:@"user_id"];
    [dictRequest setObject:[AppDelegate sharedDelegate].profileOwner.token  forKey:@"token"];
    [dictRequest setObject:charmIn forKey:@"charm_in"]; //Name of the charms that user choose
    [dictRequest setObject:charmOut forKey:@"charm_out"]; //Name of the chamrs that user wants to change(delete)
    
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
    if (isFiltered) {
        return [arrayFilteredCharm count];
    }
    return [arrayCharms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    static NSString *SimpleTableIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: SimpleTableIdentifier];
    
    if(cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: SimpleTableIdentifier];
    }
    if (isFiltered) {
        NSDictionary *charm = [arrayFilteredCharm objectAtIndex:indexPath.row];
        cell.textLabel.text = [charm objectForKey:@"name"];
    }
    else {
        NSDictionary *charm = [arrayCharms objectAtIndex:indexPath.row];
        cell.textLabel.text = [charm objectForKey:@"name"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isFiltered) {
        NSDictionary *charm = [arrayFilteredCharm objectAtIndex:indexPath.row];
        [self requestChangeCharm:[charm objectForKey:@"name"]];
    }
    else {
        NSDictionary *charm = [arrayCharms objectAtIndex:indexPath.row];
        [self requestChangeCharm:[charm objectForKey:@"name"]];
    }
}

- (IBAction)btnCancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [parent didMoveToParentViewController:self];
    }];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidChange:(UITextField*)textField {
    if(textField.text.length == 0)
    {
        isFiltered = NO;
    }
    else
    {
        isFiltered = YES;
        arrayFilteredCharm = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dictCharm in arrayCharms)
        {
            
            NSRange nameRange = [[dictCharm objectForKey:@"name"] rangeOfString:textField.text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [arrayFilteredCharm addObject:dictCharm];
            }
        }
    }
    [self.tblView reloadData];
}

@end;