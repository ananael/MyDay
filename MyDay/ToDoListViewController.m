//
//  ToDoListViewController.m
//  MyDay
//
//  Created by Michael Hoffman on 3/8/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import "ToDoListViewController.h"
#import "ListDataStore.h"
#import "List+CoreDataProperties.h"
#import "DetailListViewController.h"
#import "WeatherListViewController.h"

@interface ToDoListViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *buttonContainer;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *forecastButton;
@property (weak, nonatomic) IBOutlet UIButton *rssButton;

@property (strong, nonatomic) ListDataStore *store;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (IBAction)homeTapped:(id)sender;
- (IBAction)forecastTapped:(id)sender;
- (IBAction)rssTapped:(id)sender;


@end

@implementation ToDoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.store = [ListDataStore sharedListDataStore];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navBar.barTintColor = [UIColor whiteColor];
    self.navBar.topItem.title = @"To-Do Lists";
    self.navBar.translucent = NO;
    
    self.forecastButton.hidden = YES;
    
    //Creates fetch request
    NSFetchRequest *listFetch = [NSFetchRequest fetchRequestWithEntityName:@"List"];
    
    NSSortDescriptor *listSorter = [NSSortDescriptor sortDescriptorWithKey:@"listName" ascending:YES];
    listFetch.sortDescriptors = @[listSorter];
    
    //Initializes FetchedResultsController
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:listFetch managedObjectContext:self.store.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    //Assign the Fetched Delegate
    //Must be coded in this sequence
    self.fetchedResultsController.delegate = self;
    
    //Perform fetch
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error)
    {
        NSLog(@"Unable to perform fetch");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    
    
    
    
}

// *****  MUST REMEMBER  *****
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return [[self.fetchedResultsController sections]count]; //Or just use "1" in this case
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self.fetchedResultsController.fetchedObjects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todoCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    List *eachList = self.fetchedResultsController.fetchedObjects[indexPath.row];
    cell.textLabel.text = eachList.listName;
    
    //Makes each cell transparent to see background
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

#pragma mark - NSFetchedResultsControllerDelegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            NSLog(@"A list was moved");
            break;
            
        case NSFetchedResultsChangeUpdate:
            NSLog(@"A list was updated");
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        
        NSManagedObject *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        //This deletes from FetchedResultsController
        if (record)
        {
            [self.fetchedResultsController.managedObjectContext deleteObject:record];
        }
        
        //This deletes from Core Data
        [self.store.managedObjectContext deleteObject:record];
        [self.store.managedObjectContext save:nil];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"detailSegue"])
    {
        DetailListViewController *detailListVC = segue.destinationViewController;
        NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
        
        detailListVC.toDoList = self.fetchedResultsController.fetchedObjects[selectedPath.row];
        
    }
 
}

- (IBAction)homeTapped:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (IBAction)forecastTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rssTapped:(id)sender
{
    
}


















@end
