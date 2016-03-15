//
//  RSSDetailViewController.h
//  MyDay
//
//  Created by Michael Hoffman on 3/14/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSDetailViewController : UIViewController <UIWebViewDelegate> {
    
    IBOutlet UIActivityIndicatorView *actInd;
    NSTimer *timer;
    
}

@property (copy, nonatomic) NSString *url;

@end
