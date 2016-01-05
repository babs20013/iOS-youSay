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
#import "BFPaperButton.h"
#import "SlideNavigationController.h"

@interface AddNewSayViewController (){
    CGFloat textViewOriginalHeight;
    CGFloat _currentKeyboardHeight;
    UIButton *btnSelectedColor;
    NSMutableArray *arrayColorKey;
    NSInteger idColor;
    NSMutableArray *arrayColor;
}
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    _currentKeyboardHeight = 0.0f;
    self.textViewBG.layer.cornerRadius = 3;
    
    [self addColorButton];

}

-(void)viewDidAppear:(BOOL)animated{
    textViewOriginalHeight = addSayTextView.frame.size.height;
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
   // [placeholderLabel setHidden:YES];
    [addSayTextView becomeFirstResponder];
}

#pragma mark - Request

- (void)requestAddSay:(NSInteger)colorID {
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
    request.color = [[arrayColorKey objectAtIndex:colorID] integerValue];
    
    [HTTPReq  postRequestWithPath:@"" class:nil object:request completionBlock:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary *dictResult = result;
            if([[dictResult valueForKey:@"message"] isEqualToString:@"success"])
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([self.delegate performSelector:@selector(AddNewSayDidDismissed) withObject:nil]) {
                        [self.delegate AddNewSayDidDismissed];
                    }
                }];
            }
            else if ([[dictResult valueForKey:@"message"] isEqualToString:@"invalid user token"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You Say" message:[dictResult valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [self logout];
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
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate performSelector:@selector(AddNewSayDidDismissedWithCancel) withObject:nil]) {
            [self.delegate AddNewSayDidDismissedWithCancel];
        }
    }];
}

- (IBAction)btnSendClicked:(id)sender {
    NSLog(@"Sending the message");
    [self requestAddSay:[btnSelectedColor tag]];
}

- (IBAction)btnColorlicked:(id)sender {
    [chooseBGView setHidden:NO];
    [self.view endEditing:YES];
}

- (IBAction)backgroundClicked:(id)sender {
    [chooseBGView setHidden:YES];
}


- (IBAction)selectColor:(id)sender {
    
    btnSelectedColor.selected = NO;
    
    UIButton *btn = (UIButton*)sender;
    btn.selected = YES;
    btnSelectedColor = btn;
    
    [addSayTextView setBackgroundColor:btn.backgroundColor];
    NSDictionary *dict = [arrayColor objectAtIndex:btn.tag];
    [addSayTextView setTextColor:[self colorWithHexString:[dict objectForKey:@"fore"]]];
    
    
    CGFloat containerWidth = colorContainer.frame.size.width - 30;
    CGFloat gridWidth = containerWidth / 4;
    
    
    //        int x = (i%4)*60+25;
    int x = ([sender tag]%4)*gridWidth+((gridWidth-53)/2) + 15;
    int y = [sender tag]/4*60+65;
    
    
    UIView *viewButtonBackground = [[UIView alloc]initWithFrame:CGRectMake(x, y, 53, 53)];
    viewButtonBackground.layer.cornerRadius = 0.5 * viewButtonBackground.bounds.size.width;
    [viewButtonBackground setBackgroundColor:[UIColor redColor]];
    
    [colorContainer addSubview:viewButtonBackground];
    [colorContainer sendSubviewToBack:viewButtonBackground];
    
    [chooseBGView setHidden:YES];
    [viewButtonBackground setHidden:YES];
    [addSayTextView becomeFirstResponder];
   
}

#pragma mark Method

