//
//  SOLStateManager.m
//  Sol
//
//  Created by Comyar Zaheri on 9/20/13.
//  Copyright (c) 2013 Comyar Zaheri. All rights reserved.
//

#import "StateManager.h"


#pragma mark - SOLStateManager Implementation

@implementation StateManager

#pragma mark Using the SOLStateManager

+ (TemperatureScale)temperatureScale
{
    return (TemperatureScale)[[NSUserDefaults standardUserDefaults]integerForKey:@"temp_scale"];
}

+ (SpeedScale)speedScale
{
    return (SpeedScale)[[NSUserDefaults standardUserDefaults]integerForKey:@"speed_scale"];
}

+ (Local)local
{
    return (Local)[[NSUserDefaults standardUserDefaults]integerForKey:@"local"];
}

+ (void)setTemperatureScale:(TemperatureScale)scale
{
    [[NSUserDefaults standardUserDefaults]setInteger:scale forKey:@"temp_scale"];
}

+ (void)setSpeedScale:(SpeedScale)scale
{
    [[NSUserDefaults standardUserDefaults]setInteger:scale forKey:@"speed_scale"];
}

+(void)setLocal:(Local)isLocal
{
    [[NSUserDefaults standardUserDefaults]setInteger:isLocal forKey:@"local"];
}

+ (NSDictionary *)weatherData
{
    NSData *encodedWeatherData = [[NSUserDefaults standardUserDefaults]objectForKey:@"weather_data"];
    if(encodedWeatherData) {
        return (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedWeatherData];
    }
    return nil;
}

+ (void)setWeatherData:(NSDictionary *)weatherData
{
    NSData *encodedWeatherData = [NSKeyedArchiver archivedDataWithRootObject:weatherData];
    [[NSUserDefaults standardUserDefaults]setObject:encodedWeatherData forKey:@"weather_data"];
}

+ (NSArray *)weatherTags
{
    NSData *encodedWeatherTags = [[NSUserDefaults standardUserDefaults]objectForKey:@"weather_tags"];
    if(encodedWeatherTags) {
        return (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedWeatherTags];
    }
    return nil;
}

+ (void)setWeatherTags:(NSArray *)weatherTags
{
    NSData *encodedWeatherTags = [NSKeyedArchiver archivedDataWithRootObject:weatherTags];
    [[NSUserDefaults standardUserDefaults]setObject:encodedWeatherTags forKey:@"weather_tags"];
}

@end
