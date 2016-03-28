//
//  OpeningViewController.m
//  MyDay
//
//  Created by Michael Hoffman on 3/7/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import "OpeningViewController.h"
#import "Constants.h"
#import "ViewController.h"

@interface OpeningViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;


@property NSTimer *timer;
@property NSInteger seconds;

@property (strong, nonatomic) Forecastr *forecastr;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation OpeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backgroundImage.animationImages = [self animationArray];
    self.backgroundImage.animationDuration = 8.0;
    self.backgroundImage.animationRepeatCount = 1;
    [self.backgroundImage startAnimating];
    
    [self openingTimer];
    
    self.locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    self.locationManager.delegate = self; // setting the delegate of locationManager to self.
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    [self.locationManager startUpdatingLocation];  //requesting location updates
    
    //Call to Forecast.io
    self.forecastr = [Forecastr sharedManager];
    self.forecastr.apiKey = FORECAST_API_KEY;
    
    [self.forecastr getForecastForLocation:self.locationManager.location
                                      time:nil
                                exclusions:nil
                                    extend:nil
                                   success:^(id JSON)
     {
         float latitude = self.locationManager.location.coordinate.latitude;
         float longitude = self.locationManager.location.coordinate.longitude;
         
         [self.forecastr getForecastForLatitude:latitude
                                      longitude:longitude
                                           time:nil
                                     exclusions:nil
                                         extend:nil
                                        success:^(id JSON)
          {
              self.resultsDict = JSON;
              
              
              
          }
                                        failure:^(NSError *error, id response) {
                                            NSLog(@"Error while retrieving forecast: %@", [self.forecastr messageForError:error withResponse:response]);
                                        }];
     }
                                   failure:^(NSError *error, id response) {
                                       NSLog(@"Error while retrieving forecast: %@", [self.forecastr messageForError:error withResponse:response]);
                                   }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)animationArray
{
    NSArray *images = @[[UIImage imageNamed:@"open 01"], [UIImage imageNamed:@"open 02"], [UIImage imageNamed:@"open 03"], [UIImage imageNamed:@"open 04"], [UIImage imageNamed:@"open 05"], [UIImage imageNamed:@"open 06"], [UIImage imageNamed:@"open 07"], [UIImage imageNamed:@"open 08"], [UIImage imageNamed:@"open 09"], [UIImage imageNamed:@"open 10"], [UIImage imageNamed:@"open 11"], [UIImage imageNamed:@"open 12"], [UIImage imageNamed:@"open 13"], [UIImage imageNamed:@"open 14"], [UIImage imageNamed:@"open 15"], [UIImage imageNamed:@"open 16"], [UIImage imageNamed:@"open 17"], [UIImage imageNamed:@"open 18"], [UIImage imageNamed:@"open 19"], [UIImage imageNamed:@"open 20"], [UIImage imageNamed:@"open 21"], [UIImage imageNamed:@"open 22"], [UIImage imageNamed:@"open 23"], [UIImage imageNamed:@"open 24"], [UIImage imageNamed:@"open 25"], [UIImage imageNamed:@"open 26"], [UIImage imageNamed:@"open 26"], [UIImage imageNamed:@"open 26"], [UIImage imageNamed:@"open 26"], [UIImage imageNamed:@"open 26"], [UIImage imageNamed:@"open 26"], [UIImage imageNamed:@"open 27"], [UIImage imageNamed:@"open 28"], [UIImage imageNamed:@"open 29"], [UIImage imageNamed:@"open 30"], [UIImage imageNamed:@"open 31"], [UIImage imageNamed:@"open 32"], [UIImage imageNamed:@"open 33"], [UIImage imageNamed:@"open 34"], [UIImage imageNamed:@"open 35"], [UIImage imageNamed:@"open 36"], [UIImage imageNamed:@"open 37"], [UIImage imageNamed:@"open 38"], [UIImage imageNamed:@"open 38"], [UIImage imageNamed:@"open 38"], [UIImage imageNamed:@"open 38"], [UIImage imageNamed:@"open 38"], [UIImage imageNamed:@"open 38"], [UIImage imageNamed:@"open 38"], [UIImage imageNamed:@"open 38"], [UIImage imageNamed:@"open 38"]];
    return images;
}

-(void)openingTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:8.0
                                                  target:self
                                                selector:@selector(segue)
                                                userInfo:nil
                                                 repeats:NO];
}

-(void)segue
{
    [self performSegueWithIdentifier:@"mainSegue" sender:self];
}

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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if ([segue.identifier isEqualToString:@"mainSegue"])
    {
        ViewController *mainVC = segue.destinationViewController;
        mainVC.resultsDict = self.resultsDict;
    }
    
    
    
}













@end
