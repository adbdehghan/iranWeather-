//
//  MainView.m
//  Iran Weather
//
//  Created by aDb on 12/18/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import "MainView.h"
#import "DataDownloader.h"
#import "WeatherData.h"

@interface MainView ()
@property (strong, nonatomic) DataDownloader *getData;
@end

@implementation MainView

- (void)viewDidLoad {
    [super viewDidLoad];

    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        if (wasSuccessful) {
                WeatherData *wd = [WeatherData alloc];  
                [wd fillData:data];
        } else {
            NSLog( @"Unable to fetch price. Try again.");
        }
    };
    
    [self.getData requestData:@"40754"
                          withCallback:callback];

    
//    DataDownloader *dd = [DataDownloader alloc];
//    WeatherData *wd = [WeatherData alloc];    
//    NSDictionary *data = [dd Request:@"40754"];
    //[dd RequestCitiesList];
    //[wd fillData:data];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
