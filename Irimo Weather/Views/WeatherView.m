//
//  WeatherView.m
//  Iran Weather
//
//  Created by aDb on 12/19/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import "WeatherView.h"
#import "Climacons.h"
#import "UIView+AutoLayout.h"
#import "SnowFall.h"
#import "RainFall.h"
#import "Gradient.h"
#import "PendulumView.h"


// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)
@interface WeatherView()
{
    UIView *humidityView,*currentTempretureView,*windSpeedView,*windDirectionView,*feelsTempView,*horizentalView,*pressureView,*descriptionView,*forcastDayOneView,*forcastDayTwoView,*forcastDayThreeView;
    
}
@property (strong, nonatomic) UIImageView         *blurredOverlayView;

@property (strong, nonatomic) UIImageView         *backgroundImage;

@property (strong, nonatomic) UIImageView         *backgroundImage2;

@property (strong, nonatomic) UIView              *container;

//  Light-Colored ribbon to display temperatures and forecasts on

@property (strong, nonatomic) UIView              *ribbonDayOne;

@property (strong, nonatomic) UIView              *ribbonDayTwo;

@property (strong, nonatomic) UIView              *ribbonDayThree;


//  Displays the time the weather data for this view was last updated
@property (strong, nonatomic) UILabel             *updatedLabel;

//  Displays the icon for current conditions
@property (strong, nonatomic) UILabel             *conditionIconLabel;

//  Displays the description of current conditions
@property (strong, nonatomic) UILabel             *conditionDescriptionLabel;

//  Displays the location whose weather data is being represented by this weather view
@property (strong, nonatomic) UILabel             *locationLabel;

//  Displayes the current temperature
@property (strong, nonatomic) UILabel             *currentTemperatureLabel;


@property (strong, nonatomic) UILabel             *humidityLabel;

@property (strong, nonatomic) UILabel             *preasureLabel;

@property (strong, nonatomic) UILabel             *horizentalViewLabel;

@property (strong, nonatomic) UILabel             *windSpeedLabel;

@property (strong, nonatomic) UILabel             *windSpeedUnitLabel;

@property (strong, nonatomic) UILabel             *preasureUnitLabel;

@property (strong, nonatomic) UILabel             *horizentalViewUnitLabel;

@property (strong, nonatomic) UILabel             *feelsTempLabel;

@property (strong, nonatomic) NSString            *windDirectionAngle;

//  Displays the day of the week for the first forecast snapshot
@property (strong, nonatomic) UILabel             *forecastDayOneLabel;

//  Displays the day of the week for the second forecast snapshot
@property (strong, nonatomic) UILabel             *forecastDayTwoLabel;

//  Displays the day of the week for the third forecast snapshot
@property (strong, nonatomic) UILabel             *forecastDayThreeLabel;

//  Displays the icon representing the predicted conditions for the first forecast snapshot
@property (strong, nonatomic) UILabel             *forecastIconOneLabel;

//  Displays the icon representing the predicted conditions for the second forecast snapshot
@property (strong, nonatomic) UILabel             *forecastIconTwoLabel;

//  Displays the icon representing the predicted conditions for the third forecast snapshot
@property (strong, nonatomic) UILabel             *forecastIconThreeLabel;

@property (strong, nonatomic) UILabel             *highTemperatureLabel1;

@property (strong, nonatomic) UILabel             *highTemperatureLabel2;

@property (strong, nonatomic) UILabel             *highTemperatureLabel3;

@property (strong, nonatomic) UILabel             *minTemperatureLabel1;

@property (strong, nonatomic) UILabel             *minhTemperatureLabel2;

@property (strong, nonatomic) UILabel             *minhTemperatureLabel3;

@property (strong, nonatomic) UILabel             *forcastDaylabel1;

@property (strong, nonatomic) UILabel             *forcastDaylabel2;

@property (strong, nonatomic) UILabel             *forcastDaylabel3;

@property (strong, nonatomic) UIView              *windDirectionContainer;


@end

#pragma mark - WeatherView Implementation

@implementation WeatherView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        
        //  Initialize Container
        self.container = [[UIView alloc]initWithFrame:self.bounds];
        [self.container setBackgroundColor:[UIColor clearColor]];
        [self.container setClipsToBounds:YES];
        [self addSubview:self.container];
        
        Gradient *gr = [[Gradient alloc]init];
        UIImageView *uv = [[UIImageView alloc]initWithImage:[gr CreateGradient:self.container.frame.size.width Height:self.container.frame.size.height]];
        
        [self.container addSubview:uv];
        
        //self.blurredOverlayView=[[UIImageView alloc]init];
        
        [self.backgroundImage2 setFrame:CGRectMake(0, 0, self.container.bounds.size.width, self.container.bounds.size.height)];
        //        self.backgroundImage2.alpha = .5;
        
        
        
        self.backgroundImage2.contentMode = UIViewContentModeScaleAspectFill;
        [self.backgroundImage2 setClipsToBounds:YES];
        
        
        self.backgroundImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainImage.png"]];
        [self.backgroundImage setFrame:CGRectMake(0, 0, self.container.bounds.size.width, self.container.bounds.size.height)];
        
        self.backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.backgroundImage setClipsToBounds:YES];
        [self.container addSubview:self.backgroundImage];
        
        //        [self.backgroundImage autoPinEdge:(ALEdge)ALEdgeRight toEdge:(ALEdge)ALEdgeRight ofView:self.container];
        
        //  Initialize Activity Indicator
        
        
        //  Initialize Labels
        [self initializeConditionDescriptionLabel];
        [self initializeLocationLabel];
        [self initializeForcastContainar];
        [self initializeUpdatedLabel];
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
            if ([[UIScreen mainScreen] bounds].size.height == 568)
            {
                [self initializeCirclesForIphone5s];
                
            }
            else if([[UIScreen mainScreen] bounds].size.height == 667)
            {
                [self initializeCirclesForIphone6];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 736)
            {
                [self initializeCirclesForIphone6plus];
                
            }
            else
            {
                [self initializeCirclesForIphone4s];
            }
        }
        else
        {
            [self initializeCirclesForIpad];
        }
    }
    return self;
}