- (void)addColorButton {
    arrayColor = [[NSMutableArray alloc] init];
    arrayColorKey = [[NSMutableArray alloc]init];
    
    for (int i= 1; i <[_colorDict allKeys].count+1; i++) {
        NSString *colorIndex = [NSString stringWithFormat:@"%i",i];
        NSDictionary *indexDict = [_colorDict objectForKey:colorIndex];
        if (indexDict) {
            [arrayColorKey addObject:colorIndex];
            [arrayColor addObject:indexDict];
        }
    }
    if  (arrayColor.count < 5) {
        [colorContainer setFrame:CGRectMake(colorContainer.frame.origin.x, colorContainer.frame.origin.y, colorContainer.frame.size.width, 150)];
        self.containerHeightCosntraint.constant = 150;
    }
    else if  (arrayColor.count < 9) {
        [colorContainer setFrame:CGRectMake(colorContainer.frame.origin.x, colorContainer.frame.origin.y, colorContainer.frame.size.width, 200)];
        self.containerHeightCosntraint.constant = 200;
    }
    else if  (arrayColor.count < 13) {
        [colorContainer setFrame:CGRectMake(colorContainer.frame.origin.x, colorContainer.frame.origin.y, colorContainer.frame.size.width, 250)];
        self.containerHeightCosntraint.constant = 250;
    }
    else if  (arrayColor.count > 12) {
        [colorContainer setFrame:CGRectMake(colorContainer.frame.origin.x, colorContainer.frame.origin.y, colorContainer.frame.size.width, 300)];
        self.containerHeightCosntraint.constant = 300;
    }
    
    colorContainer.layer.cornerRadius = 0.01 * colorContainer.bounds.size.width;
    colorContainer.layer.masksToBounds = YES;
    colorContainer.layer.borderWidth = 1;
    colorContainer.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
    
    //Randomize the array
    NSUInteger count = [arrayColor count];
    for (NSUInteger i = 0; i < count; ++i) {
        int nElements = count - i;
        int n = (arc4random() % nElements) + i;
        [arrayColor exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    for (int i = 0; i < arrayColor.count; i++) {
        CGFloat containerWidth = colorContainer.frame.size.width - 30;
        CGFloat gridWidth = containerWidth / 4;

        int x = (i%4)*gridWidth+((gridWidth-50)/2) + 15;
        int y = i/4*60+65;
        
        BFPaperButton *button = [BFPaperButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, 50, 50);
        button.isRaised = NO;
        button.tag = i;
        button.layer.cornerRadius = 0.5 * button.bounds.size.width;
        [button setBackgroundColor:[self colorWithHexString: [[arrayColor objectAtIndex:i] objectForKey:@"back"]]];
        [button addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"Tick"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"Tick"] forState:UIControlStateHighlighted];
        button.imageEdgeInsets = UIEdgeInsetsMake(17, 15, 17, 15);

        button.tapCircleColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        button.cornerRadius = button.frame.size.width / 2;
        button.rippleFromTapLocation = NO;
        button.rippleBeyondBounds = YES;
        button.tapCircleBurstAmount = 0;
        button.tapCircleDiameter = MAX(button.frame.size.width, button.frame.size.height) * 1.3;
        
        [chooseBGView bringSubviewToFront:colorContainer];
        [colorContainer addSubview:button];
    }
    
    //Randomly select color
    int nElements = [arrayColor count] - 1;
    int n = (arc4random() % nElements) + 1;
    
    NSDictionary *dict = [arrayColor objectAtIndex:n];
    [addSayTextView setBackgroundColor:[self colorWithHexString:[dict objectForKey:@"back"]]];
    [addSayTextView setTextColor:[self colorWithHexString:[dict objectForKey:@"fore"]]];
    [placeholderLabel setTextColor:[self colorWithHexString:[dict objectForKey:@"fore"]]];
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    cString = [cString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (void)logout {
    FBSDKLoginManager *fb = [[FBSDKLoginManager alloc]init];
    [fb logOut];
    [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
}


#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] >0){
        [placeholderLabel setHidden:YES];
    }
    else {
        [placeholderLabel setHidden:NO];
    }
}

- (void)keyboardDidShow:(NSNotification*)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];

    _currentKeyboardHeight = keyboardFrameBeginRect.size.height;
    self.textConstraint.constant = _currentKeyboardHeight+10;
}

- (void)keyboardDidHide:(NSNotification*)notification {
    _currentKeyboardHeight = 0.0;
    self.textConstraint.constant = 10;

}


@end