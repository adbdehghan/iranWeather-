//
//  LaunchScreen.m
//  Iran Weather
//
//  Created by aDb on 12/8/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import "LaunchScreen.h"
#import "ZYQSphereView.h"
#import "Gradient.h"
#import "Settings.h"
#import "DBManager.h"
#import "UIImage+ImageEffects.h"
#import "AddLocationViewController.h"
#import "MainViewController.h"

@interface LaunchScreen ()
{
    ZYQSphereView *sphereView;
    NSTimer *timer;
    Settings *setting;
}

@property (strong, nonatomic) UIView *ribbon;



@end

@implementation LaunchScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Gradient *gr = [[Gradient alloc]init];
    UIImageView *uv = [[UIImageView alloc]initWithImage:[gr CreateGradient:self.view.frame.size.width Height:self.view.frame.size.height]];
    [self.view addSubview:uv];

    
    self.ribbon = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-130 , self.view.bounds.size.width, 80)];
    [self.ribbon setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.25]];
    [self.view addSubview:self.ribbon];

    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.ribbon.frame.size.width ,self.ribbon.frame.size.height)];
    [title setText:@"سازمان هواشناسی کشور"];
    
    [title setAdjustsFontSizeToFitWidth:YES];
    [title setFont:[UIFont fontWithName:@"B Koodak" size:35]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:[UIColor whiteColor]];

    
    [self.ribbon addSubview:title];
    
    [self AddSphere];
    

    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.6
                                     target:self
                                   selector:@selector(TimerCalled:)
                                   userInfo:nil
                                    repeats:NO];

}

-(void)TimerCalled:(NSTimer *)timer
{
    [self performSegueWithIdentifier:@"LaunchNext" sender:self];
}

- (void)AddSphere
{
    
    sphereView = [[ZYQSphereView alloc] initWithFrame:CGRectMake(10, 60, self.view.frame.size.width-80, self.view.frame.size.width-80)];
    sphereView.center=CGPointMake(self.view.center.x, self.view.center.y-30);
    NSMutableArray *views = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= 24; i++) {
        UIImage *sub = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]];
        UIImageView *subV = [[UIImageView alloc]initWithImage:sub];
        
        if (self.view.frame.size.width>500) {
            subV.frame = CGRectMake(0, 0, 60, 60);
        }
        else
            subV.frame = CGRectMake(0, 0, 30, 30);
        
        [views addObject:subV];
    }
    
    for (int i = 1; i <= 17; i++) {
        UIImage *sub = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]];
        UIImageView *subV = [[UIImageView alloc]initWithImage:sub];
        
        if (self.view.frame.size.width>500) {
            subV.frame = CGRectMake(0, 0, 60, 60);
        }
        else
            subV.frame = CGRectMake(0, 0, 30, 30);
        
        [views addObject:subV];
    }
    
    [sphereView setItems:views];
    
    sphereView.isPanTimerStart=YES;
    
    [self.view addSubview:sphereView];
    [sphereView timerStart];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    MainViewController *destination = [segue destinationViewController];

}


@end
