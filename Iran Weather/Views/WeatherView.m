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


@interface WeatherView()
{
    UIView *humidityView,*currentTempretureView,*windSpeedView,*windDirectionView,*feelsTempView,*horizentalView,*pressureView,*descriptionView,*forcastDayOneView,*forcastDayTwoView,*forcastDayThreeView;

}
@property (strong, nonatomic)  UIImageView        *blurredOverlayView;

@property (strong, nonatomic) UIImageView               *backgroundImage;

@property (strong, nonatomic) UIImageView               *backgroundImage2;

@property (strong, nonatomic) UIView                    *container;

//  Light-Colored ribbon to display temperatures and forecasts on

@property (strong, nonatomic) UIView               *ribbonDayOne;

@property (strong, nonatomic) UIView              *ribbonDayTwo;

@property (strong, nonatomic) UIView              *ribbonDayThree;


//  Displays the time the weather data for this view was last updated
@property (strong, nonatomic) UILabel             *updatedLabel;

//  Displays the icon for current conditions
@property (strong, nonatomic) UILabel              *conditionIconLabel;

//  Displays the description of current conditions
@property (strong, nonatomic) UILabel             *conditionDescriptionLabel;

//  Displays the location whose weather data is being represented by this weather view
@property (strong, nonatomic) UILabel             *locationLabel;

//  Displayes the current temperature
@property (strong, nonatomic) UILabel             *currentTemperatureLabel;


@property (strong, nonatomic) UILabel *humidityLabel;

@property (strong, nonatomic) UILabel *preasureLabel;

@property (strong, nonatomic) UILabel *horizentalViewLabel;

@property (strong, nonatomic) UILabel *windSpeedLabel;

@property (strong, nonatomic) UILabel *windSpeedUnitLabel;

@property (strong, nonatomic) UILabel *preasureUnitLabel;

@property (strong, nonatomic) UILabel *horizentalViewUnitLabel;

@property (strong, nonatomic) NSString *windDirectionAngle;

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

@end

#pragma mark - WeatherView Implementation

@implementation WeatherView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {

        //  Initialize Container
        self.container = [[UIView alloc]initWithFrame:self.bounds];
        [self.container setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.container];

        self.blurredOverlayView=[[UIImageView alloc]init];


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
        //[self initializeUpdatedLabel];
        [self initializeUnitLabels];
        [self initializeWeatherDataLabels];
        [self initializeConditionIconLabel];
        [self initializeConditionDescriptionLabel];
        [self initializeLocationLabel];
        [self initializeCurrentTemperatureLabel];
        [self initializeHiLoTemperatureLabel];
        [self initializeForcastContainar];
        [self initializeForecastDayLabels];
        
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
        
        [self initializeCirclesDescription];

        [self initializeForecastIconLabels];
        [self initializeForcastTempLabels];
        [self initializeDayLabels];
        
    }
    return self;
}

-(void)initializeDayLabels
{
    const NSInteger fontSize = 13;
    self.forcastDaylabel1 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayOne.bounds.size.width-55,2, 50, 20)];
    [self.forcastDaylabel1 setAdjustsFontSizeToFitWidth:YES];
    [self.forcastDaylabel1 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.forcastDaylabel1 setBackgroundColor:[UIColor clearColor]];
    [self.forcastDaylabel1 setTextColor:[UIColor grayColor]];
    [self.forcastDaylabel1 setTextAlignment:NSTextAlignmentCenter];
    self.forcastDaylabel1.alpha = .65;
    [self.ribbonDayOne addSubview:self.forcastDaylabel1];
    
    self.forcastDaylabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayTwo.bounds.size.width-55,2, 50, 20)];
    [self.forcastDaylabel2 setAdjustsFontSizeToFitWidth:YES];
    [self.forcastDaylabel2 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.forcastDaylabel2 setBackgroundColor:[UIColor clearColor]];
    [self.forcastDaylabel2 setTextColor:[UIColor grayColor]];
    [self.forcastDaylabel2 setTextAlignment:NSTextAlignmentCenter];
    self.forcastDaylabel2.alpha = .65;
    [self.ribbonDayTwo addSubview:self.forcastDaylabel2];
    
    self.forcastDaylabel3 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayThree.bounds.size.width-55,2, 50, 20)];
    [self.forcastDaylabel3 setAdjustsFontSizeToFitWidth:YES];
    [self.forcastDaylabel3 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.forcastDaylabel3 setBackgroundColor:[UIColor clearColor]];
    [self.forcastDaylabel3 setTextColor:[UIColor grayColor]];
    [self.forcastDaylabel3 setTextAlignment:NSTextAlignmentCenter];
    self.forcastDaylabel3.alpha = .65;
    [self.ribbonDayThree addSubview:self.forcastDaylabel3];

}

