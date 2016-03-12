//
//  List+CoreDataProperties.h
//  
//
//  Created by Michael Hoffman on 3/8/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "List.h"

NS_ASSUME_NONNULL_BEGIN

@interface List (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *listName;
@property (nullable, nonatomic, retain) NSSet<Task *> *item;

@end

@interface List (CoreDataGeneratedAccessors)

- (void)addItemObject:(Task *)value;
- (void)removeItemObject:(Task *)value;
- (void)addItem:(NSSet<Task *> *)values;
- (void)removeItem:(NSSet<Task *> *)values;

@end

NS_ASSUME_NONNULL_END
