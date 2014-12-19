//
//  WeatherData.m
//  Iran Weather
//
//  Created by aDb on 12/16/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import "WeatherData.h"
#import "Climacons.h"

@implementation WeatherData


-(void)fillData:(NSDictionary*)data
{
    self.stationCode = [[data valueForKey:@"wmo_code"]valueForKey:@"text"];
    self.stationName = [[data valueForKey:@"station_farsi"]valueForKey:@"text"];
    self.lastUpdate = [[data valueForKey:@"data_time"]valueForKey:@"text"];
    self.humidity = [[data valueForKey:@"u"]valueForKey:@"text"];
    self.windSpeed = [[data valueForKey:@"ff"]valueForKey:@"text"];
    self.windDirection = [[data valueForKey:@"dd"]valueForKey:@"text"];
    self.currentTemperature = [[data valueForKey:@"t"]valueForKey:@"text"];
    self.icon = [self iconForCondition:[[data valueForKey:@"weather"] valueForKey:@"text"] isDay:YES];
    self.conditionDescription = [self descriptionForCondition:[[data valueForKey:@"weather"] valueForKey:@"text"]];
    self.latitude = [[data valueForKey:@"lat"]valueForKey:@"text"];
    self.longtitude = [[data valueForKey:@"lon"]valueForKey:@"text"];
    self.maxTemperature1 = [[data valueForKey:@"maxtemp1"]valueForKey:@"text"];
    self.minTemperature1 = [[data valueForKey:@"mintemp1"]valueForKey:@"text"];
    self.conditionDescription1 = [[data valueForKey:@"dayph1"]valueForKey:@"text"];
    self.maxTemperature2 = [[data valueForKey:@"maxtemp2"]valueForKey:@"text"];
    self.minTemperature2 = [[data valueForKey:@"mintemp2"]valueForKey:@"text"];
    self.conditionDescription2 = [[data valueForKey:@"dayph2"]valueForKey:@"text"];
    self.maxTemperature3 = [[data valueForKey:@"maxtemp3"]valueForKey:@"text"];
    self.minTemperature3 = [[data valueForKey:@"mintemp4"]valueForKey:@"text"];
    self.conditionDescription3 = [[data valueForKey:@"dayph3"]valueForKey:@"text"];
}

