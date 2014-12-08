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

@interface LaunchScreen ()
{
    ZYQSphereView *sphereView;
    NSTimer *timer;
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
    
    [self AddSphere];
    
}

- (void)AddSphere {
    sphereView = [[ZYQSphereView alloc] initWithFrame:CGRectMake(10, 60, self.view.frame.size.width-80, self.view.frame.size.width-80)];
    sphereView.center=CGPointMake(self.view.center.x, self.view.center.y-30);
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (int i = 0; i < 50; i++) {
        UIButton *subV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        subV.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100. green:arc4random_uniform(100)/100. blue:arc4random_uniform(100)/100. alpha:1];
        [subV setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        subV.layer.masksToBounds=YES;
        
        subV.layer.cornerRadius=3;
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
