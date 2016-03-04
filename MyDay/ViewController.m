//
//  ViewController.m
//  MyDay
//
//  Created by Michael Hoffman on 2/26/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"

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

@property (strong, nonatomic) NSMutableArray *contentBoxes;
@property (strong, nonatomic) NSMutableArray *degreeArray;
@property (strong, nonatomic) NSMutableArray *timeArray;
@property (strong, nonatomic) NSMutableArray *iconArray;
@property (strong, nonatomic) NSMutableArray *temperatures;
@property (strong, nonatomic) NSMutableArray *hours;
@property (strong, nonatomic) NSMutableArray *icons;

@property NSArray *tempTimes;
@property NSArray *tempIcons;
@property NSArray *tempTemps;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    //Could not remove the extra top/bottom padding, so using borders to mask some empty space in larger screens
    //Adjusting certain label font sizes due to iPhone sizes
    if (UIScreen.mainScreen.bounds.size.height == 480) {
        // iPhone 4
        self.weatherSummary.font = [UIFont fontWithName:@"AvenirNext-HeavyItalic" size:22];
        self.currentTemp.font = [UIFont fontWithName:@"AvenirNext-HeavyItalic" size:34];
        self.hiTemp.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14];
        self.loTemp.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14];
        self.sunTimes.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14];
        [self addTopBorderWithColor:[UIColor whiteColor] andWidth:2.0];
        [self addBottomBorderWithColor:[UIColor whiteColor] andWidth:2.0];
        
    } else if (UIScreen.mainScreen.bounds.size.height == 568) {
        // IPhone 5
        self.weatherSummary.font = [UIFont fontWithName:@"AvenirNext-HeavyItalic" size:25];
        self.currentTemp.font = [UIFont fontWithName:@"AvenirNext-HeavyItalic" size:40];
        self.hiTemp.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16];
        self.loTemp.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16];
        self.sunTimes.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16];
        [self addTopBorderWithColor:[UIColor whiteColor] andWidth:8.0];
        [self addBottomBorderWithColor:[UIColor whiteColor] andWidth:8.0];
    } else
    {
        self.weatherSummary.font = [UIFont fontWithName:@"AvenirNext-HeavyItalic" size:32];
        self.currentTemp.font = [UIFont fontWithName:@"AvenirNext-HeavyItalic" size:42];
        self.hiTemp.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
        self.loTemp.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
        self.sunTimes.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
        [self addTopBorderWithColor:[UIColor whiteColor] andWidth:10.0];
        [self addBottomBorderWithColor:[UIColor whiteColor] andWidth:10.0];
    }
    
    self.backgroundImage.image = [UIImage imageNamed:@"paisley sky lapis"];
    
    self.sunTimes.text = @"7:00 am  \u25b2 sun \u25bc  8:00 pm";
    
    //Initialzes Mutable Arrays
    self.contentBoxes = [NSMutableArray new];
    self.timeArray = [NSMutableArray new];
    self.iconArray = [NSMutableArray new];
    self.degreeArray = [NSMutableArray new];
    
    self.tempTimes = @[@"9 PM", @"10 PM", @"11 PM", @"12 AM", @"1 AM", @"2 AM", @"3 AM", @"4 AM", @"5 AM", @"6 AM"];
    self.tempIcons = @[@"icon-black-cloudy", @"icon-black-moon", @"icon-black-pc-day", @"icon-black-pc-night", @"icon-black-rain-cloud", @"icon-black-snowfall", @"icon-black-snowflake", @"icon-black-sunny", @"icon-black-thunderstorm", @"icon-black-tornado"];
    self.tempTemps = @[@"88°", @"105°", @"10°", @"45°", @"-15°", @"64°", @"0°", @"97°", @"118°", @"72°"];
    
    
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tempTimes count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"weatherCell" forIndexPath:indexPath];
    
    // Configure the cell
    
    cell.timeLabel.text = self.tempTimes[indexPath.row];
    cell.timeLabel.backgroundColor = [UIColor clearColor];
    
    cell.iconImage.image = [UIImage imageNamed:self.tempIcons[indexPath.row]];
    cell.iconImage.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    
    cell.degreeLabel.text = self.tempTemps[indexPath.row];
    cell.degreeLabel.backgroundColor = [UIColor clearColor];
    
    
    return cell;
}


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




















@end