-(void)initializeForcastTempLabels
{
    const NSInteger fontSize = 13;
    self.highTemperatureLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayOne.bounds.size.width-24,27, 20, 20)];
    [self.highTemperatureLabel1 setAdjustsFontSizeToFitWidth:YES];
    [self.highTemperatureLabel1 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.highTemperatureLabel1 setBackgroundColor:[UIColor clearColor]];
    [self.highTemperatureLabel1 setTextColor:[UIColor redColor]];
    [self.highTemperatureLabel1 setTextAlignment:NSTextAlignmentCenter];
    self.highTemperatureLabel1.alpha = .65;
    [self.ribbonDayOne addSubview:self.highTemperatureLabel1];
    
    self.highTemperatureLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayTwo.bounds.size.width-24,27, 20, 20)];
    [self.highTemperatureLabel2 setAdjustsFontSizeToFitWidth:YES];
    [self.highTemperatureLabel2 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.highTemperatureLabel2 setBackgroundColor:[UIColor clearColor]];
    [self.highTemperatureLabel2 setTextColor:[UIColor redColor]];
    [self.highTemperatureLabel2 setTextAlignment:NSTextAlignmentCenter];
        self.highTemperatureLabel2.alpha = .65;
    [self.ribbonDayTwo addSubview:self.highTemperatureLabel2];
    
    self.highTemperatureLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayThree.bounds.size.width-24,27, 20, 20)];
    [self.highTemperatureLabel3 setAdjustsFontSizeToFitWidth:YES];
    [self.highTemperatureLabel3 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.highTemperatureLabel3 setBackgroundColor:[UIColor clearColor]];
    [self.highTemperatureLabel3 setTextColor:[UIColor redColor]];
    [self.highTemperatureLabel3 setTextAlignment:NSTextAlignmentCenter];
        self.highTemperatureLabel3.alpha = .65;
    [self.ribbonDayThree addSubview:self.highTemperatureLabel3];
    
    
    self.minTemperatureLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayOne.bounds.size.width-24,46, 20, 20)];
    [self.minTemperatureLabel1 setAdjustsFontSizeToFitWidth:YES];
    [self.minTemperatureLabel1 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.minTemperatureLabel1 setBackgroundColor:[UIColor clearColor]];
    [self.minTemperatureLabel1 setTextColor:[UIColor blueColor]];
    [self.minTemperatureLabel1 setTextAlignment:NSTextAlignmentCenter];
            self.minTemperatureLabel1.alpha = .7;
    [self.ribbonDayOne addSubview:self.minTemperatureLabel1];
    
    self.minhTemperatureLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayTwo.bounds.size.width-24,46, 20, 20)];
    [self.minhTemperatureLabel2 setAdjustsFontSizeToFitWidth:YES];
    [self.minhTemperatureLabel2 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.minhTemperatureLabel2 setBackgroundColor:[UIColor clearColor]];
    [self.minhTemperatureLabel2 setTextColor:[UIColor blueColor]];
    [self.minhTemperatureLabel2 setTextAlignment:NSTextAlignmentCenter];
            self.minhTemperatureLabel2.alpha = .7;
    [self.ribbonDayTwo addSubview:self.minhTemperatureLabel2];
    
    self.minhTemperatureLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(self.ribbonDayThree.bounds.size.width-24,46, 20, 20)];
    [self.minhTemperatureLabel3 setAdjustsFontSizeToFitWidth:YES];
    [self.minhTemperatureLabel3 setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.minhTemperatureLabel3 setBackgroundColor:[UIColor clearColor]];
    [self.minhTemperatureLabel3 setTextColor:[UIColor blueColor]];
    [self.minhTemperatureLabel3 setTextAlignment:NSTextAlignmentCenter];
            self.minhTemperatureLabel3.alpha = .7;
    [self.ribbonDayThree addSubview:self.minhTemperatureLabel3];
    
}

