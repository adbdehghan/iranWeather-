//
//  SOLAddLocationViewController.h
//  Sol
//
//  Created by Comyar Zaheri on 9/20/13.
//  Copyright (c) 2013 Comyar Zaheri. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddLocationViewControllerDelegate <NSObject>



/**
 Called by a AddLocationViewController when the view controller needs to
 be dismissed.
 */
- (void)dismissAddLocationViewController;

@end

@interface AddLocationViewController : UIViewController <UISearchDisplayDelegate, UISearchBarDelegate, UIScrollViewDelegate>
@property (strong, nonatomic)  UIImageView *blurredOverlayView;
@property (strong, nonatomic)  NSMutableDictionary *citiesDictionary;
@property (strong, nonatomic)  NSMutableArray *filterdCitiesList;
@property (strong, nonatomic)  NSMutableArray *citiesList;
@property (strong, nonatomic)  UITableView *citiesTable;
@property (nonatomic, strong) UITableView *tableView;
// -----
// @name Properties
// -----

// Object implementing the AddLocationViewControllerDelegate protocol
@property (weak, nonatomic) id<AddLocationViewControllerDelegate> delegate;

@end