-(void)AddActivityIndicator:(UIView*)view
{
    PendulumView *pendulum = [[PendulumView alloc] initWithFrame:CGRectMake(view.bounds.size.width/2-50, view.frame.size.height/2, 100, 40) ballColor:[UIColor whiteColor] ballDiameter:14];
    pendulum.tag=12;
    [view addSubview:pendulum];
}

-(void)initializeDayLabels:(NSInteger)fontSize
{
    self.forcastDaylabel1 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayOne.bounds.size.width-55,2, 50, 20)];
    [self.forcastDaylabel1 setAdjustsFontSizeToFitWidth:YES];
    [self.forcastDaylabel1 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.forcastDaylabel1 setBackgroundColor:[UIColor clearColor]];
    [self.forcastDaylabel1 setTextColor:[UIColor whiteColor]];
    [self.forcastDaylabel1 setTextAlignment:NSTextAlignmentCenter];
    
    [self.ribbonDayOne addSubview:self.forcastDaylabel1];
    
    self.forcastDaylabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayTwo.bounds.size.width-55,2, 50, 20)];
    [self.forcastDaylabel2 setAdjustsFontSizeToFitWidth:YES];
    [self.forcastDaylabel2 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.forcastDaylabel2 setBackgroundColor:[UIColor clearColor]];
    [self.forcastDaylabel2 setTextColor:[UIColor whiteColor]];
    [self.forcastDaylabel2 setTextAlignment:NSTextAlignmentCenter];
    
    [self.ribbonDayTwo addSubview:self.forcastDaylabel2];
    
    self.forcastDaylabel3 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayThree.bounds.size.width-55,2, 50, 20)];
    [self.forcastDaylabel3 setAdjustsFontSizeToFitWidth:YES];
    [self.forcastDaylabel3 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.forcastDaylabel3 setBackgroundColor:[UIColor clearColor]];
    [self.forcastDaylabel3 setTextColor:[UIColor whiteColor]];
    [self.forcastDaylabel3 setTextAlignment:NSTextAlignmentCenter];
    
    [self.ribbonDayThree addSubview:self.forcastDaylabel3];
    
}

-(void)initializeForcastTempLabels:(NSInteger)fontSize Y1:(NSInteger)y1 Y2:(NSInteger)y2 Size:(NSInteger)size
{
    self.highTemperatureLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayOne.bounds.size.width-size-4,y1, size,size)];
    [self.highTemperatureLabel1 setAdjustsFontSizeToFitWidth:YES];
    [self.highTemperatureLabel1 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.highTemperatureLabel1 setBackgroundColor:[UIColor clearColor]];
    [self.highTemperatureLabel1 setTextColor:[UIColor redColor]];
    [self.highTemperatureLabel1 setTextAlignment:NSTextAlignmentCenter];
    self.highTemperatureLabel1.alpha = .65;
    [self.ribbonDayOne addSubview:self.highTemperatureLabel1];
    
    self.highTemperatureLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayTwo.bounds.size.width-size-4,y1, size, size)];
    [self.highTemperatureLabel2 setAdjustsFontSizeToFitWidth:YES];
    [self.highTemperatureLabel2 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.highTemperatureLabel2 setBackgroundColor:[UIColor clearColor]];
    [self.highTemperatureLabel2 setTextColor:[UIColor redColor]];
    [self.highTemperatureLabel2 setTextAlignment:NSTextAlignmentCenter];
    self.highTemperatureLabel2.alpha = .65;
    [self.ribbonDayTwo addSubview:self.highTemperatureLabel2];
    
    self.highTemperatureLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayThree.bounds.size.width-size-4,y1, size, size)];
    [self.highTemperatureLabel3 setAdjustsFontSizeToFitWidth:YES];
    [self.highTemperatureLabel3 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.highTemperatureLabel3 setBackgroundColor:[UIColor clearColor]];
    [self.highTemperatureLabel3 setTextColor:[UIColor redColor]];
    [self.highTemperatureLabel3 setTextAlignment:NSTextAlignmentCenter];
    self.highTemperatureLabel3.alpha = .65;
    [self.ribbonDayThree addSubview:self.highTemperatureLabel3];
    
    
    self.minTemperatureLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayOne.bounds.size.width-size-4,y2, size, size)];
    [self.minTemperatureLabel1 setAdjustsFontSizeToFitWidth:YES];
    [self.minTemperatureLabel1 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.minTemperatureLabel1 setBackgroundColor:[UIColor clearColor]];
    [self.minTemperatureLabel1 setTextColor:[UIColor blueColor]];
    [self.minTemperatureLabel1 setTextAlignment:NSTextAlignmentCenter];
    self.minTemperatureLabel1.alpha = .7;
    [self.ribbonDayOne addSubview:self.minTemperatureLabel1];
    
    self.minhTemperatureLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayTwo.bounds.size.width-size-4,y2, size, size)];
    [self.minhTemperatureLabel2 setAdjustsFontSizeToFitWidth:YES];
    [self.minhTemperatureLabel2 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.minhTemperatureLabel2 setBackgroundColor:[UIColor clearColor]];
    [self.minhTemperatureLabel2 setTextColor:[UIColor blueColor]];
    [self.minhTemperatureLabel2 setTextAlignment:NSTextAlignmentCenter];
    self.minhTemperatureLabel2.alpha = .7;
    [self.ribbonDayTwo addSubview:self.minhTemperatureLabel2];
    
    self.minhTemperatureLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayThree.bounds.size.width-size-4,y2, size, size)];
    [self.minhTemperatureLabel3 setAdjustsFontSizeToFitWidth:YES];
    [self.minhTemperatureLabel3 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.minhTemperatureLabel3 setBackgroundColor:[UIColor clearColor]];
    [self.minhTemperatureLabel3 setTextColor:[UIColor blueColor]];
    [self.minhTemperatureLabel3 setTextAlignment:NSTextAlignmentCenter];
    self.minhTemperatureLabel3.alpha = .7;
    [self.ribbonDayThree addSubview:self.minhTemperatureLabel3];
    
}