-(void)initializeWeatherDataLabels
{
    const NSInteger fontSize = 18;
    self.humidityLabel = [[UILabel alloc]initWithFrame:CGRectMake(2,6, 50, 50)];
    [self.humidityLabel setAdjustsFontSizeToFitWidth:YES];
    [self.humidityLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.humidityLabel setBackgroundColor:[UIColor clearColor]];
    [self.humidityLabel setTextColor:[UIColor whiteColor]];
    [self.humidityLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    self.preasureLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,5, 50, 50)];
    [self.preasureLabel setAdjustsFontSizeToFitWidth:YES];
    [self.preasureLabel setFont:[UIFont fontWithName:@"B Koodak" size:14]];
    [self.preasureLabel setBackgroundColor:[UIColor clearColor]];
    [self.preasureLabel setTextColor:[UIColor whiteColor]];
    [self.preasureLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    self.windSpeedLabel = [[UILabel alloc]initWithFrame:CGRectMake(2,7, 50, 50)];
    [self.windSpeedLabel setAdjustsFontSizeToFitWidth:YES];
    [self.windSpeedLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.windSpeedLabel setBackgroundColor:[UIColor clearColor]];
    [self.windSpeedLabel setTextColor:[UIColor whiteColor]];
    [self.windSpeedLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.horizentalViewLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,8, 50, 50)];
    [self.horizentalViewLabel setAdjustsFontSizeToFitWidth:YES];
    [self.horizentalViewLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.horizentalViewLabel setBackgroundColor:[UIColor clearColor]];
    [self.horizentalViewLabel setTextColor:[UIColor whiteColor]];
    [self.horizentalViewLabel setTextAlignment:NSTextAlignmentCenter];
    
}

