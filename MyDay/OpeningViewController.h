//
//  OpeningViewController.h
//  MyDay
//
//  Created by Michael Hoffman on 3/7/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Forecastr+CLLocation.h>
#import <CoreLocation/CoreLocation.h>

@interface OpeningViewController : UIViewController <CLLocationManagerDelegate>

@property NSMutableDictionary *resultsDict;

@end