-(void)initializeWeatherDataLabels:(NSInteger)fontSize labelSize:(NSInteger)size Y:(NSInteger)y
{
    
    self.humidityLabel = [[UILabel alloc]initWithFrame:CGRectMake(2,6, size, size)];
    [self.humidityLabel setAdjustsFontSizeToFitWidth:YES];
    [self.humidityLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.humidityLabel setBackgroundColor:[UIColor clearColor]];
    [self.humidityLabel setTextColor:[UIColor whiteColor]];
    [self.humidityLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    self.preasureLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,y, size, size)];
    [self.preasureLabel setAdjustsFontSizeToFitWidth:YES];
    [self.preasureLabel setFont:[UIFont fontWithName:@"B Koodak" size:14]];
    [self.preasureLabel setBackgroundColor:[UIColor clearColor]];
    [self.preasureLabel setTextColor:[UIColor whiteColor]];
    [self.preasureLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    self.windSpeedLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,y, size, size)];
    [self.windSpeedLabel setAdjustsFontSizeToFitWidth:YES];
    [self.windSpeedLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.windSpeedLabel setBackgroundColor:[UIColor clearColor]];
    [self.windSpeedLabel setTextColor:[UIColor whiteColor]];
    [self.windSpeedLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.horizentalViewLabel = [[UILabel alloc]initWithFrame:CGRectMake(-1,y, size, size)];
    [self.horizentalViewLabel setAdjustsFontSizeToFitWidth:YES];
    [self.horizentalViewLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.horizentalViewLabel setBackgroundColor:[UIColor clearColor]];
    [self.horizentalViewLabel setTextColor:[UIColor whiteColor]];
    [self.horizentalViewLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.feelsTempLabel = [[UILabel alloc]initWithFrame:CGRectMake(-1,y, size, size)];
    [self.feelsTempLabel setAdjustsFontSizeToFitWidth:YES];
    [self.feelsTempLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize-4]];
    [self.feelsTempLabel setBackgroundColor:[UIColor clearColor]];
    [self.feelsTempLabel setTextColor:[UIColor whiteColor]];
    [self.feelsTempLabel setTextAlignment:NSTextAlignmentCenter];
    
}