-(void)initializeUnitLabels
{
    const NSInteger fontSize = 8;
    
    self.horizentalViewUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(24,30, 20, 20)];
    [self.horizentalViewUnitLabel setAdjustsFontSizeToFitWidth:YES];
    [self.horizentalViewUnitLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
    [self.horizentalViewUnitLabel setBackgroundColor:[UIColor clearColor]];
    [self.horizentalViewUnitLabel setTextColor:[UIColor whiteColor]];
    [self.horizentalViewUnitLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.preasureUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(24,30, 20, 20)];
    [self.preasureUnitLabel setAdjustsFontSizeToFitWidth:YES];
    [self.preasureUnitLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
    [self.preasureUnitLabel setBackgroundColor:[UIColor clearColor]];
    [self.preasureUnitLabel setTextColor:[UIColor whiteColor]];
    [self.preasureUnitLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    self.windSpeedUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(24,30, 20, 20)];
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
    
    humidityView = [[UIView alloc]initForAutoLayout];
    
    windDirectionView =[[UIView alloc]initForAutoLayout];
    
    pressureView =[[UIView alloc]initForAutoLayout];
    
    horizentalView =[[UIView alloc]initForAutoLayout];
    
    windSpeedView =[[UIView alloc]initForAutoLayout];
    
    
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
    
    [image1 addSubview:self.humidityLabel];
    [image2 addSubview:self.windSpeedLabel];
    [image4 addSubview:self.preasureLabel];
    [image5 addSubview:self.horizentalViewLabel];
    
    [image2 addSubview:self.windSpeedUnitLabel];
    [image4 addSubview:self.preasureUnitLabel];
    [image5 addSubview:self.horizentalViewUnitLabel];
    
    [humidityView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:30];
    [humidityView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-182];
    
    [pressureView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-25];
    [pressureView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-140];
    
    [windSpeedView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-55];
    [windSpeedView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-75];
    
    [windDirectionView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-50];
    [windDirectionView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-5];
 
    
    [horizentalView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-15];
    [horizentalView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:53];
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
    
    humidityView = [[UIView alloc]initForAutoLayout];
    
    windDirectionView =[[UIView alloc]initForAutoLayout];
    
    pressureView =[[UIView alloc]initForAutoLayout];
    
    horizentalView =[[UIView alloc]initForAutoLayout];
    
    windSpeedView =[[UIView alloc]initForAutoLayout];
    
    
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
    
    [image1 addSubview:self.humidityLabel];
    [image2 addSubview:self.windSpeedLabel];
    [image4 addSubview:self.preasureLabel];
    [image5 addSubview:self.horizentalViewLabel];
    
    [image2 addSubview:self.windSpeedUnitLabel];
    [image4 addSubview:self.preasureUnitLabel];
    [image5 addSubview:self.horizentalViewUnitLabel];
    
    [humidityView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:53];
    [humidityView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-250];
    
    [pressureView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-30];
    [pressureView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-190];
    
    [windSpeedView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-70];
    [windSpeedView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-85];
    
    [windDirectionView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-56];
    [windDirectionView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:20];
    

    
    [horizentalView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:20];
    [horizentalView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:97];
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
    
    humidityView = [[UIView alloc]initForAutoLayout];
    
    windDirectionView =[[UIView alloc]initForAutoLayout];
    
    pressureView =[[UIView alloc]initForAutoLayout];
    
    horizentalView =[[UIView alloc]initForAutoLayout];
    
    windSpeedView =[[UIView alloc]initForAutoLayout];
    
    
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
    
    [image1 addSubview:self.humidityLabel];
    [image2 addSubview:self.windSpeedLabel];
    [image4 addSubview:self.preasureLabel];
    [image5 addSubview:self.horizentalViewLabel];
    
    [image2 addSubview:self.windSpeedUnitLabel];
    [image4 addSubview:self.preasureUnitLabel];
    [image5 addSubview:self.horizentalViewUnitLabel];
    
    [humidityView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:45];
    [humidityView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-270];
    
    [pressureView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-45];
    [pressureView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-190];
    
    [windSpeedView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-80];
    [windSpeedView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-75];
    
    [windDirectionView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-50];
    [windDirectionView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:40];
    
    
    
    [horizentalView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:40];
    [horizentalView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:120];}

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
    
    humidityView = [[UIView alloc]initForAutoLayout];
    
    windDirectionView =[[UIView alloc]initForAutoLayout];
    
    pressureView =[[UIView alloc]initForAutoLayout];
    
    horizentalView =[[UIView alloc]initForAutoLayout];
    
    windSpeedView =[[UIView alloc]initForAutoLayout];
    
    
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
    
    [image1 addSubview:self.humidityLabel];
    [image2 addSubview:self.windSpeedLabel];
    [image4 addSubview:self.preasureLabel];
    [image5 addSubview:self.horizentalViewLabel];

    [image2 addSubview:self.windSpeedUnitLabel];
    [image4 addSubview:self.preasureUnitLabel];
    [image5 addSubview:self.horizentalViewUnitLabel];
    
    [humidityView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:30];
    [humidityView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-210];
    
    [pressureView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-33];
    [pressureView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-160];
    
    
    [windSpeedView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-67];
    [windSpeedView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-85];
    
    
    [windDirectionView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-59];
    [windDirectionView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:0];
 

    [horizentalView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-8];
    [horizentalView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:70];
}

