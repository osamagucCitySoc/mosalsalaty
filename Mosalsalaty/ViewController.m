//
//  ViewController.m
//  Mosalsalaty
//
//  Created by Osama Rabie on 1/9/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIWebView *hiddenWebView;

@end

@implementation ViewController
{
    int repeat;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    repeat = 0;
    
    [self.hiddenWebView setAlpha:0.0];
    [self.hiddenWebView setDelegate:self];
    [self.hiddenWebView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[self.ep objectForKey:@"link"]]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *yourHTMLSourceCodeString = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    if([yourHTMLSourceCodeString rangeOfString:@"<iframe class=\"video-player\""].location != NSNotFound)
    {
        /*NSString* level1 = [[yourHTMLSourceCodeString componentsSeparatedByString:@"<iframe class=\"video-player\""] objectAtIndex:1];
        NSString* level2 = [[level1 componentsSeparatedByString:@"src=\""] objectAtIndex:1];
        NSString* level3 = [[level2 componentsSeparatedByString:@"\>"] objectAtIndex:0];*/
        
//        NSLog(@"%@",);
        repeat++;
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[[[[[[yourHTMLSourceCodeString componentsSeparatedByString:@"<iframe class=\"video-player\""] objectAtIndex:1] componentsSeparatedByString:@"src=\""] objectAtIndex:1] componentsSeparatedByString:@"\">"] objectAtIndex:0]]]];
        
        NSLog(@"Repeat : %i",repeat);
        
        
    }
}

@end