-(void)initializeUnitLabels:(NSInteger)y X:(NSInteger)x FontSize:(NSInteger)fontSize
{
    self.horizentalViewUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(x,y, 20, 20)];
    [self.horizentalViewUnitLabel setAdjustsFontSizeToFitWidth:YES];
    [self.horizentalViewUnitLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
    [self.horizentalViewUnitLabel setBackgroundColor:[UIColor clearColor]];
    [self.horizentalViewUnitLabel setTextColor:[UIColor whiteColor]];
    [self.horizentalViewUnitLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.preasureUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(x,y, 20, 20)];
    [self.preasureUnitLabel setAdjustsFontSizeToFitWidth:YES];
    [self.preasureUnitLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
    [self.preasureUnitLabel setBackgroundColor:[UIColor clearColor]];
    [self.preasureUnitLabel setTextColor:[UIColor whiteColor]];
    [self.preasureUnitLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    self.windSpeedUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(x,y, 20, 20)];
    [self.windSpeedUnitLabel setAdjustsFontSizeToFitWidth:YES];
    [self.windSpeedUnitLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
    [self.windSpeedUnitLabel setBackgroundColor:[UIColor clearColor]];
    [self.windSpeedUnitLabel setTextColor:[UIColor whiteColor]];
    [self.windSpeedUnitLabel setTextAlignment:NSTextAlignmentCenter];
    
}

-(void)initializeCirclesForIphone4s{
    
    CGFloat circleSize =50;
    
    UIImageView *image1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image1 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image2 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image2 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image3 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image3 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image4 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image4 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image5 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image5 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image6 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image6 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    humidityView = [[UIView alloc]initForAutoLayout];
    
    windDirectionView =[[UIView alloc]initForAutoLayout];
    
    pressureView =[[UIView alloc]initForAutoLayout];
    
    horizentalView =[[UIView alloc]initForAutoLayout];
    
    windSpeedView =[[UIView alloc]initForAutoLayout];
    
    feelsTempView =[[UIView alloc]initForAutoLayout];
    
    UILabel *windDirectionStuff = [[UILabel alloc]initWithFrame:CGRectMake(3,14, 30, 30)];
    
    [windDirectionStuff setAdjustsFontSizeToFitWidth:YES];
    [windDirectionStuff setFont:[UIFont fontWithName:@"B Koodak" size:30]];
    [windDirectionStuff setBackgroundColor:[UIColor clearColor]];
    [windDirectionStuff setTextColor:[UIColor whiteColor]];
    [windDirectionStuff setTextAlignment:NSTextAlignmentRight];
    windDirectionStuff.text = @"-";
    [windDirectionView addSubview:windDirectionStuff];
    
    self.windDirectionContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.windDirectionContainer setCenter:image3.center];
    [self DrawArrow:self.windDirectionContainer];

    
    [self.container addSubview:humidityView];
    [humidityView addSubview:image1];
    
    [self.container addSubview:windSpeedView];
    [windSpeedView addSubview:image2];
    
    [self.container addSubview:windDirectionView];
    [windDirectionView addSubview:image3];
    
    [self.container addSubview:pressureView];
    [pressureView addSubview:image4];
    
    [self.container addSubview:horizentalView];
    [horizentalView addSubview:image5];
    
    [self.container addSubview:feelsTempView];
    [feelsTempView addSubview:image6];
    
    [self initializeCurrentTemperatureLabel:30];
    [self initializeWeatherDataLabels:16 labelSize:circleSize Y:6];
    [self initializeUnitLabels:27 X:24 FontSize:6];
    [self initializeForecastDayLabels:12];
    
    [image1 addSubview:self.humidityLabel];
    [image2 addSubview:self.windSpeedLabel];
    [image3 addSubview:self.windDirectionContainer];
    [image4 addSubview:self.preasureLabel];
    [image5 addSubview:self.horizentalViewLabel];
    [image6 addSubview:self.feelsTempLabel];
    
    [image2 addSubview:self.windSpeedUnitLabel];
    [image4 addSubview:self.preasureUnitLabel];
    [image5 addSubview:self.horizentalViewUnitLabel];
    
    [humidityView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:35];
    [humidityView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-187];
    
    [pressureView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-20];
    [pressureView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-145];
    
    [windSpeedView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-57];
    [windSpeedView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-83];
    
    [windDirectionView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-57];
    [windDirectionView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-15];
    
    
    [horizentalView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-25];
    [horizentalView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:43];
    
    [feelsTempView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:35];
    [feelsTempView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:85];
    
    [self initializeConditionIconLabel:140];
    [self initializeForecastIconLabels:48];
    [self initializeCirclesDescription:12 Y:20];
    [self initializeForcastTempLabels:9 Y1:20 Y2:37 Size:20];
    [self initializeDayLabels:13];
}

-(void)initializeCirclesForIphone6{
    
    CGFloat circleSize =60;
    
    UIImageView *image1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image1 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image2 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image2 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image3 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image3 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image4 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image4 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image5 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image5 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image6 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image6 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    humidityView = [[UIView alloc]initForAutoLayout];
    
    windDirectionView =[[UIView alloc]initForAutoLayout];
    
    pressureView =[[UIView alloc]initForAutoLayout];
    
    horizentalView =[[UIView alloc]initForAutoLayout];
    
    windSpeedView =[[UIView alloc]initForAutoLayout];
    
    feelsTempView =[[UIView alloc]initForAutoLayout];
    
    
    UILabel *windDirectionStuff = [[UILabel alloc]initWithFrame:CGRectMake(7,18, 30, 30)];
    
    [windDirectionStuff setAdjustsFontSizeToFitWidth:YES];
    [windDirectionStuff setFont:[UIFont fontWithName:@"B Koodak" size:30]];
    [windDirectionStuff setBackgroundColor:[UIColor clearColor]];
    [windDirectionStuff setTextColor:[UIColor whiteColor]];
    [windDirectionStuff setTextAlignment:NSTextAlignmentRight];
    windDirectionStuff.text = @"-";
    [windDirectionView addSubview:windDirectionStuff];
    
    self.windDirectionContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.windDirectionContainer setCenter:image3.center];
    [self DrawArrow:self.windDirectionContainer];
    
    
    
    [self.container addSubview:humidityView];
    [humidityView addSubview:image1];
    
    [self.container addSubview:windSpeedView];
    [windSpeedView addSubview:image2];
    
    [self.container addSubview:windDirectionView];
    [windDirectionView addSubview:image3];
    
    [self.container addSubview:pressureView];
    [pressureView addSubview:image4];
    
    [self.container addSubview:horizentalView];
    [horizentalView addSubview:image5];
    
    [self.container addSubview:feelsTempView];
    [feelsTempView addSubview:image6];
    
    [self initializeCurrentTemperatureLabel:30];
    [self initializeWeatherDataLabels:18 labelSize:circleSize Y:6];
    [self initializeUnitLabels:35 X:27 FontSize:8];
    [self initializeForecastDayLabels:14];
    [image1 addSubview:self.humidityLabel];
    [image2 addSubview:self.windSpeedLabel];
    [image3 addSubview:self.windDirectionContainer];
    [image4 addSubview:self.preasureLabel];
    [image5 addSubview:self.horizentalViewLabel];
    [image6 addSubview:self.feelsTempLabel];
    
    [image2 addSubview:self.windSpeedUnitLabel];
    [image4 addSubview:self.preasureUnitLabel];
    [image5 addSubview:self.horizentalViewUnitLabel];
    
    [humidityView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:60];
    [humidityView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-260];
    
    [pressureView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-20];
    [pressureView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-210];
    
    [windSpeedView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-67];
    [windSpeedView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-125];
    
    [windDirectionView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-70];
    [windDirectionView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-30];
    
    
    
    [horizentalView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-30];
    [horizentalView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:62];
    
    [feelsTempView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:60];
    [feelsTempView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:119];
    
    [self initializeConditionIconLabel:167];
    [self initializeForecastIconLabels:68];
    [self initializeCirclesDescription:12 Y:20];
    [self initializeForcastTempLabels:11 Y1:27 Y2:46 Size:20];
    [self initializeDayLabels:13];
}