-(void)initializeCirclesForIpad{
    
    UIImageView *circleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elipse.png"]];
    [circleView setFrame:CGRectMake(0, 0, 75, 75)];
    
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
    
    humidityView = [[UIView alloc]initForAutoLayout];
    
    windDirectionView =[[UIView alloc]initForAutoLayout];
    
    pressureView =[[UIView alloc]initForAutoLayout];
    
    horizentalView =[[UIView alloc]initForAutoLayout];
    
    windSpeedView =[[UIView alloc]initForAutoLayout];
    
    
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
    
    [image1 addSubview:self.humidityLabel];
    [image2 addSubview:self.windSpeedLabel];
    [image4 addSubview:self.preasureLabel];
    [image5 addSubview:self.horizentalViewLabel];
    
    [image2 addSubview:self.windSpeedUnitLabel];
    [image4 addSubview:self.preasureUnitLabel];
    [image5 addSubview:self.horizentalViewUnitLabel];
    
    [humidityView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:120];
    [humidityView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-400];
    
    [pressureView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-35];
    [pressureView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-300];
    
    [windSpeedView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-110];
    [windSpeedView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:-120];
    
    [windDirectionView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:-60];
    [windDirectionView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:65];
    
    
    
    [horizentalView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.container withOffset:110];
    [horizentalView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.container withOffset:190];
    
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
     const NSInteger fontSize =(self.bounds.size.width/30);
    
    self.updatedLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.origin.x, 80, self.bounds.size.width, 20)];
    [self.updatedLabel setAdjustsFontSizeToFitWidth:YES];
    [self.updatedLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.updatedLabel setBackgroundColor:[UIColor clearColor]];
    [self.updatedLabel setTextColor:[UIColor whiteColor]];
    [self.updatedLabel setTextAlignment:NSTextAlignmentCenter];

    [self.container addSubview:self.updatedLabel];
}

- (void)initializeConditionIconLabel
{
    const NSInteger fontSize = 167;
    self.conditionIconLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.6 * self.bounds.size.width, .5 * self.center.y, fontSize-39, fontSize)];
    //[self.conditionIconLabel setCenter:CGPointMake(self.container.center.x, 0.5 * self.center.y)];
    [self.conditionIconLabel setFont:[UIFont fontWithName:CLIMACONS_FONT size:fontSize]];
    [self.conditionIconLabel setBackgroundColor:[UIColor clearColor]];
    [self.conditionIconLabel setTextColor:[UIColor whiteColor]];
    [self.conditionIconLabel setTextAlignment:NSTextAlignmentCenter];
    [self.conditionIconLabel setClipsToBounds:YES];
    [self.container addSubview:self.conditionIconLabel];
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

- (void)initializeCurrentTemperatureLabel
{
    const NSInteger fontSize = 30;
    
    self.currentTemperatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.62 * self.bounds.size.width, 1.05 * self.center.y, 50, 40)];
    
    [self.currentTemperatureLabel setAdjustsFontSizeToFitWidth:YES];
    [self.currentTemperatureLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [self.currentTemperatureLabel setBackgroundColor:[UIColor clearColor]];
    [self.currentTemperatureLabel setTextColor:[UIColor whiteColor]];
    [self.currentTemperatureLabel setTextAlignment:NSTextAlignmentRight];

    [self.container addSubview:self.currentTemperatureLabel];
}

- (void)initializeHiLoTemperatureLabel
{
    const NSInteger fontSize = 18;
//    self.hiloTemperatureLabel = [[MKPersianFont alloc]initWithFrame:CGRectZero];
//    [self.hiloTemperatureLabel setFrame:CGRectMake(0, 0, 0.375 * self.bounds.size.width, fontSize)];
//    [self.hiloTemperatureLabel setCenter:CGPointMake(self.currentTemperatureLabel.center.x - 4,
//                                                     self.currentTemperatureLabel.center.y + 0.5 * self.currentTemperatureLabel.bounds.size.height + 12)];
//    //[self.hiloTemperatureLabel setFont:[UIFont fontWithName:LIGHT_FONT size:fontSize]];
//    [self.hiloTemperatureLabel setBackgroundColor:[UIColor clearColor]];
//    [self.container addSubview:self.hiloTemperatureLabel];
}

