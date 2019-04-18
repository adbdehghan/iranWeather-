//
//  MainView.m
//  Iran Weather
//
//  Created by aDb on 12/18/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import "MainViewController.h"
#import "DataDownloader.h"
#import "WeatherData.h"
#import "PagingScrollView.h"
#import "WeatherView.h"
#import "UIImage+ImageEffects.h"
#import "AddLocationViewController.h"
#import "StateManager.h"
#import "Gradient.h"
#import "DBManager.h"
#import "SettingsViewController.h"
#import "CHTumblrMenuView.h"
#import "WarningsViewController.h"
#import "Reachability.h"
#import "DXAlertView.h"
#import "PendulumView.h"
#import "AboutViewController.h"
#import "XMLReader.h"


#define kLOCAL_WEATHER_VIEW_TAG         0

@interface MainViewController ()
{
    CHTumblrMenuView *menuView;
    RNFrostedSidebar *callout;
    NSString *cityId;
    NSString *cityName;
    NSString *cityCode;
}
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
//  Redefinition of location manager
@property (strong, nonatomic) CLLocationManager     *locationManager;

//  Dictionary of all weather data being managed by the app
@property (strong, nonatomic) NSMutableDictionary   *weatherData;

//  Ordered-List of weather tags
@property (strong, nonatomic) NSMutableArray        *weatherTags;

@property (assign, nonatomic) BOOL                  isScrolling;

@property (strong, nonatomic) NSMutableDictionary   *citiesDictionary;

@property (strong, nonatomic) NSDictionary   *citiesCodeDictionary;

@property (strong, nonatomic) NSMutableDictionary   *citiesDictionaryToSave;

@property (strong, nonatomic) NSMutableDictionary   *cityInfo;
// -----
// @name View Controllers
// -----

//  View controller for changing settings
//@property (strong, nonatomic) SOLSettingsViewController     *settingsViewController;

//  View controller for adding new locations
@property (strong, nonatomic) AddLocationViewController  *addLocationViewController;

// -----
// @name Subviews
// -----

//  Dark, semi-transparent view to sit above the homescreen
@property (strong, nonatomic) UIView              *darkenedBackgroundView;

//  Label displaying the Sol° logo
@property (strong, nonatomic) UILabel             *solLogoLabel;

//  Label displaying the name of the app
@property (strong, nonatomic) UILabel             *solTitleLabel;

//  Contains blurred screenshots of this controller's view when transitioning to another controller
@property (strong, nonatomic)  UIImageView        *blurredOverlayView;

//  Buton used to transition to the settings view controller
@property (strong, nonatomic) UIButton            *settingsButton;

//  Button used to transition to the add location view controller
@property (strong, nonatomic) UIButton            *addLocationButton;

//  Page control displaying the number of pages managed by the paging scroll view
@property (strong, nonatomic) UIPageControl       *pageControl;

//  Paging scroll view to manage weather views
@property (strong, nonatomic) PagingScrollView *pagingScrollView;

@property (strong, nonatomic) DataDownloader *getData;

@property(strong) Reachability * googleReach;


@end

@implementation MainViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self StartApp];
    
    self.googleReach = [Reachability reachabilityWithHostname:@"www.bing.com"];
    
    self.googleReach.reachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"GOOGLE Block Says Reachable(%@)", reachability.currentReachabilityString];
        NSLog(@"%@", temp);
        
        // to update UI components from a block callback
        // you need to dipatch this to the main thread
        // this uses NSOperationQueue mainQueue
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
        }];
    };
    
    self.googleReach.unreachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"GOOGLE Block Says Unreachable(%@)", reachability.currentReachabilityString];
        NSLog(@"%@", temp);
        
        if ([StateManager local]==local)
        {
            [self performSelectorInBackground:@selector(checkForCityName) withObject:nil];
        }
        else
        {
            NSMutableArray *settingArray=[DBManager selectSetting];
            if ([settingArray count]>0) {
                Settings *setting = [settingArray objectAtIndex:0];
                cityName = setting.cityInfo;
                
                [self performSelectorInBackground:@selector(checkForCityName) withObject:nil];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            for(WeatherView *weatherView in self.pagingScrollView.subviews) {
                
                //  weatherView.conditionIconLabel.text = @"☹";
                weatherView.locationLabel.text = @"عدم اتصال به اینترت ";
            }
            
        });
    };
    
    [self.googleReach startNotifier];
    
    [self performSelectorInBackground:@selector(setBlurredOverlayThread) withObject:nil];
    
}