-(void)initializeCirclesForIphone6plus{
    
    CGFloat circleSize =66;
    
    UIImageView *image1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image1 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image2 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image2 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image3 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image3 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image4 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image4 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image5 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image5 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image6 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image6 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    humidityView = [[UIView alloc]initForAutoLayout];
    
    windDirectionView =[[UIView alloc]initForAutoLayout];
    
    pressureView =[[UIView alloc]initForAutoLayout];
    
    horizentalView =[[UIView alloc]initForAutoLayout];
    
    windSpeedView =[[UIView alloc]initForAutoLayout];
    
    feelsTempView =[[UIView alloc]initForAutoLayout];
    
    
    UILabel *windDirectionStuff = [[UILabel alloc]initWithFrame:CGRectMake(10,21, 30, 30)];
    
    [windDirectionStuff setAdjustsFontSizeToFitWidth:YES];
    [windDirectionStuff setFont:[UIFont fontWithName:@"B Koodak" size:30]];
    [windDirectionStuff setBackgroundColor:[UIColor clearColor]];
    [windDirectionStuff setTextColor:[UIColor whiteColor]];
    [windDirectionStuff setTextAlignment:NSTextAlignmentRight];
    windDirectionStuff.text = @"-";
    [windDirectionView addSubview:windDirectionStuff];
    
    self.windDirectionContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.windDirectionContainer setCenter:image3.center];
    [self DrawArrow:self.windDirectionContainer];
    
    
    [self.container addSubview:humidityView];
    [humidityView addSubview:image1];
    
    [self.container addSubview:windSpeedView];
    [windSpeedView addSubview:image2];
    
    [self.container addSubview:windDirectionView];
    [windDirectionView addSubview:image3];
    
    [self.container addSubview:pressureView];
    [pressureView addSubview:image4];
    
    [self.container addSubview:horizentalView];
    [horizentalView addSubview:image5];
    
    [self.container addSubview:feelsTempView];
    [feelsTempView addSubview:image6];
    
    [self initializeCurrentTemperatureLabel:30];
    [self initializeWeatherDataLabels:20 labelSize:circleSize Y:6];
    [self initializeUnitLabels:40 X:30 FontSize:10];
    [self initializeForecastDayLabels:14];
    
    [image1 addSubview:self.humidityLabel];
    [image2 addSubview:self.windSpeedLabel];
    [image3 addSubview:self.windDirectionContainer];
    [image4 addSubview:self.preasureLabel];
    [image5 addSubview:self.horizentalViewLabel];
    [image6 addSubview:self.feelsTempLabel];
    
    [image2 addSubview:self.windSpeedUnitLabel];
    [image4 addSubview:self.preasureUnitLabel];
    [image5 addSubview:self.horizentalViewUnitLabel];
    
    [humidityView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:50];
    [humidityView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-270];
    
    [pressureView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-35];
    [pressureView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-205];
    
    [windSpeedView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-80];
    [windSpeedView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-112];
    
    [windDirectionView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-75];
    [windDirectionView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-15];
    
    
    
    [horizentalView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-25];
    [horizentalView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:70];
    
    [feelsTempView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:55];
    [feelsTempView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:130];
    
    [self initializeConditionIconLabel:200];
    [self initializeForecastIconLabels:78];
    [self initializeCirclesDescription:16 Y:20];
    [self initializeForcastTempLabels:15 Y1:37 Y2:56 Size:30];
    [self initializeDayLabels:15];
}

-(void)initializeCirclesForIphone5s{
    
    CGFloat circleSize =self.bounds.size.width*0.17;
    
    UIImageView *image1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image1 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image2 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image2 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image3 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image3 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image4 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image4 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image5 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image5 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image6 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image6 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    humidityView = [[UIView alloc]initForAutoLayout];
    
    windDirectionView =[[UIView alloc]initForAutoLayout];
    
    pressureView =[[UIView alloc]initForAutoLayout];
    
    horizentalView =[[UIView alloc]initForAutoLayout];
    
    windSpeedView =[[UIView alloc]initForAutoLayout];
    
    feelsTempView =[[UIView alloc]initForAutoLayout];
    
    
    
    UILabel *windDirectionStuff = [[UILabel alloc]initWithFrame:CGRectMake(4,15, 30, 30)];
    
    [windDirectionStuff setAdjustsFontSizeToFitWidth:YES];
    [windDirectionStuff setFont:[UIFont fontWithName:@"B Koodak" size:30]];
    [windDirectionStuff setBackgroundColor:[UIColor clearColor]];
    [windDirectionStuff setTextColor:[UIColor whiteColor]];
    [windDirectionStuff setTextAlignment:NSTextAlignmentRight];
    windDirectionStuff.text = @"-";
    [windDirectionView addSubview:windDirectionStuff];
    
    self.windDirectionContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.windDirectionContainer setCenter:image3.center];
    
    [self DrawArrow:self.windDirectionContainer];

    
    
    [self.container addSubview:humidityView];
    [humidityView addSubview:image1];
    
    
    
    [self.container addSubview:windSpeedView];
    [windSpeedView addSubview:image2];
    
    
    [self.container addSubview:windDirectionView];
    [windDirectionView addSubview:image3];
    
    
    
    [self.container addSubview:pressureView];
    [pressureView addSubview:image4];
    
    
    [self.container addSubview:horizentalView];
    [horizentalView addSubview:image5];
    
    [self.container addSubview:feelsTempView];
    [feelsTempView addSubview:image6];
    
    [self initializeCurrentTemperatureLabel:30];
    [self initializeUnitLabels:30 X:24 FontSize:8];
    [self initializeWeatherDataLabels:18 labelSize:circleSize Y:5];
    [self initializeForecastDayLabels:13]
    ;
    [image1 addSubview:self.humidityLabel];
    [image2 addSubview:self.windSpeedLabel];
    [image3 addSubview:self.windDirectionContainer];
    [image4 addSubview:self.preasureLabel];
    [image5 addSubview:self.horizentalViewLabel];
    
    [image6 addSubview:self.feelsTempLabel];
    
    [image2 addSubview:self.windSpeedUnitLabel];
    [image4 addSubview:self.preasureUnitLabel];
    [image5 addSubview:self.horizentalViewUnitLabel];
    
    [humidityView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:50];
    [humidityView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-220];
    
    [pressureView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-20];
    [pressureView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-170];
    
    
    [windSpeedView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-62];
    [windSpeedView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-95];
    
    
    [windDirectionView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-59];
    [windDirectionView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-15];
    
    
    [horizentalView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-20];
    [horizentalView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:55];
    
    [feelsTempView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:50];
    [feelsTempView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:100];
    
    
    
    
    [self initializeConditionIconLabel:167];
    [self initializeForecastIconLabels:64];
    [self initializeCirclesDescription:15 Y:20];
    [self initializeForcastTempLabels:12 Y1:27 Y2:46 Size:20];
    [self initializeDayLabels:13];
}

