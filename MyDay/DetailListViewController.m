//
//  DetailListViewController.m
//  MyDay
//
//  Created by Michael Hoffman on 3/8/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import "DetailListViewController.h"
#import "ListDataStore.h"
#import "MethodsCache.h"
#import "Task+CoreDataProperties.h"
#import "DetailListViewController.h"

@interface DetailListViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property ListDataStore *store;
@property MethodsCache *method;

- (IBAction)doneTapped:(id)sender;

@end

@implementation DetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.store = [ListDataStore sharedListDataStore];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.navBar.barTintColor = [UIColor whiteColor];
    self.navBar.topItem.title = self.toDoList.listName;
    self.navBar.translucent = NO;
    
    self.method = [MethodsCache new];
    
    self.backgroundImage.image = [UIImage imageNamed:@"todo background"];
    
    self.toDoItems = [self.toDoList.item allObjects];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self.toDoList.item count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    Task *eachTask = self.toDoItems[indexPath.row];
    cell.textLabel.text = eachTask.item;
    
    //Makes each cell transparent to see background
    cell.backgroundColor = [UIColor clearColor];
    
    cell.userInteractionEnabled = YES;
    
    //Removes the selected cell's highlight color
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Makes each cell transparent to see background
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    [self.method addBottomBorderWithColor:[UIColor whiteColor] andWidth:1.0 to:cell];
    
    return cell;
    
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}
*/

- (IBAction)doneTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}















@end