-(void)checkForCityName
{
    NSString *filePath;
    filePath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"xml"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    self.citiesCodeDictionary = [self serializedData:fileData];
    self.citiesCodeDictionary = [self.citiesCodeDictionary valueForKey:@"cities"];
    self.citiesCodeDictionary = [self.citiesCodeDictionary valueForKey:@"city"];
    [NSThread sleepForTimeInterval:1];
    //cityName = [cityName stringByReplacingOccurrencesOfString:@"مهرآباد" withString:@""];
    
    while ([cityName isEqual:@""] && cityName!=nil)
    {
        
    }
    if (cityName!=nil) {
        for (NSString* item in self.citiesCodeDictionary)
        {
            NSString *name =[[item valueForKey:@"name"]valueForKey:@"text"];
            
            if ([cityName rangeOfString:name options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                cityCode =[[item valueForKey:@"id"]valueForKey:@"text"];
                [self initializeAlertView];
                break;
            }
        }
    }
}
-(void)setBlurredOverlayThread
{
    [NSThread sleepForTimeInterval:.7];
    [self setBlurredOverlayImage];
}

-(void)initializeAlertView
{
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"عدم اتصال به اینترنت" contentText:@" آیا برای آگاهی از وضعیت آب و هوای این شهر از ارسال پیامک استفاده شود؟ (هزینه ۵۰ تومان)" leftButtonTitle:@"خیر" rightButtonTitle:@"بله"];
    [alert show];
    alert.leftBlock = ^() {
        NSLog(@"left button clicked");
    };
    alert.rightBlock = ^() {
        NSLog(@"right button clicked");
        [self SendSMS];
    };
    alert.dismissBlock = ^() {
        NSLog(@"Do something interesting after dismiss block");
    };
}

-(void)SendSMS
{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageComposer =[[MFMessageComposeViewController alloc] init];
        
        NSString *message =cityCode;
        messageComposer.recipients = [NSArray arrayWithObjects:@"20134", nil];
        [messageComposer setBody:message];
        messageComposer.messageComposeDelegate = self;
        [self presentViewController:messageComposer animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)StartApp {
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:0];
    
    [self initializeSubviews];
    [self initializeSettingsButton];
    [self initializeAddLocationButton];
    
    self.blurredOverlayView = [[UIImageView alloc]initWithImage:[[UIImage alloc]init]];
    self.blurredOverlayView.alpha = 1.0;
    [self.blurredOverlayView setFrame:self.view.bounds];
    
    
    
    NSMutableArray *settingArray=[DBManager selectSetting];
    
    if ([settingArray count]>0) {
        for (Settings *item in settingArray) {
            
            RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
                if (wasSuccessful) {
                    WeatherData *wd = [WeatherData alloc];
                    [wd fillData:data];
                    
                    self.pageControl.numberOfPages+=1;
                    
                    WeatherView *nonlocalWeatherView = [[WeatherView alloc]initWithFrame:self.view.bounds];
                    
                    //    localWeatherView.local = YES;
                    nonlocalWeatherView.delegate = self;
                    
                    nonlocalWeatherView.tag = [wd.stationCode integerValue];
                    
                    [self.pagingScrollView addSubview:nonlocalWeatherView isLaunch:YES];
                    
                    [self UpdateWeatherViewWithData:wd weatherView:nonlocalWeatherView];
                    
                    
                } else {
                    NSLog( @"Unable to fetch Data. Try again.");
                }
            };
            
            [self.getData requestData:item.settingId
                         withCallback:callback];
            
        }
    }
    
    if([StateManager local] == local) {
        
        [self initializeLocalWeatherView];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cityLocations" ofType:@"plist"];
        self.citiesDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
        
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        self.locationManager.distanceFilter = 4000;
        [self.locationManager setDelegate:self];
        [self.locationManager startUpdatingLocation];
        
        RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
            if (wasSuccessful)
            {
                [self UpdateCityLocationFile:data];
                
            }
        };
        
        [self.getData RequestCitiesList:callback];
        
    }
    else
    {
        
    }
    
    [self initializeMenu];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    NSMutableArray *settingArray=[DBManager selectSetting];
    if ([settingArray count]==0 && [StateManager local] != local)
    {
        self.pageControl.numberOfPages+=1;
        
        WeatherView *nonlocalWeatherView = [[WeatherView alloc]initWithFrame:self.view.bounds];
        
        //    localWeatherView.local = YES;
        nonlocalWeatherView.delegate = self;
        
        nonlocalWeatherView.tag = 404;
        
        [self.pagingScrollView addSubview:nonlocalWeatherView isLaunch:YES];
        //            self.blurredOverlayView.image = [UIImage imageNamed:@"MainImage.png"];
        [self performSelectorInBackground:@selector(setBlurredOverlayThread) withObject:nil];
        [self addLocationButtonPressed];
    }
}

