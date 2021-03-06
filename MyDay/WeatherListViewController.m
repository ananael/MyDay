//
//  WeatherListViewController.m
//  MyDay
//
//  Created by Michael Hoffman on 3/3/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import "WeatherListViewController.h"
#import "WeatherListTableViewCell.h"
#import "MethodsCache.h"

@interface WeatherListViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *buttonContainer;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *todoButton;
@property (weak, nonatomic) IBOutlet UIButton *rssButton;

@property MethodsCache *method;

@property NSMutableArray *dayArray;
@property NSMutableArray *dateArray;
@property NSMutableArray *detailArray;
@property NSMutableArray *degreeArray;
@property NSMutableArray *humidityArray;
@property NSMutableArray *precipArray;
@property NSMutableArray *windArray;
@property NSMutableArray *visibilityArray;
@property NSMutableArray *iconArray;

- (IBAction)homeTapped:(id)sender;
- (IBAction)todoTapped:(id)sender;
- (IBAction)rssTapped:(id)sender;

@property NSMutableArray *tryOut;
@property NSMutableArray *succeeded;

@end

@implementation WeatherListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200.0;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.backgroundImage.image = [UIImage imageNamed:@"forecast background"];
    self.backgroundImage.alpha = 0.8;
    
    self.method = [MethodsCache new];
    
    [self.homeButton setBackgroundImage:[UIImage imageNamed:@"home button"] forState:UIControlStateNormal];
    [self.todoButton setBackgroundImage:[UIImage imageNamed:@"todo button"] forState:UIControlStateNormal];
    [self.rssButton setBackgroundImage:[UIImage imageNamed:@"rss button"] forState:UIControlStateNormal];
    [self.method buttonBorderColor:[UIColor whiteColor] andWidth:1.0 forArray:[self buttonArray]];
    [self.method roundButtonCorners:8.0 forArray:[self buttonArray]];
    
    self.dayArray = [NSMutableArray new];
    self.detailArray = [NSMutableArray new];
    self.dateArray = [NSMutableArray new];
    self.degreeArray = [NSMutableArray new];
    self.humidityArray = [NSMutableArray new];
    self.precipArray = [NSMutableArray new];
    self.windArray = [NSMutableArray new];
    self.visibilityArray = [NSMutableArray new];
    self.iconArray = [NSMutableArray new];
    
    for (NSInteger i=0; i<7; i++)
    {
        //Each day and Date
        NSNumber *epochTime;
        NSString *convertedDay;
        NSString *convertedDate;
        epochTime = self.resultsDict[@"daily"][@"data"][i][@"time"];
        convertedDay = [self.method epochTimeToDay:epochTime];
        convertedDate = [self.method epochTimeToDate:epochTime];
        [self.dayArray addObject:convertedDay];
        [self.dateArray addObject:convertedDate];
        
        //Each day's weather in sentence format
        NSString *weatherDetail;
        weatherDetail = self.resultsDict[@"daily"][@"data"][i][@"summary"];
        [self.detailArray addObject:weatherDetail];
        
        //Each day's expected high temperature
        NSString *convertedTemp;
        convertedTemp = [self.method convertToTemperature:self.resultsDict[@"daily"][@"data"][i][@"temperatureMax"]];
        [self.degreeArray addObject:convertedTemp];
        
        //Each day's expected humidity level
        NSString *humidity;
        humidity = [self.method convertToHumidity:self.resultsDict[@"daily"][@"data"][i][@"humidity"]];
        [self.humidityArray addObject:humidity];
        
        //Each day's expected precipitation
        NSString *precipitation;
        precipitation = [self.method convertToPrecipProbability:self.resultsDict[@"daily"][@"data"][i][@"precipType"] Probability:self.resultsDict[@"daily"][@"data"][i][@"precipProbability"]];
        [self.precipArray addObject:precipitation];
        
        //Each day's wind direction and speed
        NSString *windInfo;
        windInfo = [self.method convertToWindBearing:self.resultsDict[@"daily"][@"data"][i][@"windBearing"] AndSpeed:self.resultsDict[@"daily"][@"data"][i][@"windSpeed"]];
        [self.windArray addObject:windInfo];
        
        //Each day's expected visibility
        NSString *visibility;
        visibility = [self.method convertToVisibility:self.resultsDict[@"daily"][@"data"][i][@"visibility"]];
        [self.visibilityArray addObject:visibility];
        
        //Each day's icon summary used to select appropriate icon image
        NSString *iconInfo;
        iconInfo = self.resultsDict[@"daily"][@"data"][i][@"icon"];
        [self.iconArray addObject:iconInfo];
        NSLog(@"What is ICON: %@", self.iconArray);
        
    }
    
    //NSLog(@"CURRENTLY STUFF: %@", self.resultsDict[@"currently"]);
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)buttonArray
{
    NSArray *buttons = @[self.homeButton, self.todoButton, self.rssButton];
    return buttons;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dayArray count];
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 WeatherListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weeklyCell" forIndexPath:indexPath];
 
 // Configure the cell...
    cell.backgroundColor = [UIColor clearColor];
    
    //Adjusting certain label font sizes due to iPhone sizes
    if ((UIScreen.mainScreen.bounds.size.height == 480) || (UIScreen.mainScreen.bounds.size.height == 568)) {
        // iPhone 4 & 5
        cell.detailLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:13];
        cell.degreeLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:25];
        cell.humidityLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:12];
        cell.precipLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:12];
        cell.windLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:12];
        cell.visibilityLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:12];
        cell.dateLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:13];
        
    } else
    {
        cell.detailLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:14];
        cell.degreeLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:28];
        cell.humidityLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:13];
        cell.precipLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:13];
        cell.windLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:13];
        cell.visibilityLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:13];
        cell.dateLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:13];
    }
    
    cell.dayLabel.text = self.dayArray[indexPath.row];
    cell.dayLabel.textColor = [UIColor blackColor];
    cell.dayLabel.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI_2*3), 1.25, 1.25);
    
    cell.detailLabel.text = self.detailArray[indexPath.row];
    cell.detailLabel.textColor = [UIColor blackColor];
    
    cell.iconImage.image = [self.method stringToIcon:self.iconArray[indexPath.row] Color:@"black"];
    
    cell.dateLabel.text = self.dateArray[indexPath.row];
    cell.dateLabel.textColor = [UIColor blackColor];
    
    cell.degreeLabel.text = self.degreeArray[indexPath.row];
    
    cell.humidityLabel.text = self.humidityArray[indexPath.row];
    
    cell.precipLabel.text = self.precipArray[indexPath.row];
    
    cell.windLabel.text = self.windArray[indexPath.row];
    
    cell.visibilityLabel.text = self.visibilityArray[indexPath.row];
    
    NSInteger borderWidth = 1.0;
    //Even though this code specifies modifications only to cell at index.row == 0,
    //the textcolor change effects the last cell as well.
    //To resolve, the cells named in the "IF" statement below were given a color in the lines above.
    if (indexPath.row == 0)
    {
        [self.method addTopBorderWithColor:[UIColor blackColor] andWidth:borderWidth to:cell];
        
        cell.dayLabel.text = @"now";
        cell.dayLabel.textColor = [UIColor whiteColor];
        cell.detailLabel.textColor = [UIColor whiteColor];
        cell.detailLabel.text = self.resultsDict[@"currently"][@"summary"];
        cell.degreeLabel.text = [self.method convertToTemperature:self.resultsDict[@"currently"][@"temperature"]];
        cell.humidityLabel.text = [self.method convertToHumidity:self.resultsDict[@"currently"][@"humidity"]];
        cell.precipLabel.text = [self.method convertToPrecipProbability:self.resultsDict[@"currently"][@"precipType"] Probability:self.resultsDict[@"currently"][@"precipProbability"]];
        cell.windLabel.text = [self.method convertToWindBearing:self.resultsDict[@"currently"][@"windBearing"] AndSpeed:self.resultsDict[@"currently"][@"windSpeed"]];
        cell.visibilityLabel.text = [self.method convertToVisibility:self.resultsDict[@"currently"][@"visibility"]];
        cell.dateLabel.textColor = [UIColor whiteColor];
        cell.iconImage.image = [self.method stringToIcon:self.resultsDict[@"currently"][@"icon"] Color:@"white"];
        
    }
    
    [self.method addBottomBorderWithColor:[UIColor blackColor] andWidth:borderWidth to:cell];
 
    return cell;
 }

#pragma mark - Navigation Buttons

- (IBAction)homeTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)todoTapped:(id)sender
{
    
}

- (IBAction)rssTapped:(id)sender
{
    
}

















@end
