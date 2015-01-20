//
//  AboutViewController.m
//  URL Shortener
//
//  Created by Housein Jouhar on 2/18/14.
//  Copyright (c) 2014 SADAH Software Solutions. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)return;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)return;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _appIconImg.clipsToBounds = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        _appIconImg.layer.cornerRadius = 10;
    }
    else
    {
        _appIconImg.layer.cornerRadius = 14;
    }
    
    _verLabel.text = [@"الإصدار:" stringByAppendingFormat:@" %.1f",[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] floatValue]];
    
    [self setRights];
}

-(void)setRights
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"YYYY"];
    
    _rightsLabel.text = [@"  جميع الحقوق محفوظة للمطورين العرب " stringByAppendingFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
}

- (IBAction)openMore:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/tw/artist/sadah-software-solutions-llc/id460047429"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