-(void)initializeMenu
{
    
    NSArray *images = @[
                        [UIImage imageNamed:@"warning"],
                        [UIImage imageNamed:@"setting"],
                        [UIImage imageNamed:@"about"],
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        ];
    
    callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    callout.delegate = self;
    callout.showFromRight = YES;
    
}

- (void)UpdateCityLocationFile:(NSMutableDictionary *)data {
    
    self.citiesDictionaryToSave = [[NSMutableDictionary alloc]init];
    self.citiesDictionaryToSave = data;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cityLocations" ofType:@"plist"];
    [self.citiesDictionaryToSave writeToFile:filePath atomically:YES];
}


- (CGFloat)directMetersFromCoordinate:(CLLocationCoordinate2D)from toCoordinate:(CLLocationCoordinate2D)to {
    
    static const double DEG_TO_RAD = 0.017453292519943295769236907684886;
    static const double EARTH_RADIUS_IN_METERS = 6372797.560856;
    
    double latitudeArc  = (from.latitude - to.latitude)* DEG_TO_RAD;
    double longitudeArc = (from.longitude - to.longitude) * DEG_TO_RAD;
    //    return  sqrt(fabsf((latitudeArc*latitudeArc)-(longitudeArc*longitudeArc)));
    double latitudeH = sin(latitudeArc * 0.5);
    latitudeH *= latitudeH;
    double lontitudeH = sin(longitudeArc * 0.5);
    lontitudeH *= lontitudeH;
    double tmp = cos(from.latitude*DEG_TO_RAD) * cos(to.latitude*DEG_TO_RAD);
    return EARTH_RADIUS_IN_METERS * 2.0 * asin(sqrt(latitudeH + tmp*lontitudeH));
}

- (void)initializeSubviews
{
    //  Initialize the paging scroll wiew
    self.pagingScrollView = [[PagingScrollView alloc]initWithFrame:self.view.bounds];
    self.pagingScrollView.delegate = self;
    self.pagingScrollView.bounces = NO;
    [self.view addSubview:self.pagingScrollView];
    
    //  Initialize the page control
    self.pageControl = [[UIPageControl alloc]initWithFrame: CGRectMake(0, CGRectGetHeight(self.view.bounds) - (self.view.bounds.size.height*.214),
                                                                       CGRectGetWidth(self.view.bounds), 32)];
    [self.pageControl setHidesForSinglePage:YES];
    [self.pageControl setUserInteractionEnabled:NO];
    [self.view addSubview:self.pageControl];
}

- (void)initializeAddLocationButton
{
    self.addLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UILabel *plusLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 20, 44, 44)];
    [plusLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:40]];
    [plusLabel setTextAlignment:NSTextAlignmentCenter];
    [plusLabel setTextColor:[UIColor whiteColor]];
    [plusLabel setText:@"+"];
    [self.addLocationButton addSubview:plusLabel];
    [self.addLocationButton setFrame:CGRectMake(0, 6, 44, 44)];
    [self.addLocationButton setShowsTouchWhenHighlighted:YES];
    [self.addLocationButton addTarget:self action:@selector(addLocationButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addLocationButton];
}