- (NSString *)iconForCondition:(NSString *)condition isDay:(BOOL)isday
{
    NSString *iconName;
    
    if (isday) {
    NSArray *dayConditions = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%c", ClimaconSun]
                              ,[NSString stringWithFormat:@"%c", ClimaconCloudSun]
                              ,[NSString stringWithFormat:@"%c", ClimaconCloudSun]
                              ,[NSString stringWithFormat:@"%c", ClimaconCloudSun]
                              ,[NSString stringWithFormat:@"%c", ClimaconCloud]
                              ,[NSString stringWithFormat:@"%c", ClimaconCloudSun]
                              ,[NSString stringWithFormat:@"%c", ClimaconCloudUp]
                              ,[NSString stringWithFormat:@"%c", ClimaconCloudDown]
                              ,[NSString stringWithFormat:@"%c", ClimaconCloudUp]
                              ,[NSString stringWithFormat:@"%c", ClimaconThermometerLow]
                              ,[NSString stringWithFormat:@"%c", ClimaconThermometerHigh]
                              ,[NSString stringWithFormat:@"%c", ClimaconWind]
                              ,[NSString stringWithFormat:@"%c", ClimaconWind]
                              ,[NSString stringWithFormat:@"%c", ClimaconLightningSun]
                              ,[NSString stringWithFormat:@"%c", ClimaconLightning]
                              ,[NSString stringWithFormat:@"%c", ClimaconLightning]
                              ,[NSString stringWithFormat:@"%c", ClimaconWind]
                              ,[NSString stringWithFormat:@"%c", ClimaconWind]
                              ,[NSString stringWithFormat:@"%c", ClimaconWind]
                              ,[NSString stringWithFormat:@"%c", ClimaconHaze]
                              ,[NSString stringWithFormat:@"%c", ClimaconHaze]
                              ,[NSString stringWithFormat:@"%c", ClimaconHazeSun]
                              ,[NSString stringWithFormat:@"%c", ClimaconFog]
                              ,[NSString stringWithFormat:@"%c", ClimaconFog]
                              ,[NSString stringWithFormat:@"%c", ClimaconFogSun]
                              ,[NSString stringWithFormat:@"%c", ClimaconFog]
                              ,[NSString stringWithFormat:@"%c", ClimaconRainSun]
                              ,[NSString stringWithFormat:@"%c", ClimaconCloud]
                              ,[NSString stringWithFormat:@"%c", ClimaconDrizzle]
                              ,[NSString stringWithFormat:@"%c", ClimaconDownpour]
                              ,[NSString stringWithFormat:@"%c", ClimaconRain]
                              ,[NSString stringWithFormat:@"%c", ClimaconSleet]
                              ,[NSString stringWithFormat:@"%c", ClimaconDownpour]
                              ,[NSString stringWithFormat:@"%c", ClimaconSnow]
                              ,[NSString stringWithFormat:@"%c", ClimaconHail]
                              ,[NSString stringWithFormat:@"%c", ClimaconSnow]
                              ,[NSString stringWithFormat:@"%c", ClimaconTornado]
                              ,[NSString stringWithFormat:@"%c", ClimaconSun]
                              ,[NSString stringWithFormat:@"%c", ClimaconWind]
                              ,[NSString stringWithFormat:@"%c", ClimaconHaze],nil];
        
        iconName = [dayConditions objectAtIndex:[condition integerValue]-1];
    }
    else
    {
        NSArray *nightConditions = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%c", ClimaconMoon]
                                    ,[NSString stringWithFormat:@"%c", ClimaconCloudMoon]
                                    ,[NSString stringWithFormat:@"%c", ClimaconCloudMoon]
                                    ,[NSString stringWithFormat:@"%c", ClimaconCloudMoon]
                                    ,[NSString stringWithFormat:@"%c", ClimaconCloud]
                                    ,[NSString stringWithFormat:@"%c", ClimaconCloudMoon]
                                    ,[NSString stringWithFormat:@"%c", ClimaconCloudUp]
                                    ,[NSString stringWithFormat:@"%c", ClimaconCloudDown]
                                    ,[NSString stringWithFormat:@"%c", ClimaconCloudUp]
                                    ,[NSString stringWithFormat:@"%c", ClimaconThermometerLow]
                                    ,[NSString stringWithFormat:@"%c", ClimaconThermometerHigh]
                                    ,[NSString stringWithFormat:@"%c", ClimaconWind]
                                    ,[NSString stringWithFormat:@"%c", ClimaconWind]
                                    ,[NSString stringWithFormat:@"%c", ClimaconLightningMoon]
                                    ,[NSString stringWithFormat:@"%c", ClimaconLightning]
                                    ,[NSString stringWithFormat:@"%c", ClimaconLightning]
                                    ,[NSString stringWithFormat:@"%c", ClimaconWind]
                                    ,[NSString stringWithFormat:@"%c", ClimaconWind]
                                    ,[NSString stringWithFormat:@"%c", ClimaconWind]
                                    ,[NSString stringWithFormat:@"%c", ClimaconHaze]
                                    ,[NSString stringWithFormat:@"%c", ClimaconHaze]
                                    ,[NSString stringWithFormat:@"%c", ClimaconHazeMoon]
                                    ,[NSString stringWithFormat:@"%c", ClimaconFog]
                                    ,[NSString stringWithFormat:@"%c", ClimaconFog]
                                    ,[NSString stringWithFormat:@"%c", ClimaconFogMoon]
                                    ,[NSString stringWithFormat:@"%c", ClimaconFog]
                                    ,[NSString stringWithFormat:@"%c", ClimaconRainMoon]
                                    ,[NSString stringWithFormat:@"%c", ClimaconCloud]
                                    ,[NSString stringWithFormat:@"%c", ClimaconDrizzle]
                                    ,[NSString stringWithFormat:@"%c", ClimaconDownpour]
                                    ,[NSString stringWithFormat:@"%c", ClimaconRain]
                                    ,[NSString stringWithFormat:@"%c", ClimaconSleet]
                                    ,[NSString stringWithFormat:@"%c", ClimaconDownpour]
                                    ,[NSString stringWithFormat:@"%c", ClimaconSnow]
                                    ,[NSString stringWithFormat:@"%c", ClimaconHail]
                                    ,[NSString stringWithFormat:@"%c", ClimaconSnow]
                                    ,[NSString stringWithFormat:@"%c", ClimaconTornado]
                                    ,[NSString stringWithFormat:@"%c", ClimaconMoon]
                                    ,[NSString stringWithFormat:@"%c", ClimaconWind]
                                    ,[NSString stringWithFormat:@"%c", ClimaconHaze],nil];
        
        iconName = [nightConditions objectAtIndex:[condition integerValue]-1];
    }
    

    return iconName;
}

- (NSString *)descriptionForCondition:(NSString *)condition
{
       NSString *description;
    
    NSArray *conditionDescription = [NSArray arrayWithObjects:@"صاف"
                                ,@"کمي ابري"
                                ,@"قسمتي ابري"
                                ,@"نيمه ابري"
                                ,@"ابري"
                                ,@"بتدريج ابري"
                                ,@"رشدابردرارتفاعات"
                                ,@"کاهش ابر"
                                ,@"افزایش ابر"
                                ,@"کاهش دما"
                                ,@"افزايش دما"
                                ,@"کاهش باد"
                                ,@"افزايش باد"
                                ,@"رعدوبرق"
                                ,@"رگبارورعدوبرق"
                                ,@"رعدوبرق بابارش"
                                ,@"وزش باد"
                                ,@"بادوگردوخاک"
                                ,@"وزش بادشديد"
                                ,@"غبارآلود"
                                ,@"غبارمحلي"
                                ,@"غبارصبحگاهي"
                                ,@"مه آلود"
                                ,@"مه رقيق"
                                ,@"مه صبحگاهي"
                                ,@"مه غليظ"
                                ,@"بارش پراکنده"
                                ,@"ابری با احتمال بارش"
                                ,@"بارش خفيف باران"
                                ,@"رگبار باران"
                                ,@"بارش باران"
                                ,@"بارش باران و برف"
                                ,@"رگبار برف"
                                ,@"بارش برف"
                                ,@"تگرگ"
                                ,@"کولاک برف"
                                ,@"توفان و گردوخاک"
                                ,@"دریا آرام"
                                ,@"دریا مواج"
                                ,@"هوا آلوده"
                                     ,nil];
    
    return description = [conditionDescription objectAtIndex:[condition integerValue]-1];

}
@end
