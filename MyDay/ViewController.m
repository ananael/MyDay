//
//  ViewController.m
//  MyDay
//
//  Created by Michael Hoffman on 2/26/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "CollectionViewCell.h"
#import "MethodsCache.h"
#import "WeatherListViewController.h"
#import "ToDoListViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *weatherSummary;
@property (weak, nonatomic) IBOutlet UILabel *currentTemp;
@property (weak, nonatomic) IBOutlet UILabel *hiTemp;
@property (weak, nonatomic) IBOutlet UILabel *loTemp;

@property (weak, nonatomic) IBOutlet UILabel *sunTimes;

@property (weak, nonatomic) IBOutlet UIView *collectionContainer;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *forecastButton;
@property (weak, nonatomic) IBOutlet UIButton *todoButton;
@property (weak, nonatomic) IBOutlet UIButton *rssButton;

- (IBAction)forecastTapped:(id)sender;
- (IBAction)todoTapped:(id)sender;
- (IBAction)rssTapped:(id)sender;

@property (strong, nonatomic) Forecastr *forecastr;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property MethodsCache *method;

@property NSMutableArray *degreeArray;
@property NSMutableArray *timeArray;
@property NSMutableArray *iconArray;
@property NSMutableArray *degrees;
@property NSMutableArray *hours;
@property NSMutableArray *icons;