- (void)initializeSettingsButton
{
    self.settingsButton = [[UIButton alloc]init];
    [self.settingsButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [self.settingsButton setTintColor:[UIColor whiteColor]];
    [self.settingsButton setFrame:CGRectMake(self.view.bounds.size.width-49, 29, 44, 44)];
    [self.settingsButton setShowsTouchWhenHighlighted:YES];
    [self.settingsButton addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.settingsButton];
}

- (void)initializeLocalWeatherView
{
    WeatherView *localWeatherView = [[WeatherView alloc]initWithFrame:self.view.bounds];
    
    //    localWeatherView.local = YES;
    localWeatherView.delegate = self;
    self.pageControl.numberOfPages += 1;
    localWeatherView.tag = kLOCAL_WEATHER_VIEW_TAG;
    [self.pagingScrollView addSubview:localWeatherView isLaunch:YES];
    
}

#pragma mark Using a SOLMainViewController

- (void)showBlurredOverlayView:(BOOL)show
{
    [UIView animateWithDuration:0.25 animations: ^ {
        self.blurredOverlayView.alpha = (show)? 1.0 : 0.0;;
    }];
}

- (void)setBlurredOverlayImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        
        //  Take a screen shot of this controller's view
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [self.view.layer renderInContext:context];
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        //  Blur the screen shot
        UIImage *blurred = [image applyBlurWithRadius:20
                                            tintColor:[UIColor colorWithWhite:0.15 alpha:0.5]
                                saturationDeltaFactor:1.5
                                            maskImage:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            //  Set the blurred overlay view's image with the blurred screenshot
            self.blurredOverlayView.image = blurred;
        });
    });
}


#pragma mark AddLocationButton Methods

- (void)addLocationButtonPressed
{
    [self performSegueWithIdentifier:@"MainToAddLocation" sender:self];
}

-(void)settingsButtonPressed
{
    [self performSegueWithIdentifier:@"mainToSettings" sender:self];
}

