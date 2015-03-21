//
//  AboutViewController.m
//  Iran Weather
//
//  Created by aDb on 12/31/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import "AboutViewController.h"
#import "MKPersianFont.h"

@interface AboutViewController ()
@property (strong, nonatomic) UINavigationBar       *navigationBar;

// Done button inside navigation bar
@property (strong, nonatomic) UIBarButtonItem       *doneButton;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
    [self.view addSubview:self.blurredOverlayView];
    
    self.navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64)];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.tintColor = [UIColor colorWithWhite:1 alpha:0.7];
    self.navigationBar.translucent = YES;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                 NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:22]}];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0, self.navigationBar.bounds.size.height - 0.5, self.navigationBar.bounds.size.width, 0.5);
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [self.navigationBar.layer addSublayer:bottomBorder];
    [self.view addSubview:self.navigationBar];
    
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button addTarget:self action:@selector(doneButtonPressed)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 53, 31)];
    
    
    MKPersianFont *title2 = [[MKPersianFont alloc]init];
    [title2 setPersianFont:@"koodak" withText:@"برگشت" fontSize:19 textAlignment:CENTER textWrapped:YES fontColor:[UIColor whiteColor]];
    [title2 setFrame:CGRectMake(3,10, 60 ,20)];
    
    [button addSubview:title2];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
    
    self.doneButton = barButton;
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc]initWithTitle:@"درباره ما"];
    [navigationItem setRightBarButtonItem:self.doneButton];
    [self.navigationBar setItems:@[navigationItem]];
    
    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weatherLogo.png"]];
    [logo setFrame:CGRectMake(self.view.bounds.size.width/2-(300/2),self.view.bounds.size.height*.51, 300, 170)];
    //logo.center = self.view.center;
    logo.alpha = .6;
    [self.view addSubview:logo];
    
    
    UILabel *email = [[UILabel alloc]initWithFrame:CGRectMake(-10,80, self.view.bounds.size.width, 50)];
    
    [email setAdjustsFontSizeToFitWidth:YES];
    [email setFont:[UIFont fontWithName:@"B Koodak" size:17]];
    [email setBackgroundColor:[UIColor clearColor]];
    [email setTextColor:[UIColor whiteColor]];
    [email setTextAlignment:NSTextAlignmentRight];
    email.text = @"ایمیل : pr@irimo.ir";
    [self.view addSubview:email];
    
    UILabel *tel = [[UILabel alloc]initWithFrame:CGRectMake(-10,120, self.view.bounds.size.width, 50)];

    [tel setAdjustsFontSizeToFitWidth:YES];
    [tel setFont:[UIFont fontWithName:@"B Koodak" size:17]];
    [tel setBackgroundColor:[UIColor clearColor]];
    [tel setTextColor:[UIColor whiteColor]];
    [tel setTextAlignment:NSTextAlignmentRight];
    tel.text = @"تلفکس: 66070014";
    [self.view addSubview:tel];
    
    
    UILabel *tel2 = [[UILabel alloc]initWithFrame:CGRectMake(-10,160, self.view.bounds.size.width, 50)];
    
    [tel2 setAdjustsFontSizeToFitWidth:YES];
    [tel2 setFont:[UIFont fontWithName:@"B Koodak" size:17]];
    [tel2 setBackgroundColor:[UIColor clearColor]];
    [tel2 setTextColor:[UIColor whiteColor]];
    [tel2 setTextAlignment:NSTextAlignmentRight];
    tel2.text = @"تلفن گویا: 134";
    [self.view addSubview:tel2];
    
    
    UILabel *sms = [[UILabel alloc]initWithFrame:CGRectMake(-10,200, self.view.bounds.size.width, 50)];
    
    [sms setAdjustsFontSizeToFitWidth:YES];
    [sms setFont:[UIFont fontWithName:@"B Koodak" size:17]];
    [sms setBackgroundColor:[UIColor clearColor]];
    [sms setTextColor:[UIColor whiteColor]];
    [sms setTextAlignment:NSTextAlignmentRight];
    sms.text = @"شماره پیامک : 20134";
    [self.view addSubview:sms];
    
    UILabel *site = [[UILabel alloc]initWithFrame:CGRectMake(-10,240, self.view.bounds.size.width, 50)];
    
    [site setAdjustsFontSizeToFitWidth:YES];
    [site setFont:[UIFont fontWithName:@"B Koodak" size:17]];
    [site setBackgroundColor:[UIColor clearColor]];
    [site setTextColor:[UIColor whiteColor]];
    [site setTextAlignment:NSTextAlignmentRight];
    site.text = @"آدرس سایت:www.irimo.ir ";
    [self.view addSubview:site];
    
    UILabel *developer = [[UILabel alloc]initWithFrame:CGRectMake(0,self.view.bounds.size.height-55, self.view.bounds.size.width, 50)];
    
    [developer setAdjustsFontSizeToFitWidth:YES];
    [developer setFont:[UIFont fontWithName:@"B Koodak" size:11]];
    [developer setBackgroundColor:[UIColor clearColor]];
    [developer setTextColor:[UIColor whiteColor]];
    [developer setTextAlignment:NSTextAlignmentCenter];
    developer.text = @"Designed by ayandeh majazi co.";
    [self.view addSubview:developer];
    
    UILabel *developerWebsite = [[UILabel alloc]initWithFrame:CGRectMake(0,self.view.bounds.size.height-40, self.view.bounds.size.width, 50)];
    
    [developerWebsite setAdjustsFontSizeToFitWidth:YES];
    [developerWebsite setFont:[UIFont fontWithName:@"B Koodak" size:11]];
    [developerWebsite setBackgroundColor:[UIColor clearColor]];
    [developerWebsite setTextColor:[UIColor whiteColor]];
    [developerWebsite setTextAlignment:NSTextAlignmentCenter];
    developerWebsite.text = @"www.Gamamn.ir";
    [self.view addSubview:developerWebsite];
    
//    ایمیل سازمان : pr@irimo.ir
//    تلفکس:  021-66070014
//    شماره پیامک : 20134
//    آدرس سایت:www.irimo.ir
    
    
}

- (void)doneButtonPressed
{
    [self performSegueWithIdentifier:@"aboutToMain" sender:self];
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