-(void)initializeCirclesForIpad{
    
    CGFloat circleSize =95;
    
    UIImageView *image1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image1 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image2 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image2 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image3 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image3 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image4 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image4 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image5 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image5 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    UIImageView *image6 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [image6 setFrame:CGRectMake(0, 0, circleSize, circleSize)];
    
    humidityView = [[UIView alloc]initForAutoLayout];
    
    windDirectionView =[[UIView alloc]initForAutoLayout];
    
    pressureView =[[UIView alloc]initForAutoLayout];
    
    horizentalView =[[UIView alloc]initForAutoLayout];
    
    windSpeedView =[[UIView alloc]initForAutoLayout];
    
    feelsTempView =[[UIView alloc]initForAutoLayout];
    [self initializeCurrentTemperatureLabel:80];
    
    
    UILabel *windDirectionStuff = [[UILabel alloc]initWithFrame:CGRectMake(23,34, 30, 30)];
    
    [windDirectionStuff setAdjustsFontSizeToFitWidth:YES];
    [windDirectionStuff setFont:[UIFont fontWithName:@"B Koodak" size:30]];
    [windDirectionStuff setBackgroundColor:[UIColor clearColor]];
    [windDirectionStuff setTextColor:[UIColor whiteColor]];
    [windDirectionStuff setTextAlignment:NSTextAlignmentRight];
    windDirectionStuff.text = @"-";
    [windDirectionView addSubview:windDirectionStuff];
    
    self.windDirectionContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.windDirectionContainer setCenter:image3.center];
    [self DrawArrow:self.windDirectionContainer];
    
    
    [self.container addSubview:humidityView];
    [humidityView addSubview:image1];
    
    [self.container addSubview:windSpeedView];
    [windSpeedView addSubview:image2];
    
    [self.container addSubview:windDirectionView];
    [windDirectionView addSubview:image3];
    
    [self.container addSubview:pressureView];
    [pressureView addSubview:image4];
    
    [self.container addSubview:horizentalView];
    [horizentalView addSubview:image5];
    
    [self.container addSubview:feelsTempView];
    [feelsTempView addSubview:image6];
    
    [self initializeWeatherDataLabels:25 labelSize:circleSize Y:6];
    [self initializeUnitLabels:65 X:50 FontSize:12];
    [self initializeForecastDayLabels:22];
    
    [image1 addSubview:self.humidityLabel];
    [image2 addSubview:self.windSpeedLabel];
    [image3 addSubview:self.windDirectionContainer];
    [image4 addSubview:self.preasureLabel];
    [image5 addSubview:self.horizentalViewLabel];
    [image6 addSubview:self.feelsTempLabel];
    
    [image2 addSubview:self.windSpeedUnitLabel];
    [image4 addSubview:self.preasureUnitLabel];
    [image5 addSubview:self.horizentalViewUnitLabel];
    
    [humidityView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:120];
    [humidityView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-400];
    
    [pressureView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-25];
    [pressureView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-320];
    
    [windSpeedView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-105];
    [windSpeedView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-180];
    
    [windDirectionView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-105];
    [windDirectionView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-25];
    
    [horizentalView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-25];
    [horizentalView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:110];
    
    [feelsTempView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:120];
    [feelsTempView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:190];
    
    [self initializeConditionIconLabel:300];
    [self initializeForecastIconLabels:130];
    [self initializeCirclesDescription:20 Y:30];
    [self initializeForcastTempLabels:25 Y1:46 Y2:89 Size:40];
    [self initializeDayLabels:25];
}

#pragma mark Motion Effects

- (void)initializeMotionEffects
{
    UIInterpolatingMotionEffect *verticalInterpolation = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalInterpolation.minimumRelativeValue = @(-15);
    verticalInterpolation.maximumRelativeValue = @(15);
    
    UIInterpolatingMotionEffect *horizontalInterpolation = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalInterpolation.minimumRelativeValue = @(-15);
    horizontalInterpolation.maximumRelativeValue = @(15);
    
    [self.conditionIconLabel addMotionEffect:verticalInterpolation];
    [self.conditionIconLabel addMotionEffect:horizontalInterpolation];
}

-(void)initializeForcastContainar
{
    CGFloat width =self.bounds.size.width/3;
    double height =(double)(self.bounds.size.height * 0.17);
    double location = (double)(self.bounds.size.height - (.17 * self.bounds.size.height));
    
    self.ribbonDayThree = [[UIView alloc]initWithFrame:CGRectMake(0, location, width, height)];
    [self.ribbonDayThree setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.25]];
    [self.container addSubview:self.ribbonDayThree];
    
    self.ribbonDayTwo = [[UIView alloc]initWithFrame:CGRectMake(width, location, width, height)];
    [self.ribbonDayTwo setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.45]];
    [self.container addSubview:self.ribbonDayTwo];
    
    self.ribbonDayOne = [[UIView alloc]initWithFrame:CGRectMake(2*width, location, width, height)];
    [self.ribbonDayOne setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.65]];
    [self.container addSubview:self.ribbonDayOne];
}

- (void)initializeUpdatedLabel
{
    const NSInteger fontSize =(self.bounds.size.width/31);
    
    self.updatedLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.origin.x, self.locationLabel.bounds.size.height+16, self.bounds.size.width, 20)];
    [self.updatedLabel setAdjustsFontSizeToFitWidth:YES];
    [self.updatedLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.updatedLabel setBackgroundColor:[UIColor clearColor]];
    [self.updatedLabel setTextColor:[UIColor whiteColor]];
    [self.updatedLabel setTextAlignment:NSTextAlignmentCenter];
    self.updatedLabel.alpha = .8;
    [self.container addSubview:self.updatedLabel];
}

