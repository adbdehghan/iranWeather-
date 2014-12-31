//
//  WarningsViewController.m
//  Iran Weather
//
//  Created by aDb on 12/31/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import "WarningsViewController.h"
#import "APPaginalTableView.h"
#import "MKPersianFont.h"
#import "DataDownloader.h"
#import "PendulumView.h"

@interface WarningsViewController () < APPaginalTableViewDataSource,
APPaginalTableViewDelegate >

@property (strong, nonatomic) UINavigationBar       *navigationBar;

// Done button inside navigation bar
@property (strong, nonatomic) UIBarButtonItem       *doneButton;

@property (strong, nonatomic) DataDownloader *getData;

@property (strong, nonatomic) NSMutableDictionary *warningsDictionary;

@property (strong, nonatomic) NSMutableArray *warningsTitle;

@end

@implementation WarningsViewController{
    APPaginalTableView *_paginalTableView;
    UIView *container;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.warningsTitle = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
    [self.view addSubview:self.blurredOverlayView];
    
    container = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    [self.view addSubview:container];
    
    PendulumView *pendulum = [[PendulumView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-50, self.view.frame.size.height/2, 100, 40) ballColor:[UIColor whiteColor] ballDiameter:14];
    pendulum.tag=12;
    [self.view addSubview:pendulum];
    
    
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
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc]initWithTitle:@"هشدارها"];
    [navigationItem setRightBarButtonItem:self.doneButton];
    [self.navigationBar setItems:@[navigationItem]];
    
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        if (wasSuccessful)
        {
            self.warningsDictionary = data;
            
            for (NSString *item in self.warningsDictionary)
            {
                [self.warningsTitle addObject:item];
            }
            
            _paginalTableView = [[APPaginalTableView alloc] initWithFrame:CGRectMake(0, 0, container.bounds.size.width, container.bounds.size.height)];
            
            _paginalTableView.dataSource = self;
            _paginalTableView.delegate = self;
            _paginalTableView.backgroundColor = [UIColor clearColor];
            [container addSubview:_paginalTableView];
            
            
   
            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
            
            for (UIView *item in self.view.subviews) {
                if (item.tag == 12) {
                    [item removeFromSuperview];
                }
                
            }
            
            
        }
        
        else {
            NSLog( @"Unable to fetch Data. Try again.");
        }
    };
    
    [self.getData RequestWarnings:callback];

}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}


- (void)doneButtonPressed
{
    [self performSegueWithIdentifier:@"WarningsToMain" sender:self];
}

#pragma mark - APPaginalTableViewDataSource

- (NSUInteger)numberOfElementsInPaginalTableView:(APPaginalTableView *)managerView
{
    return [self.warningsTitle count];
}

- (UIView *)paginalTableView:(APPaginalTableView *)paginalTableView collapsedViewAtIndex:(NSUInteger)index
{
    UIView *collapsedView = [self createCollapsedViewAtIndex:index];
    return collapsedView;
}

- (UIView *)paginalTableView:(APPaginalTableView *)paginalTableView expandedViewAtIndex:(NSUInteger)index
{
    UIView *expandedView = [self createExpandedViewAtIndex:index];
    return expandedView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - APPaginalTableViewDelegate

- (BOOL)paginalTableView:(APPaginalTableView *)managerView
      openElementAtIndex:(NSUInteger)index
      onChangeHeightFrom:(CGFloat)initialHeight
                toHeight:(CGFloat)finalHeight
{
    BOOL open = _paginalTableView.isExpandedState;
    APPaginalTableViewElement *element = [managerView elementAtIndex:index];
    
    if (initialHeight > finalHeight) { //open
        open = finalHeight > element.expandedHeight * 0.8f;
    }
    else if (initialHeight < finalHeight) { //close
        open = finalHeight > element.expandedHeight * 0.2f;
    }
    return open;
}

- (void)paginalTableView:(APPaginalTableView *)paginalTableView didSelectRowAtIndex:(NSUInteger)index
{
    [_paginalTableView openElementAtIndex:index completion:nil animated:YES];
}

#pragma mark - Internal

- (UIView *)createCollapsedViewAtIndex:(NSUInteger)index
{
    NSString *text =[[[self.warningsTitle objectAtIndex:index]valueForKey:@"Title"]valueForKey:@"text"];
    text = [text stringByAppendingString:[NSString stringWithFormat:@"   -   %@",[[[self.warningsTitle objectAtIndex:index]valueForKey:@"Date"]valueForKey:@"text"]]];
    
    UILabel *labelCollapsed = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.f, container.bounds.size.width, 50.f)];
    labelCollapsed.text = text;
    
    [labelCollapsed setTextAlignment:NSTextAlignmentCenter];
    
    [labelCollapsed setAdjustsFontSizeToFitWidth:YES];
    [labelCollapsed setFont:[UIFont fontWithName:@"B Koodak" size:18]];
    [labelCollapsed setBackgroundColor:[UIColor clearColor]];
    [labelCollapsed setTextColor:[UIColor whiteColor]];
    
    UIView *collapsedView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, container.bounds.size.width, 80.f)];
    collapsedView.backgroundColor = [UIColor clearColor];
    collapsedView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [collapsedView addSubview:labelCollapsed];
    
    return collapsedView;
}

- (UIView *)createExpandedViewAtIndex:(NSUInteger)index
{
    UITextView *labelExpanded = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, container.bounds.size.width, container.bounds.size.height)];
    
    labelExpanded.text = [[[self.warningsTitle objectAtIndex:index]valueForKey:@"Content"]valueForKey:@"text"];
    
    //labelExpanded.lineBreakMode = NSLineBreakByWordWrapping;
    //labelExpanded.numberOfLines = 0;
    
    [labelExpanded setTextAlignment:NSTextAlignmentRight];
    
    //[labelExpanded setAdjustsFontSizeToFitWidth:YES];
    
    [labelExpanded setFont:[UIFont fontWithName:@"B Koodak" size:24]];
    [labelExpanded setBackgroundColor:[UIColor clearColor]];
    [labelExpanded setTextColor:[UIColor whiteColor]];
    
    UIView *expandedView = [[UIView alloc] initWithFrame:self.view.bounds];
    expandedView.backgroundColor = [UIColor clearColor];
    [expandedView addSubview:labelExpanded];
    
    return expandedView;
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
