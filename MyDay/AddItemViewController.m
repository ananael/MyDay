//
//  AddItemViewController.m
//  MyDay
//
//  Created by Michael Hoffman on 3/8/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import "AddItemViewController.h"
#import "ListDataStore.h"
#import "List+CoreDataProperties.h"
#import "Task+CoreDataProperties.h"

@interface AddItemViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIView *scrollContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContent;

@property ListDataStore *store;

@property (strong, nonatomic) NSMutableArray *textboxArray;
@property (strong, nonatomic) NSMutableArray *addItemsArray;

- (IBAction)cancelTapped:(id)sender;
- (IBAction)saveTapped:(id)sender;

@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.store = [ListDataStore sharedListDataStore];
    
    self.navBar.barTintColor = [UIColor whiteColor];
    self.navBar.topItem.title = @"New List";
    self.navBar.translucent = NO;
    
    //Respond to UITextField Delegates
    self.titleField.delegate = self;
    //Dismisses the keyboard when the <Return> key is tapped
    [self textFieldShouldReturn:self.titleField];
    
    self.textboxArray = [NSMutableArray new];
    self.addItemsArray = [NSMutableArray new];
    
    //Generates textfields boxes (in this case 50 fields ... )
    for (NSInteger counter = 0; counter < 2200; counter = counter+44)
    {
        UITextField *textbox = [[UITextField alloc]initWithFrame:CGRectMake(10, counter, self.view.frame.size.width-20, 44)];
        textbox.placeholder = @"add item";
        textbox.backgroundColor = [UIColor clearColor];
        
        //Creates a bottom border for each textField generated
        CGFloat borderWidth = 1;
        CALayer *border = [CALayer layer];
        border.borderColor = [UIColor blackColor].CGColor;
        border.frame = CGRectMake(0, textbox.frame.size.height - borderWidth, textbox.frame.size.width, textbox.frame.size.height);
        border.borderWidth = borderWidth;
        [textbox.layer addSublayer:border];
        //textbox.layer.masksToBounds = YES;
        
        //Allows each textbox to respond to UITextField Delegates
        textbox.delegate = self;
        
        textbox.clearButtonMode = UITextFieldViewModeAlways;
        
        //Dismisses the keyboard when the <Return> key is tapped
        [self textFieldShouldReturn:textbox];
        
        [self.textboxArray addObject:textbox];
        
        [self.scrollContent addSubview:textbox];
        
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Method for dismissing the keyboard when the <Return> key is tapped
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)cancelTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveTapped:(id)sender
{
    List *newList = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:self.store.managedObjectContext];
    
    self.addItemsArray = [NSMutableArray new];
    
    //If the user does not title the list, the app will title it with the current day/date/time
    if ([self.titleField.text isEqualToString:@""])
    {
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"EEEE, MMM dd yyy - hh:mm a"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        
        newList.listName = dateString;
        
    } else
    {
        newList.listName = self.titleField.text;
    }
    
    
    //Identifies the textfields with string content and generates an array of the strings
    for (UITextField *newItem in self.textboxArray)
    {
        if (![newItem.text isEqualToString:@""])
        {
            [self.addItemsArray addObject:newItem.text];
            NSLog(@"Items: %@", self.addItemsArray);
        }
    }
    
    //Associates each string in the array as a new Task item
    for (NSInteger i=0; i<[self.addItemsArray count]; i++)
    {
        //Create the newTask here so that a new Task is create for each loop pass
        Task *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.store.managedObjectContext];
        newTask.item = [self.addItemsArray objectAtIndex:i];
        
        [newList addItemObject:newTask];
    }
    
    [self.store saveContext];
    [self.navigationController popViewControllerAnimated:YES];
}


















@end