- (void)initializeForecastDayLabels
{
    const NSInteger fontSize = 12;
    
    self.forecastDayOneLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.forecastDayTwoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.forecastDayThreeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    NSArray *forecastDayLabels = @[self.forecastDayOneLabel, self.forecastDayTwoLabel, self.forecastDayThreeLabel];
        NSArray *forecastContainers = @[self.ribbonDayOne, self.ribbonDayTwo, self.ribbonDayThree];
    for(int i = 0; i < [forecastDayLabels count]; ++i) {
        UILabel *forecastDayLabel = [forecastDayLabels objectAtIndex:i];
        [forecastDayLabel setFrame:CGRectMake(0, self.ribbonDayOne.bounds.size.height-18, self.ribbonDayOne.bounds.size.width, fontSize)];
        [forecastDayLabel setAdjustsFontSizeToFitWidth:YES];
        [forecastDayLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
        [forecastDayLabel setBackgroundColor:[UIColor clearColor]];
        [forecastDayLabel setTextColor:[UIColor grayColor]];
        [forecastDayLabel setTextAlignment:NSTextAlignmentCenter];
        [[forecastContainers objectAtIndex:i] addSubview:forecastDayLabel];
    }
}

- (void)initializeForecastIconLabels
{
    const NSInteger fontSize = 68;
    
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

- (void)initializeCirclesDescription
{
    const NSInteger fontSize = 15;
    
    UILabel *humidity = [[UILabel alloc]initWithFrame:CGRectMake(-60,20, 50, fontSize)];
    
    [humidity setAdjustsFontSizeToFitWidth:YES];
    [humidity setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [humidity setBackgroundColor:[UIColor clearColor]];
    [humidity setTextColor:[UIColor whiteColor]];
    [humidity setTextAlignment:NSTextAlignmentRight];
    humidity.text = @"رطوبت";
    [humidityView addSubview:humidity];
    
    UILabel *preasure = [[UILabel alloc]initWithFrame:CGRectMake(-60,20, 50, fontSize)];
    
    [preasure setAdjustsFontSizeToFitWidth:YES];
    [preasure setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [preasure setBackgroundColor:[UIColor clearColor]];
    [preasure setTextColor:[UIColor whiteColor]];
    [preasure setTextAlignment:NSTextAlignmentRight];
    preasure.text = @"فشار هوا";
    [pressureView addSubview:preasure];
    
    UILabel *windSpeed = [[UILabel alloc]initWithFrame:CGRectMake(-60,20, 50, fontSize)];
    
    [windSpeed setAdjustsFontSizeToFitWidth:YES];
    [windSpeed setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [windSpeed setBackgroundColor:[UIColor clearColor]];
    [windSpeed setTextColor:[UIColor whiteColor]];
    [windSpeed setTextAlignment:NSTextAlignmentRight];
    windSpeed.text = @"سرعت باد";
    [windSpeedView addSubview:windSpeed];
    
    
    UILabel *windSpeedDirection = [[UILabel alloc]initWithFrame:CGRectMake(-60,25, 50, fontSize)];
    
    [windSpeedDirection setAdjustsFontSizeToFitWidth:YES];
    [windSpeedDirection setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [windSpeedDirection setBackgroundColor:[UIColor clearColor]];
    [windSpeedDirection setTextColor:[UIColor whiteColor]];
    [windSpeedDirection setTextAlignment:NSTextAlignmentRight];
    windSpeedDirection.text = @"جهت باد";
    [windDirectionView addSubview:windSpeedDirection];
    
    
    UILabel *horizentalViewLabel = [[UILabel alloc]initWithFrame:CGRectMake(-60,25, 50, fontSize)];
    
    [horizentalViewLabel setAdjustsFontSizeToFitWidth:YES];
    [horizentalViewLabel setFont:[UIFont fontWithName:@"B Koodak" size:fontSize]];
    [horizentalViewLabel setBackgroundColor:[UIColor clearColor]];
    [horizentalViewLabel setTextColor:[UIColor whiteColor]];
    [horizentalViewLabel setTextAlignment:NSTextAlignmentRight];
    horizentalViewLabel.text = @"دید افقی";
    [horizentalView addSubview:horizentalViewLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