- (void)initializeConditionIconLabel:(NSInteger)fontSize
{
    //    const NSInteger fontSize = 167;
    //  const NSInteger fontSize = 270;
    self.conditionIconLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.6 * self.bounds.size.width, .5 * self.center.y, fontSize-39, fontSize)];
    //[self.conditionIconLabel setCenter:CGPointMake(self.container.center.x, 0.5 * self.center.y)];
    [self.conditionIconLabel setFont:[UIFont fontWithName:CLIMACONS_FONT size:fontSize]];
    [self.conditionIconLabel setBackgroundColor:[UIColor clearColor]];
    [self.conditionIconLabel setTextColor:[UIColor whiteColor]];
    [self.conditionIconLabel setTextAlignment:NSTextAlignmentCenter];
    [self.conditionIconLabel setClipsToBounds:YES];
    [self.conditionIconLabel setAdjustsFontSizeToFitWidth:YES];
    [self.container addSubview:self.conditionIconLabel];
    
    [self AddActivityIndicator:self.conditionIconLabel];
}

- (void)initializeConditionDescriptionLabel
{
    const NSInteger fontSize = 20;
    
    self.conditionDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.82 * self.bounds.size.width, 1.15 * self.center.y, 50, fontSize)];
    [self.conditionDescriptionLabel setAdjustsFontSizeToFitWidth:YES];
    [self.conditionDescriptionLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.conditionDescriptionLabel setBackgroundColor:[UIColor clearColor]];
    [self.conditionDescriptionLabel setTextColor:[UIColor whiteColor]];
    [self.conditionDescriptionLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.container addSubview:self.conditionDescriptionLabel];
}

- (void)initializeLocationLabel
{
    const NSInteger fontSize = (self.bounds.size.width/16);
    self.locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.origin.x, 22, self.bounds.size.width, 1.5 * fontSize)];
    [self.locationLabel setAdjustsFontSizeToFitWidth:YES];
    [self.locationLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.locationLabel setBackgroundColor:[UIColor clearColor]];
    [self.locationLabel setTextColor:[UIColor whiteColor]];
    [self.locationLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.container addSubview:self.locationLabel];
}

- (void)initializeCurrentTemperatureLabel:(NSInteger)fontSize
{
    
    self.currentTemperatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.62 * self.bounds.size.width, 1.0 * self.center.y, fontSize+10, fontSize+20)];
    
    [self.currentTemperatureLabel setAdjustsFontSizeToFitWidth:YES];
    [self.currentTemperatureLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.currentTemperatureLabel setBackgroundColor:[UIColor clearColor]];
    [self.currentTemperatureLabel setTextColor:[UIColor whiteColor]];
    [self.currentTemperatureLabel setTextAlignment:NSTextAlignmentRight];
    
    [self.container addSubview:self.currentTemperatureLabel];
}

