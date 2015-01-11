//
//  StateManager.h
//  Sol
//
//  Created by aDb on 9/20/13.
//  Copyright (c) 2013 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeatherData;

typedef enum {
    FahrenheitScale=0,
    CelsiusScale

} TemperatureScale;

typedef enum {
    msScale =0,
    kmScale
} SpeedScale;

typedef enum {
    local = 0,
    nonLocal
} Local;

/**
 StateManager allows for easy state persistence and acts as a thin wrapper around NSUserDefaults
 */
@interface StateManager : NSObject

// -----
// @name Using the State Manager
// -----

/**
 Get the saved temperature scale
 @returns The saved temperature scale
 */
+ (TemperatureScale)temperatureScale;
+ (SpeedScale)speedScale;
+ (Local)local;
/**
 Save the given temperature scale
 @param scale Temperature scale to save
 */
+ (void)setTemperatureScale:(TemperatureScale)scale;
+ (void)setSpeedScale:(SpeedScale)scale;
+ (void)setLocal:(Local)isLocal;
/**
 Get saved weather data
 @returns Saved weather data as a dictionary
 */
+ (NSDictionary *)weatherData;

/**
 Save the given weather data
 @param weatherData Weather data to save
 */
+ (void)setWeatherData:(NSDictionary *)weatherData;

/**
 Get the saved ordered-list of weather tags
 @returns The saved weather tags
 */
+ (NSArray *)weatherTags;

/**
 Save the given ordered-list of weather tags
 @param weatherTags List of weather tags
 */
+ (void)setWeatherTags:(NSArray *)weatherTags;

@end
