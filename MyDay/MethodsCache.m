//
//  MethodsCache.m
//  MyDay
//
//  Created by Michael Hoffman on 3/4/16.
//  Copyright © 2016 Here We Go. All rights reserved.
//

#import "MethodsCache.h"

@implementation MethodsCache

-(NSString *) convertDecimalToRoundedString:(NSNumber *)number
{
    CGFloat convertNumber = [number floatValue];
    NSString *roundedString = [NSString stringWithFormat:@"%.0f", convertNumber];
    
    return roundedString;
}

-(NSString *) convertToTemperature:(NSNumber *)number
{
    NSString *convertedNumber = [self convertDecimalToRoundedString:number];
    NSString *temperatureString = [NSString stringWithFormat:@"%@°", convertedNumber];
    return temperatureString;
}

-(NSString *) convertToHumidity:(NSNumber *)number
{
    CGFloat convertNumber = [number floatValue];
    NSString *humidityString = [NSString stringWithFormat:@"hum: %.0f%%", (convertNumber*100)];
    
    return humidityString;
}

-(NSString *) convertToPrecipProbability:(NSString *)precipType Probability:(NSNumber *)number
{
    CGFloat convertNumber = [number floatValue];
    if (precipType == nil)
    {
        NSString *precipString = [NSString stringWithFormat:@"0%% precipitation"];
        return precipString;
    }
    if ((convertNumber < 1.0f))
    {
        NSString *precipString = [NSString stringWithFormat:@"%@? %.0f%% chance", precipType, (convertNumber*100)];
        return precipString;
    }
    
    NSString *precipString = [NSString stringWithFormat:@"%@? 100%% chance", precipType];
    return precipString;
    
}

-(NSString *) convertToWindBearing:(NSNumber *)number1 AndSpeed:(NSNumber *)number2
{
    NSString *windWithSpeed = [NSString stringWithFormat:@"wind: %@ %@ mph", [self windDirection:number1], [self convertDecimalToRoundedString:number2]];
    return windWithSpeed;
}

//NOTE: Method starts with the array[1]
-(void)hourlyData:(NSDictionary *)dict ForKey:(NSString *)key ToArray:(NSMutableArray *)array
{
    for (NSInteger i = 1; i < 25; i++)
    {
        NSNumber *eachItem;
        eachItem = dict[@"hourly"][@"data"][i][key];
        
        [array addObject:eachItem];
    }
}

-(NSString *) convertToVisibility:(NSNumber *)number
{
    if (number == nil) {
        NSString *visibilityString = [NSString stringWithFormat:@"visibility: no data"];
        return visibilityString;
    }
    NSString *visibilityString = [NSString stringWithFormat:@"visibility: %@ mi", [self convertDecimalToRoundedString:number]];
    return visibilityString;
}

-(NSString *) epochTimeToHours:(NSNumber *)number
{
    NSInteger convertedNumber = [number integerValue];
    NSTimeInterval time = convertedNumber;
    NSDate *humanDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h a"];
    
    NSString *truncatedTime = [formatter stringFromDate:humanDate];
    
    return truncatedTime;
}

-(NSString *) epochTimeToDay:(NSNumber *)number
{
    NSInteger convertedNumber = [number integerValue];
    NSTimeInterval time = convertedNumber;
    NSDate *humanDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE"];
    
    NSString *lowercaseDayFormat = [[formatter stringFromDate:humanDate] lowercaseStringWithLocale:[NSLocale currentLocale]];
    
    return lowercaseDayFormat;
}

-(NSString *) epochTimeToDate:(NSNumber *)number
{
    NSInteger convertedNumber = [number integerValue];
    NSTimeInterval time = convertedNumber;
    NSDate *humanDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d"];
    
    //NSString *lowercaseFormat = [[formatter stringFromDate:humanDate] lowercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *truncatedDate = [formatter stringFromDate:humanDate];
    
    return truncatedDate;
}

-(NSString *) windDirection:(NSNumber *)number
{
    NSInteger convertedNumber = [number integerValue];
    NSString *direction;
    
    if ((convertedNumber >= 0) && (convertedNumber <= 11))
    {
        direction = @"N";
    } else if ((convertedNumber >= 12) && (convertedNumber <= 34))
    {
        direction = @"NNE";
    } else if ((convertedNumber >= 35) && (convertedNumber <= 57))
    {
        direction = @"NE";
    } else if ((convertedNumber >= 58) && (convertedNumber <= 79))
    {
        direction = @"ENE";
    } else if ((convertedNumber >= 80) && (convertedNumber <= 101))
    {
        direction = @"E";
    } else if ((convertedNumber >= 102) && (convertedNumber <= 124))
    {
        direction = @"ESE";
    } else if ((convertedNumber >= 125) && (convertedNumber <= 146))
    {
        direction = @"SE";
    } else if ((convertedNumber >= 147) && (convertedNumber <= 169))
    {
        direction = @"SSE";
    } else if ((convertedNumber >= 170) && (convertedNumber <= 191))
    {
        direction = @"S";
    } else if ((convertedNumber >= 192) && (convertedNumber <= 214))
    {
        direction = @"SSW";
    } else if ((convertedNumber >= 215) && (convertedNumber <= 236))
    {
        direction = @"SW";
    } else if ((convertedNumber >= 237) && (convertedNumber <= 259))
    {
        direction = @"WSW";
    } else if ((convertedNumber >= 260) && (convertedNumber <= 281))
    {
        direction = @"W";
    } else if ((convertedNumber >= 282) && (convertedNumber <= 304))
    {
        direction = @"WNW";
    } else if ((convertedNumber >= 305) && (convertedNumber <= 326))
    {
        direction = @"NW";
    } else if ((convertedNumber >= 327) && (convertedNumber <= 349))
    {
        direction = @"NNW";
    } else if ((convertedNumber >= 350) && (convertedNumber <= 360))
    {
        direction = @"N";
    }
    
    return direction;
}

//"Color" choices for this method are: @"black" or @"white"
-(UIImage *) stringToIcon:(NSString *)string Color:(NSString *)color
{
    UIImage *image;
    
    if ([string isEqualToString:@"clear-day"])
    {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-%@-sunny", color]];
    }
    else if ([string isEqualToString:@"partly-cloudy-day"])
    {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-%@-pc-day", color]];
    }
    else if ([string isEqualToString:@"partly-cloudy-night"])
    {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-%@-pc-night", color]];
    }
    else if ([string isEqualToString:@"cloudy"])
    {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-%@-cloudy", color]];
    }
    else if ([string isEqualToString:@"rain"])
    {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-%@-rain-cloud", color]];
    }
    else if ([string isEqualToString:@"thunderstorm"])
    {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-%@-thunderstorm", color]];
    }
    else if ([string isEqualToString:@"clear-night"])
    {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-%@-moon", color]];
    }
    else if ([string isEqualToString:@"hail"])
    {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-%@-hail", color]];
    }
    else if ([string isEqualToString:@"snow"])
    {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-%@-snowflake", color]];
    }
    else if ([string isEqualToString:@"tornado"])
    {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-%@-tornado", color]];
    }
    return image;
}









@end
