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
    [logo setFrame:CGRectMake(0, self.view.bounds.size.height/3, self.view.bounds.size.width, 140)];
    [self.view addSubview:logo];
    
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
