//
//  LocationManagerViewController.h
//  Iran Weather
//
//  Created by aDb on 12/20/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StateManager.h"

@protocol SettingsViewControllerDelegate <NSObject>

- (void)didMoveWeatherViewAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;

/**
 Called by a SettingsViewController when a weather view is removed by the user
 @param tag Tag of the weather view to remove
 */
- (void)didRemoveWeatherViewWithTag:(NSInteger)tag;

/**
 Called by a SettingsViewController when the user changes the temperature scale
 @param scale New temperature scale set by the user
 */
- (void)didChangeTemperatureScale:(TemperatureScale)scale;

- (void)didChangeSpeedScale:(SpeedScale)scale;

- (void)didChangeLocal:(Local)isLocal;

/**
 Called by a SettingsViewController when the controller needs to be dismissed
 */
- (void)dismissSettingsViewController;

@end

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// -----
// @name Properties
// -----

// List of location metadata to display in the locations table view
@property (strong, nonatomic)  NSMutableArray *locations;

@property (strong, nonatomic)  UIImageView *blurredOverlayView;

// Object that implements the SettingsViewController Delegate Protocol
@property (weak, nonatomic) id<SettingsViewControllerDelegate> delegate;
@end
