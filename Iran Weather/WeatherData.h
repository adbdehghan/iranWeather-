//
//  WeatherData.h
//  Iran Weather
//
//  Created by aDb on 12/16/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherData : NSObject

@property (strong, nonatomic) NSString *stationCode;

@property (strong, nonatomic) NSString *stationName;

@property (strong, nonatomic) NSString *lastUpdate;

@property (strong, nonatomic) NSString *humidity;

@property (strong, nonatomic) NSString *windSpeed;

@property (strong, nonatomic) NSString *windDirection;

@property (strong, nonatomic) NSString *icon;

@property (strong, nonatomic) NSString *dayOfWeek;

@property (strong, nonatomic) NSString *conditionDescription;

@property (assign, nonatomic) NSString *currentTemperature;

@property (assign, nonatomic) NSString *preasure;

@property (assign, nonatomic) NSString *horizentalView;

@property (assign, nonatomic) NSString *latitude;

@property (assign, nonatomic) NSString *longtitude;

@property (assign, nonatomic) NSString *maxTemperature1;

@property (assign, nonatomic) NSString *minTemperature1;

@property (strong, nonatomic) NSString *conditionDescription1;

@property (assign, nonatomic) NSString *maxTemperature2;

@property (assign, nonatomic) NSString *minTemperature2;

@property (strong, nonatomic) NSString *conditionDescription2;

@property (assign, nonatomic) NSString *maxTemperature3;

@property (assign, nonatomic) NSString *minTemperature3;

@property (strong, nonatomic) NSString *conditionDescription3;

@property (strong, nonatomic) NSString *forecastIconOneLabel;

@property (strong, nonatomic) NSString *forecastIconTwoLabel;

@property (strong, nonatomic) NSString *forecastIconThreeLabel;

@property (strong, nonatomic) NSString             *forcastDaylabel1;

@property (strong, nonatomic) NSString             *forcastDaylabel2;

@property (strong, nonatomic) NSString             *forcastDaylabel3;

- (NSString *)iconForCondition:(NSString *)condition isDay:(BOOL)isday;
- (NSString *)descriptionForCondition:(NSString *)condition;
-(void)fillData:(NSDictionary*)data;

@end
