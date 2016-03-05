//
//  WeatherListViewController.h
//  MyDay
//
//  Created by Michael Hoffman on 3/3/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property NSMutableDictionary *resultsDict;

@end