-(void)menuButtonPressed
{
    // [menuView show];
    [callout show];
}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    //  Only add the local weather view if location services authorized
    if(status == kCLAuthorizationStatusAuthorized) {
        
    }

    else if(status == kCLAuthorizationStatusNotDetermined)
    {
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    else if(status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        //  If location services are disabled and no saved weather data is found, show the add location view controller



        if([self.pagingScrollView.subviews count] == 0) {
     
            [self performSegueWithIdentifier:@"MainToAddLocation" sender:self];
        }
        else
        {
            for (WeatherView* localView in self.pagingScrollView.subviews) {
                
                if (localView.tag == 0) {
                    [self.pagingScrollView removeSubview:localView];
                    self.pageControl.numberOfPages -= 1;
                }
            }
            if([self.pagingScrollView.subviews count]==0)
            {
                [self performSegueWithIdentifier:@"MainToAddLocation" sender:self];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //  If the local weather view has no data and a location could not be determined, show a failure message
    for(WeatherView *weatherView in self.pagingScrollView.subviews) {
        if (weatherView.tag==0)
        {
            //   weatherView.conditionIconLabel.text = @"☹";
            weatherView.locationLabel.text = @"موقعیت پیدا نشد!";
        }

    }
}

- (void)UpdateWeatherViewWithData:(WeatherData *)wd weatherView:(WeatherView *)weatherView
{
    for (UIView *item in weatherView.conditionIconLabel.subviews) {
        if (item.tag == 12) {
            [item removeFromSuperview];
        }
    }
    weatherView.isDay = [wd isDay];
    weatherView.locationLabel.text = wd.stationName;
    weatherView.updatedLabel.text = wd.lastUpdate;
    
    weatherView.feelsTempLabel.text = [self ConvertTemperature:wd.feelsLikeTemp];
    
    weatherView.currentTemperatureLabel.text = [self ConvertTemperature:wd.currentTemperature];
    weatherView.conditionDescriptionLabel.text = wd.conditionDescription;
    weatherView.conditionIconLabel.text = wd.icon;
    if (![wd.humidity isEqual:@""]) {
        weatherView.humidityLabel.text = [wd.humidity stringByAppendingString:@"%"];
    }
    
    weatherView.horizentalViewUnitLabel.text = @"Km";
    
    weatherView.preasureUnitLabel.text = @"hpa";
    
    if ([StateManager speedScale]==msScale) {
        weatherView.windSpeedUnitLabel.text = @"m/s";
    }
    else
        weatherView.windSpeedUnitLabel.text = @"Km/h";
    
    
    weatherView.preasureLabel.text = wd.preasure;
    
    if ([wd.windSpeed isEqualToString:@"0.0"])
    {
        weatherView.windSpeedLabel.text = @"آرام";
        weatherView.windSpeedUnitLabel.text = @"";
    }
    else
        weatherView.windSpeedLabel.text = [self ConvertSpeed:wd.windSpeed];
    
    weatherView.horizentalViewLabel.text = [NSString stringWithFormat:@"%.0f",floor([wd.horizentalView integerValue]*.001)];
    weatherView.forecastIconOneLabel.text = wd.forecastIconOneLabel;
    weatherView.forecastIconTwoLabel.text = wd.forecastIconTwoLabel;
    weatherView.forecastIconThreeLabel.text = wd.forecastIconThreeLabel;
    weatherView.forecastDayOneLabel.text = wd.conditionDescription1;
    weatherView.forecastDayTwoLabel.text = wd.conditionDescription2;
    weatherView.forecastDayThreeLabel.text = wd.conditionDescription3;
    
    weatherView.highTemperatureLabel1.text =[self ConvertTemperatureForForcasts:wd.maxTemperature1];
    weatherView.minTemperatureLabel1.text =[self ConvertTemperatureForForcasts:wd.minTemperature1];
    
    weatherView.highTemperatureLabel2.text = [self ConvertTemperatureForForcasts:wd.maxTemperature2];
    weatherView.minhTemperatureLabel2.text = [self ConvertTemperatureForForcasts:wd.minTemperature2];
    
    weatherView.highTemperatureLabel3.text = [self ConvertTemperatureForForcasts:wd.maxTemperature3];
    weatherView.minhTemperatureLabel3.text = [self ConvertTemperatureForForcasts:wd.minTemperature3];
    
    weatherView.forcastDaylabel1.text = wd.forcastDaylabel1;
    weatherView.forcastDaylabel2.text = wd.forcastDaylabel2;
    weatherView.forcastDaylabel3.text = wd.forcastDaylabel3;
    
    [weatherView spinLayer:weatherView.windDirectionContainer.layer duration:.7 direction:-1 degrees:[wd.windDirection floatValue]+180 wind:wd.windSpeed];
    [weatherView setWeatherCondition:wd.conditionDescriptionForVisualEffect];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    
    CLLocationCoordinate2D currentCoordinates = location.coordinate;
    
    self.cityInfo = [[NSMutableDictionary alloc]init];
    
    for ( NSString *item in self.citiesDictionary) {
        
        CLLocationCoordinate2D retCoordinates;
        
        retCoordinates.latitude=[[[self.citiesDictionary valueForKey:item]valueForKey:@"lat"]doubleValue];
        retCoordinates.longitude=[[[self.citiesDictionary valueForKey:item]valueForKey:@"lon"]doubleValue];
        double distance=[self directMetersFromCoordinate:currentCoordinates toCoordinate:retCoordinates];
        NSNumber *tempNumber = [[NSNumber alloc] initWithFloat:distance];
        
        [self.cityInfo setValue:tempNumber forKey:[[self.citiesDictionary valueForKey:item]valueForKey:@"id"]];
        
    }
    
    NSNumber *base = [[self.cityInfo allValues]objectAtIndex:0];
    
    
    for (NSString *item in self.cityInfo) {
        
        NSNumber *condition =[self.cityInfo valueForKey:item];
        
        if( [condition floatValue] < [base floatValue]&&![item isEqual:@"99331"])
        {
            base = condition;
            cityId = item;
        }
    }
    
    for (NSString* item in self.citiesDictionary) {
        
        if ([[[self.citiesDictionary valueForKey:item]valueForKey:@"id"] isEqualToString:cityId]) {
            cityName = [[self.citiesDictionary valueForKey:item]valueForKey:@"name"];
        }
        
    }
    
    if (![cityId isEqual:@""]) {
        
        RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
            if (wasSuccessful) {
                
                
                WeatherData *wd = [WeatherData alloc];
                [wd fillData:data];
                
                for(WeatherView *weatherView in self.pagingScrollView.subviews) {
                    if (weatherView.tag==0) {
                        [self UpdateWeatherViewWithData:wd weatherView:weatherView];
//                        weatherView.locationLabel.text=[weatherView.locationLabel.text stringByAppendingString:@"➣"];
                    }
                }
                
            } else {
                
                for(WeatherView *weatherView in self.pagingScrollView.subviews) {
                    
                    // weatherView.conditionIconLabel.text = @"☹";
                    weatherView.locationLabel.text = @"وجود مشکل در سرور";
                    
                }
                NSLog( @"Unable to fetch Data. Try again.");
            }
        };
        
        [self.getData requestData:cityId
                     withCallback:callback];
        
    }
    
    
}


-(NSString*)ConvertTemperature:(NSString*)temperature
{
    if (![temperature isEqual:@""]) {
        if ([StateManager temperatureScale]==CelsiusScale) {
            return [temperature stringByAppendingString:@" ℃"];
        }
        else
        {
            double temp = [temperature doubleValue];
            return [[NSString stringWithFormat:@"%.0f",((9/5)*temp)+32] stringByAppendingString:@" ℉"];
        }
    }
    return @"";
}

-(NSString*)ConvertTemperatureForForcasts:(NSString*)temperature
{
    if (![temperature isEqual:@""]) {
        if ([StateManager temperatureScale]==CelsiusScale) {
            return temperature;
        }
        else
        {
            double temp = [temperature doubleValue];
            return [[NSString stringWithFormat:@"%.0f",((9/5)*temp)+32] stringByAppendingString:@"º"];
        }
    }
    return @"";
}

-(NSString*)ConvertSpeed:(NSString*)speed
{
    if ([StateManager speedScale]==msScale) {
        return speed;
    }
    else
    {
        double speedTemp = [speed doubleValue];
        return [NSString stringWithFormat:@"%.0f",3.6 * speedTemp];
    }
}

- (NSDictionary *)serializedData:(NSData *)data
{
    NSError *error = nil;
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                   error:&error];
    return dict;
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isScrolling = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isScrolling = NO;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.isScrolling = YES;
    
    //  Update the current page for the page control
    float fractionalPage = self.pagingScrollView.contentOffset.x / self.pagingScrollView.frame.size.width;
    self.pageControl.currentPage = lround(fractionalPage);
}

#pragma mark - RNFrostedSidebarDelegate

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %lu",(unsigned long)index);
    if (index == 1) {
        [self settingsButtonPressed];
        [sidebar dismissAnimated:YES completion:nil];
    }
    else if(index==0)
        [self performSegueWithIdentifier:@"MainToWarnings" sender:self];
    else if(index==2)
        [self performSegueWithIdentifier:@"MainToAbout" sender:self];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
    }
    else {
        [self.optionIndices removeIndex:index];
    }
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqual:@"MainToAddLocation"]) {
        AddLocationViewController *detination = [segue destinationViewController];
        detination.blurredOverlayView = self.blurredOverlayView;
    }
    else if([segue.identifier isEqual:@"mainToSettings"])
    {
        SettingsViewController *detination = [segue destinationViewController];
        detination.blurredOverlayView = self.blurredOverlayView;
        detination.locations =[DBManager selectSetting] ;
    }
    else if ([segue.identifier isEqual:@"MainToWarnings"])
    {
        WarningsViewController *detination = [segue destinationViewController];
        detination.blurredOverlayView = self.blurredOverlayView;
    }
    
    else if ([segue.identifier isEqual:@"MainToAbout"])
    {
        AboutViewController *detination = [segue destinationViewController];
        detination.blurredOverlayView = self.blurredOverlayView;
    }
}

@end
