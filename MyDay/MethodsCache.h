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

-(UIColor*)colorWithHexString:(NSString*)hex alpha:(CGFloat)alpha;
-(void)centerButtonText:(NSArray *)array;
-(void)roundButtonCorners:(NSInteger)radius forArray:(NSArray *)array;
-(void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth to:(UIView *)view;
-(void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth to:(UIView *)view;
-(void)buttonBorderColor:(UIColor *)color andWidth:(NSInteger)width forArray:(NSArray *)array;
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
