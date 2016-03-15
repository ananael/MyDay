//
//  RSSDetailViewController.m
//  MyDay
//
//  Created by Michael Hoffman on 3/14/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import "RSSDetailViewController.h"

@interface RSSDetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)doneTapped:(id)sender;

@end

@implementation RSSDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.toolBar.translucent = NO;
    self.toolBar.tintColor = [UIColor colorWithRed:40.0/255.0 green:69.0/255.0 blue:102.0/255.0 alpha:1.0];
    
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    
    NSURL *url = [NSURL URLWithString:[self.url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [self.webView addSubview:actInd];
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/2.0) target:self selector:@selector(loading) userInfo:nil repeats:YES];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loading
{
    if (!self.webView.loading)
    {
        [actInd stopAnimating];
        
    } else
    {
        [actInd startAnimating];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}








@end
