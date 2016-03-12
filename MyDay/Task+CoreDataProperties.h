//
//  Task+CoreDataProperties.h
//  
//
//  Created by Michael Hoffman on 3/8/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface Task (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *item;
@property (nullable, nonatomic, retain) List *listName;

@end

NS_ASSUME_NONNULL_END
