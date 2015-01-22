//
//  ViewController.m
//  Mosalsalaty
//
//  Created by Osama Rabie on 1/9/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *hiddenWebView;

@end

@implementation ViewController
{
    int repeat;
    UIWebView* webView;
    __weak IBOutlet UIActivityIndicatorView *activity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    repeat = 0;
    webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webView];
    [webView setDelegate:self];
    [self.view bringSubviewToFront:activity];
    [activity startAnimating];
    
    [self.hiddenWebView setAlpha:0.0];
    [self.hiddenWebView setDelegate:self];
    [self.hiddenWebView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[self.ep objectForKey:@"link"]]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webVieww
{
    [activity stopAnimating];
    NSString *yourHTMLSourceCodeString = [webVieww stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    if(webVieww == self.hiddenWebView && [yourHTMLSourceCodeString rangeOfString:@"<iframe class=\"video-player\""].location != NSNotFound)
    {
        repeat++;
        
        [activity startAnimating];
        [webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[[[[[[yourHTMLSourceCodeString componentsSeparatedByString:@"<iframe class=\"video-player\""] objectAtIndex:1] componentsSeparatedByString:@"src=\""] objectAtIndex:1] componentsSeparatedByString:@"\">"] objectAtIndex:0]]]];
        
        NSLog(@"Repeat : %i",repeat);
        
        
    }
}

@end
