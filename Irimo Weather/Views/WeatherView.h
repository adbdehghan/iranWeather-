//
//  WeatherView.h
//  Iran Weather
//
//  Created by aDb on 12/19/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKPersianFont.h"
#import "UIImage+ImageEffects.h"
#import <SpriteKit/SpriteKit.h>

@class WeatherData;

@protocol WeatherViewDelegate <NSObject>


@end

@interface WeatherView : UIView <UIGestureRecognizerDelegate>

@property (strong, nonatomic) id<WeatherViewDelegate>    delegate;

//  YES if view contains weather data
@property (assign, nonatomic)                       BOOL    hasData;

//  YES if view contains local weather data
@property (assign, nonatomic, getter = isLocal)     BOOL    local;

@property (strong, nonatomic, readonly) UIImageView *backgroundImage;
//  Displays the time the weather data for this view was last updated
@property (strong, nonatomic, readonly) UILabel *updatedLabel;

//  Displays the icon for current conditions
@property (strong, nonatomic, readonly) UILabel *conditionIconLabel;

//  Displays the description of current conditions
@property (strong, nonatomic, readonly) UILabel *conditionDescriptionLabel;

//  Displays the location whose weather data is being represented by this weather view
@property (strong, nonatomic, readonly) UILabel *locationLabel;

//  Displayes the current temperature
@property (strong, nonatomic, readonly) UILabel *currentTemperatureLabel;

@property (strong, nonatomic, readonly) UILabel *humidityLabel;

@property (strong, nonatomic, readonly) UILabel *preasureLabel;

@property (strong, nonatomic, readonly) UILabel *horizentalViewLabel;

@property (strong, nonatomic, readonly) UILabel *windSpeedLabel;

@property (strong, nonatomic, readonly) NSString *windDirectionAngle;

@property (strong, nonatomic, readonly) UILabel *windSpeedUnitLabel;

@property (strong, nonatomic, readonly) UILabel *preasureUnitLabel;

@property (strong, nonatomic, readonly) UILabel *horizentalViewUnitLabel;

@property (strong, nonatomic, readonly) UILabel *feelsTempLabel;

//  Displays both the high and low temperatures for today
@property (strong, nonatomic, readonly) UILabel *highTemperatureLabel1;
@property (strong, nonatomic, readonly) UILabel *highTemperatureLabel2;
@property (strong, nonatomic, readonly) UILabel *highTemperatureLabel3;

@property (strong, nonatomic, readonly) UILabel *minTemperatureLabel1;
@property (strong, nonatomic, readonly) UILabel *minhTemperatureLabel2;
@property (strong, nonatomic, readonly) UILabel *minhTemperatureLabel3;

@property (strong, nonatomic,readonly) UILabel  *forcastDaylabel1;

@property (strong, nonatomic,readonly) UILabel             *forcastDaylabel2;

@property (strong, nonatomic,readonly) UILabel             *forcastDaylabel3;

//  Displays the day of the week for the first forecast snapshot
@property (strong, nonatomic, readonly) UILabel *forecastDayOneLabel;

//  Displays the day of the week for the second forecast snapshot
@property (strong, nonatomic, readonly) UILabel *forecastDayTwoLabel;

//  Displays the day of the week for the third forecast snapshot
@property (strong, nonatomic, readonly) UILabel *forecastDayThreeLabel;

//  Displays the icon representing the predicted conditions for the first forecast snapshot
@property (strong, nonatomic, readonly) UILabel *forecastIconOneLabel;

//  Displays the icon representing the predicted conditions for the second forecast snapshot
@property (strong, nonatomic, readonly) UILabel *forecastIconTwoLabel;

//  Displays the icon representing the predicted conditions for the third forecast snapshot
@property (strong, nonatomic, readonly) UILabel *forecastIconThreeLabel;

@property (nonatomic) BOOL                        isDay;

@property (strong, nonatomic ,readonly) UIView              *windDirectionContainer;


- (void)spinLayer:(CALayer *)inLayer duration:(CFTimeInterval)inDuration
        direction:(int)direction degrees:(CGFloat)degrees wind:(NSString*)windSpeed;

-(void)setWeatherCondition:(NSString*)condition;
@end
