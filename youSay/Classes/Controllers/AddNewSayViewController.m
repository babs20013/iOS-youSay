//
//  AddNewSayViewController.m
//  youSay
//
//  Created by Muliana on 04/12/2015.
//  Copyright © 2015 macbokpro. All rights reserved.
//

#import "AddNewSayViewController.h"
#import "UIImageView+Networking.h"
#import "AppDelegate.h"
#import "AddSayRequest.h"

@interface AddNewSayViewController ()
@end

@implementation AddNewSayViewController

@synthesize addSayTextView;
@synthesize textViewBG;
@synthesize profileView;
@synthesize chooseBGView;
@synthesize colorContainer;
@synthesize profileImg;
@synthesize coverImg;
@synthesize profileLabel;
@synthesize model;
@synthesize placeholderLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    addSayTextView.delegate = self;
    [self InitializeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)InitializeUI {
    [coverImg setImageURL:[NSURL URLWithString:model.CoverImage]];
    coverImg.frame = CGRectMake(0, 0, self.view.bounds.size.width, 70);
    profileView.frame = CGRectMake(0, 43, self.view.bounds.size.width, 70);
    profileLabel.text = model.Name;
    
    UIImage *image = coverImg.image;
    // Create rectangle from middle of current image
    CGRect croprect = CGRectMake(0, (image.size.height-70)/2 ,
                                 image.size.width, 70);
    // Draw new image in current graphics context
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], croprect);
    // Create new cropped UIImage
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    coverImg.image = croppedImage;
    
    [profileImg setImageURL:[NSURL URLWithString:model.ProfileImage]];
    profileImg.layer.cornerRadius = 0.5 * profileImg.bounds.size.width;
    profileImg.layer.masksToBounds = YES;
    profileImg.layer.borderWidth = 1;
    profileImg.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
    [self.view bringSubviewToFront:_headerView];
}

#pragma mark - Request

- (void)requestAddSay {
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"Loading..."];
    UIColor *blackColor = [UIColor colorWithWhite:0.42f alpha:0.4f];
    [SVProgressHUD setBackgroundColor:blackColor];
    
    AddSayRequest *request = [[AddSayRequest alloc]init];
    request.request = REQUEST_ADD_SAY;
    request.user_id = [[AppDelegate sharedDelegate].profileOwner UserID] ;
    request.token = [[AppDelegate sharedDelegate].profileOwner token];
    request.profile_id_to_add_to = model.UserID;
    request.text = addSayTextView.text;
    request.color = 1;
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:request completionBlock:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Say" message:[dictResult valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else if (error)
        {
        }
        else{
            
        }
        [SVProgressHUD dismiss];
    }];
}


#pragma mark IBAction

- (IBAction)btnCloseClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSendClicked:(id)sender {
    NSLog(@"Sending the message");
    [self requestAddSay];
}

- (IBAction)btnColorlicked:(id)sender {
    [chooseBGView setHidden:NO];
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
        [chooseBGView bringSubviewToFront:colorContainer];
        [colorContainer addSubview:button];
        
    }
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [placeholderLabel setHidden:YES];
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}


@end