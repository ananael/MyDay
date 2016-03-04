//
//  ViewController.h
//  MyDay
//
//  Created by Michael Hoffman on 2/26/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Forecastr+CLLocation.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property NSMutableDictionary *resultsDict;


@end

