//
//  DetailListViewController.h
//  MyDay
//
//  Created by Michael Hoffman on 3/8/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List+CoreDataProperties.h"

@interface DetailListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) List *toDoList;
@property (strong, nonatomic) NSArray *toDoItems;

@end
