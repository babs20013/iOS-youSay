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
@synthesize chooseBGView;
@synthesize colorContainer;

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
    [chooseBGView setHidden:NO];
    [self.view bringSubviewToFront:chooseBGView];
    [self addColorButton];
}

- (IBAction)backgroundClicked:(id)sender {
    [chooseBGView setHidden:YES];
}

- (IBAction)selectColor:(id)sender {
    UIButton *btn = (UIButton*)sender;
    [addSayTextView setBackgroundColor:btn.backgroundColor];
}

#pragma mark Method

- (void)addColorButton {
    
    NSMutableArray *arrayColor = [[NSMutableArray alloc] init];
    UIColor *redColor = [UIColor redColor];
    UIColor *blueColor = [UIColor blueColor];
    UIColor *grayColor = [UIColor grayColor];
    UIColor *greenColor = [UIColor greenColor];
    
    UIColor *yellowColor = [UIColor yellowColor];
    UIColor *blackColor = [UIColor blackColor];
    UIColor *lightGrayColor = [UIColor lightGrayColor];
    UIColor *orangeColor = [UIColor orangeColor];
    
    UIColor *purpleColor = [UIColor purpleColor];
    UIColor *brownColor = [UIColor brownColor];
    
    [arrayColor addObject:redColor];
    [arrayColor addObject:blueColor];
    [arrayColor addObject:greenColor];
    [arrayColor addObject:grayColor];
    
    [arrayColor addObject:yellowColor];
    [arrayColor addObject:blackColor];
    [arrayColor addObject:lightGrayColor];
    [arrayColor addObject:orangeColor];
    
    [arrayColor addObject:purpleColor];
    [arrayColor addObject:brownColor];
    [arrayColor addObject:yellowColor];
    [arrayColor addObject:blackColor];
    
    [arrayColor addObject:greenColor];
    [arrayColor addObject:purpleColor];
    [arrayColor addObject:grayColor];
    [arrayColor addObject:blueColor];
    
    for (int i = 0; i < arrayColor.count; i++) {
        int x = (i%4)*60+25;
        int y = i/4*60+65;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, 50, 50);
        button.layer.cornerRadius = 0.5 * button.bounds.size.width;
        [button setBackgroundColor:[arrayColor objectAtIndex:i]];
        [button addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
        [colorContainer addSubview:button];
    }
    
    

}

@end