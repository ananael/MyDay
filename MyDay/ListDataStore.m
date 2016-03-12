//
//  ListDataStore.m
//  MyDay
//
//  Created by Michael Hoffman on 3/8/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import "ListDataStore.h"
#import "List+CoreDataProperties.h"
#import "Task+CoreDataProperties.h"

@implementation ListDataStore

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)sharedListDataStore {
    static ListDataStore *_sharedListDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedListDataStore = [[ListDataStore alloc]init];
    });
    
    return _sharedListDataStore;
}

-(void)generateTestData
{
    List *list1 = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:self.managedObjectContext];
    list1.listName = @"Grocery Store";
    
    List *list2 = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:self.managedObjectContext];
    list2.listName = @"Toiletries";
    
    List *list3 = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:self.managedObjectContext];
    list3.listName = @"Comic Books";
    
    Task *task1 = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    task1.item = @"Tomato";
    
    Task *task2 = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    task2.item = @"Talapia";
    
    Task *task3 = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    task3.item = @"Onion";
    
    Task *task4 = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    task4.item = @"Loofah";
    
    Task *task5 = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    task5.item = @"Powder";
    
    Task *task6 = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    task6.item = @"Toothpaste";
    
    Task*task7 = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    task7.item = @"Superior Spider-Man";
    
    Task *task8 = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    task8.item = @"X-Men";
    
    [list1 addItemObject:task1];
    [list1 addItemObject:task2];
    [list1 addItemObject:task3];
    
    [list2 addItemObject:task4];
    [list2 addItemObject:task5];
    [list2 addItemObject:task6];
    
    [list3 addItemObject:task7];
    [list3 addItemObject:task8];
    
    [self saveContext];
    [self fetchData];
}

-(void)fetchData
{
    NSFetchRequest *listRequest = [NSFetchRequest fetchRequestWithEntityName:@"List"];
    
    NSSortDescriptor *listSorter = [NSSortDescriptor sortDescriptorWithKey:@"listName" ascending:YES];
    listRequest.sortDescriptors = @[listSorter];
    
    self.lists = [self.managedObjectContext executeFetchRequest:listRequest error:nil];
    
    if ([self.lists count] == 0)
    {
        [self generateTestData];
    }
    
    NSFetchRequest *taskResquest = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    
    self.items = [self.managedObjectContext executeFetchRequest:taskResquest error:nil];
    
    if ([self.items count] == 0)
    {
        [self generateTestData];
    }
}


#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.self.edu.MyDay" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyDay" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MyDay.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
