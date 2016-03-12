//
//  ListDataStore.h
//  MyDay
//
//  Created by Michael Hoffman on 3/8/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface ListDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSArray *lists;
@property (strong, nonatomic) NSArray *items;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void) fetchData;
- (void) generateTestData;

+ (instancetype) sharedListDataStore;

@end
