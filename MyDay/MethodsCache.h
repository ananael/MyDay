//
//  MethodsCache.h
//  MyDay
//
//  Created by Michael Hoffman on 3/4/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MethodsCache : NSObject

-(NSString *) convertDecimalToRoundedString:(NSNumber *)number;
-(NSString *) convertToTemperature:(NSNumber *)number;
-(NSString *) convertToHumidity:(NSNumber *)number;
-(NSString *) convertToPrecipProbability:(NSString *)precipType Probability:(NSNumber *)number;
-(NSString *) convertToWindBearing:(NSNumber *)number1 AndSpeed:(NSNumber *)number2;
-(NSString *) convertToVisibility:(NSNumber *)number;
-(void)hourlyData:(NSDictionary *)dict ForKey:(NSString *)key ToArray:(NSMutableArray *)array;
-(NSString *) epochTimeToLongFormat:(NSNumber *)number;
-(NSString *) epochTimeToHours:(NSNumber *)number;
-(NSString *) epochTimeToDay:(NSNumber *)number;
-(NSString *) epochTimeToDate:(NSNumber *)number;
-(UIImage *) stringToIcon:(NSString *)string Color:(NSString *)color;


@end