@property NSArray *tempTimes;
@property NSArray *tempIcons;
@property NSArray *tempTemps;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self adjustForPhoneSizes];
    
    self.backgroundImage.image = [UIImage imageNamed:@"paisley sky lapis"];
    self.backgroundImage.alpha = 0.8;
    
    self.method = [MethodsCache new];
    
    //Initialzes Mutable Arrays
    self.timeArray = [NSMutableArray new];
    self.iconArray = [NSMutableArray new];
    self.degreeArray = [NSMutableArray new];
    self.hours = [NSMutableArray new];
    self.icons = [NSMutableArray new];
    self.degrees = [NSMutableArray new];
    
    self.weatherSummary.text = self.resultsDict[@"currently"][@"summary"];
    self.currentTemp.text = [self.method convertToTemperature:self.resultsDict[@"currently"][@"temperature"]];
    self.hiTemp.text = [NSString stringWithFormat:@"hi: %@", [self.method convertToTemperature:self.resultsDict[@"daily"][@"data"][0][@"apparentTemperatureMax"]]];
    self.loTemp.text = [NSString stringWithFormat:@"hi: %@", [self.method convertToTemperature:self.resultsDict[@"daily"][@"data"][0][@"apparentTemperatureMin"]]];
    self.sunTimes.text = [NSString stringWithFormat:@"%@  \u25b2 sun \u25bc  %@", [self.method epochTimeToLongFormat:self.resultsDict[@"daily"][@"data"][0][@"sunriseTime"]], [self.method epochTimeToLongFormat:self.resultsDict[@"daily"][@"data"][0][@"sunsetTime"]]];
    
    //Pulls in the time starting with the array[1]
    //Time for the hour after the current hour
    [self.method hourlyData:self.resultsDict ForKey:@"time" ToArray:self.timeArray];
    
    for (NSInteger i=0; i<[self.timeArray count]; i++)
    {
        NSString *hour;
        hour = [self.method epochTimeToHours:[self.timeArray objectAtIndex:i]];
        
        [self.hours addObject:hour];
    }
    
    //Pulls in the temperature starting with the array[1]
    //Temperature to match the hour
    [self.method hourlyData:self.resultsDict ForKey:@"temperature" ToArray:self.degreeArray];
    
    for (NSInteger i=0; i<[self.degreeArray count]; i++)
    {
        NSString *degree;
        degree = [self.method convertToTemperature:[self.degreeArray objectAtIndex:i]];
        
        [self.degrees addObject:degree];
    }
    
    //Pulls in the icon-string starting with the array[1]
    //Icon-string to match the hour
    [self.method hourlyData:self.resultsDict ForKey:@"icon" ToArray:self.iconArray];
    
    for (NSInteger i=0; i<[self.iconArray count]; i++)
    {
        UIImage *icon;
        //"Style" choices for this method are: @"black" or @"white"
        icon = [self.method stringToIcon:[self.iconArray objectAtIndex:i] Color:@"black"];
        
        [self.icons addObject:icon];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    UIView *border = [UIView new];
    border.backgroundColor = color;
    [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    border.frame = CGRectMake(0, 0, self.collectionContainer.frame.size.width, borderWidth);
    [self.collectionContainer addSubview:border];
}

- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    UIView *border = [UIView new];
    border.backgroundColor = color;
    [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border.frame = CGRectMake(0, self.collectionContainer.frame.size.height - borderWidth, self.collectionContainer.frame.size.width, borderWidth);
    [self.collectionContainer addSubview:border];
}

-(void)adjustForPhoneSizes
{
    //Could not remove the extra top/bottom padding, so using borders to mask some empty space in larger screens
    //Adjusting certain label font sizes due to iPhone sizes
    if (UIScreen.mainScreen.bounds.size.height == 480) {
        // iPhone 4
        self.weatherSummary.font = [UIFont fontWithName:@"AvenirNext-HeavyItalic" size:25];
        self.currentTemp.font = [UIFont fontWithName:@"AvenirNext-HeavyItalic" size:36];
        self.hiTemp.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14];
        self.loTemp.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14];
        self.sunTimes.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14];
        [self addTopBorderWithColor:[UIColor whiteColor] andWidth:2.0];
        [self addBottomBorderWithColor:[UIColor whiteColor] andWidth:2.0];
        
    } else if (UIScreen.mainScreen.bounds.size.height == 568) {
        // IPhone 5
        self.weatherSummary.font = [UIFont fontWithName:@"AvenirNext-HeavyItalic" size:29];
        self.currentTemp.font = [UIFont fontWithName:@"AvenirNext-HeavyItalic" size:42];
        self.hiTemp.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16];
        self.loTemp.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16];
        self.sunTimes.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16];
        [self addTopBorderWithColor:[UIColor whiteColor] andWidth:8.0];
        [self addBottomBorderWithColor:[UIColor whiteColor] andWidth:8.0];
    } else
    {
        self.weatherSummary.font = [UIFont fontWithName:@"AvenirNext-HeavyItalic" size:34];
        self.currentTemp.font = [UIFont fontWithName:@"AvenirNext-HeavyItalic" size:46];
        self.hiTemp.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
        self.loTemp.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
        self.sunTimes.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
        [self addTopBorderWithColor:[UIColor whiteColor] andWidth:10.0];
        [self addBottomBorderWithColor:[UIColor whiteColor] andWidth:10.0];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.hours count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"weatherCell" forIndexPath:indexPath];
    
    // Configure the cell
    
    cell.timeLabel.text = self.hours[indexPath.row];
    cell.timeLabel.backgroundColor = [UIColor clearColor];
    
    cell.iconImage.image = self.icons[indexPath.row];
    cell.iconImage.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    
    cell.degreeLabel.text = self.degrees[indexPath.row];
    cell.degreeLabel.backgroundColor = [UIColor clearColor];
    
    
    return cell;
}
/*
#pragma mark - CLLocationManager methods

//Used in NSLog
-(NSString *) deviceLocation
{
    return [NSString stringWithFormat:@"latitude: %f  longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was an error retrieving your location" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [errorAlert addAction:okButton];
    
    [self presentViewController:errorAlert animated:YES completion:nil];
    
    NSLog(@"Error: %@",error.description);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *crnLoc = [locations lastObject];
    
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"From the method: %@", crnLoc);
}
*/
#pragma mark - Buttons

- (IBAction)forecastTapped:(id)sender
{
    NSLog(@"Forecast Pressed.");
}

- (IBAction)todoTapped:(id)sender
{
    NSLog(@"ToDo Pressed.");
}

- (IBAction)rssTapped:(id)sender
{
    NSLog(@"RSS Pressed.");
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     if ([segue.identifier isEqualToString:@"weeklySegue"])
     {
         WeatherListViewController *weatherVC = segue.destinationViewController;
         weatherVC.resultsDict = self.resultsDict;
         
     }
     
 }



















@end
