//
//  AddNewSayViewController.m
//  youSay
//
//  Created by Muliana on 04/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "AddNewSayViewController.h"

@interface AddNewSayViewController ()
@end

@implementation AddNewSayViewController

@synthesize addSayTextView;
@synthesize textViewBG;
@synthesize profileView;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBAction

- (IBAction)btnCloseClicked:(id)sender {
    [self.view removeFromSuperview];

}

- (IBAction)btnSendClicked:(id)sender {
    NSLog(@"Sending the message");
    
}

- (IBAction)btnColorlicked:(id)sender {
    
}

#pragma mark Method

- (void)changeBackgroundColor {

}

@end