- (void)initializeForecastDayLabels:(NSInteger)fontSize
{
    
    self.forecastDayOneLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.forecastDayTwoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.forecastDayThreeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    NSArray *forecastDayLabels = @[self.forecastDayOneLabel, self.forecastDayTwoLabel, self.forecastDayThreeLabel];
    NSArray *forecastContainers = @[self.ribbonDayOne, self.ribbonDayTwo, self.ribbonDayThree];
    for(int i = 0; i < [forecastDayLabels count]; ++i) {
        UILabel *forecastDayLabel = [forecastDayLabels objectAtIndex:i];
        [forecastDayLabel setFrame:CGRectMake(0, self.ribbonDayOne.bounds.size.height-fontSize-5, self.ribbonDayOne.bounds.size.width, fontSize)];
        [forecastDayLabel setAdjustsFontSizeToFitWidth:YES];
        [forecastDayLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
        [forecastDayLabel setBackgroundColor:[UIColor clearColor]];
        [forecastDayLabel setTextColor:[UIColor whiteColor]];
        [forecastDayLabel setTextAlignment:NSTextAlignmentCenter];
        [[forecastContainers objectAtIndex:i] addSubview:forecastDayLabel];
    }
}

- (void)initializeForecastIconLabels:(NSInteger)fontSize
{
    //const NSInteger fontSize = 68;
    
    self.forecastIconOneLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.forecastIconTwoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.forecastIconThreeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    
    
    NSArray *forecastIconLabels = @[self.forecastIconOneLabel, self.forecastIconTwoLabel, self.forecastIconThreeLabel];
    NSArray *forecastContainers = @[self.ribbonDayOne, self.ribbonDayTwo, self.ribbonDayThree];
    
    for(int i = 0; i < [forecastIconLabels count]; ++i) {
        UILabel *forecastIconLabel = [forecastIconLabels objectAtIndex:i];
        
        [forecastIconLabel setFrame:CGRectMake(self.ribbonDayOne.bounds.size.width/7, self.ribbonDayOne.bounds.size.height/8, fontSize, fontSize)];
        [forecastIconLabel setFont:[UIFont fontWithName:CLIMACONS_FONT size:fontSize]];
        [forecastIconLabel setBackgroundColor:[UIColor clearColor]];
        [forecastIconLabel setTextColor:[UIColor whiteColor]];
        [forecastIconLabel setTextAlignment:NSTextAlignmentCenter];
        [[forecastContainers objectAtIndex:i] addSubview:forecastIconLabel];
    }
}

- (void)initializeCirclesDescription:(NSInteger)fontSize Y:(NSInteger)y
{
    
    UILabel *humidity = [[UILabel alloc]initWithFrame:CGRectMake(-60,y, 50, fontSize)];
    
    [humidity setAdjustsFontSizeToFitWidth:YES];
    [humidity setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [humidity setBackgroundColor:[UIColor clearColor]];
    [humidity setTextColor:[UIColor whiteColor]];
    [humidity setTextAlignment:NSTextAlignmentRight];
    humidity.text = @"رطوبت";
    [humidityView addSubview:humidity];
    
    UILabel *preasure = [[UILabel alloc]initWithFrame:CGRectMake(-60,y, 50, fontSize)];
    
    [preasure setAdjustsFontSizeToFitWidth:YES];
    [preasure setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [preasure setBackgroundColor:[UIColor clearColor]];
    [preasure setTextColor:[UIColor whiteColor]];
    [preasure setTextAlignment:NSTextAlignmentRight];
    preasure.text = @"فشار هوا";
    [pressureView addSubview:preasure];
    
    UILabel *windSpeed = [[UILabel alloc]initWithFrame:CGRectMake(-60,y, 50, fontSize)];
    
    [windSpeed setAdjustsFontSizeToFitWidth:YES];
    [windSpeed setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [windSpeed setBackgroundColor:[UIColor clearColor]];
    [windSpeed setTextColor:[UIColor whiteColor]];
    [windSpeed setTextAlignment:NSTextAlignmentRight];
    windSpeed.text = @"سرعت باد";
    [windSpeedView addSubview:windSpeed];
    
    
    UILabel *windSpeedDirection = [[UILabel alloc]initWithFrame:CGRectMake(-60,y+5, 50, fontSize)];
    
    [windSpeedDirection setAdjustsFontSizeToFitWidth:YES];
    [windSpeedDirection setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [windSpeedDirection setBackgroundColor:[UIColor clearColor]];
    [windSpeedDirection setTextColor:[UIColor whiteColor]];
    [windSpeedDirection setTextAlignment:NSTextAlignmentRight];
    windSpeedDirection.text = @"جهت باد";
    [windDirectionView addSubview:windSpeedDirection];
    
    
    UILabel *horizentalViewLabel = [[UILabel alloc]initWithFrame:CGRectMake(-60,y+5, 50, fontSize)];
    
    [horizentalViewLabel setAdjustsFontSizeToFitWidth:YES];
    [horizentalViewLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [horizentalViewLabel setBackgroundColor:[UIColor clearColor]];
    [horizentalViewLabel setTextColor:[UIColor whiteColor]];
    [horizentalViewLabel setTextAlignment:NSTextAlignmentRight];
    horizentalViewLabel.text = @"دید افقی";
    [horizentalView addSubview:horizentalViewLabel];
    
    
    UILabel *feelsLikeTempLabel = [[UILabel alloc]initWithFrame:CGRectMake(-60,y+5, 50, fontSize)];
    
    [feelsLikeTempLabel setAdjustsFontSizeToFitWidth:YES];
    [feelsLikeTempLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [feelsLikeTempLabel setBackgroundColor:[UIColor clearColor]];
    [feelsLikeTempLabel setTextColor:[UIColor whiteColor]];
    [feelsLikeTempLabel setTextAlignment:NSTextAlignmentRight];
    feelsLikeTempLabel.text = @"دمای احساسی";
    [feelsTempView addSubview:feelsLikeTempLabel];
}


- (void)spinLayer:(CALayer *)inLayer duration:(CFTimeInterval)inDuration
        direction:(int)direction degrees:(CGFloat)degrees wind:(NSString*)windSpeed
{
    if ([windSpeed isEqualToString:@"0.0"]) {
        inLayer.opacity = 0;
    }
    
    CABasicAnimation* rotationAnimation;

    // Rotate about the z axis
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [[inLayer presentationLayer] valueForKeyPath:@"transform.rotation.z"];
    // Rotate 360 degress, in direction specified
    rotationAnimation.toValue = [NSNumber numberWithFloat:direction * DEGREES_TO_RADIANS(degrees)];
    
    // Perform the rotation over this many seconds
    rotationAnimation.duration = inDuration;
    
    // Set the pacing of the animation
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.repeatCount = 0;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // Add animation to the layer and make it so
    [inLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)DrawArrow:(UIView*)container
{
    
    UIBezierPath* bezierPath = [self drawCanvas1WithFrame:container.bounds];
    CAShapeLayer *shapeView = [[CAShapeLayer alloc] init];
    
    shapeView.strokeColor = [UIColor whiteColor].CGColor;
    shapeView.fillColor = [UIColor whiteColor].CGColor;
    [shapeView setPath:bezierPath.CGPath];

    [[container layer] addSublayer:shapeView];
    
}

- (UIBezierPath*)drawCanvas1WithFrame: (CGRect)frame
{
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 0.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 30.5, CGRectGetMinY(frame) + 15.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 30.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 30.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 9.07, CGRectGetMinY(frame) + 15.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 0.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 0.5)];
    [bezierPath closePath];
    [UIColor.grayColor setFill];
    [bezierPath fill];
    [UIColor.blackColor setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
    
    return bezierPath;
}


-(void)setWeatherCondition:(NSString*)condition
{
    if ([condition isEqual:@"32"]||[condition isEqual:@"34"])
    {
        SnowFall *star = [[SnowFall alloc]init];
        [star startSnowFall:self.isDay Speed:-10 Amount:10 Acceleration:10];
        [self.container insertSubview:star.view atIndex:1];
    }
    else if ([condition isEqual:@"36"]||[condition isEqual:@"33"]||[condition isEqual:@"35"])
    {
        SnowFall *star = [[SnowFall alloc]init];
        [star startSnowFall:self.isDay Speed:-100 Amount:100 Acceleration:100];
        [self.container insertSubview:star.view atIndex:1];
    }
    else if ([condition isEqual:@"27"]||[condition isEqual:@"29"]||[condition isEqual:@"31"])
    {
        RainFall *rain = [[RainFall alloc]init];
        [rain startRainFall:self.isDay Speed:-100 Amount:10];
        [self.container insertSubview:rain.view atIndex:1];
    }
    else if ([condition isEqual:@"30"])
    {
        RainFall *rain = [[RainFall alloc]init];
        [rain startRainFall:self.isDay Speed:-100 Amount:50];
        [self.container insertSubview:rain.view atIndex:1];
    }
    
    else
    {

        UIViewController *normal = [[UIViewController alloc]init];
        if (self.isDay) {
        normal.view.backgroundColor = [UIColor clearColor];

        }
        else
            normal.view.backgroundColor = [UIColor colorWithRed:25.0/255.0 green:45.0/255.0 blue:85.0/255.0 alpha:1];
        
        [self.container insertSubview:normal.view atIndex:1];
    }    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
