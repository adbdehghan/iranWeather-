//
//  MainView.h
//  Iran Weather
//
//  Created by aDb on 12/18/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddLocationViewController.h"
#import "WeatherView.h"
#import "Settings.h"
#import "RNFrostedSidebar.h"
#import <MessageUI/MessageUI.h>

@interface MainViewController : UIViewController <UIScrollViewDelegate, CLLocationManagerDelegate,AddLocationViewControllerDelegate,WeatherViewDelegate,RNFrostedSidebarDelegate,MFMessageComposeViewControllerDelegate>

// -----
// @name Properties
// -----

//  Location manager used to track the user's current location
@property (nonatomic, readonly) CLLocationManager   *locationManager;
@property (strong, nonatomic)  Settings *setting;

@end
