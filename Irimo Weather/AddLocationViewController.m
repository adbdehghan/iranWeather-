//
//  SOLAddLocationViewController.m
//  Sol
//
//  Created by Comyar Zaheri on 9/20/13.
//  Copyright (c) 2013 Comyar Zaheri. All rights reserved.
//

#import "AddLocationViewController.h"
#import "DataDownloader.h"
#import "WeatherData.h"
#import "Settings.h"
#import "DBManager.h"
#import "PendulumView.h"
#import "MKPersianFont.h"

#pragma mark - SOLAddLocationViewController Class Extension

@interface AddLocationViewController ()<UITableViewDataSource, UITableViewDelegate>


// Results of a search
@property (strong, nonatomic) NSMutableDictionary                *cityInfo;

// Location search results display controller
@property (strong, nonatomic) UISearchDisplayController     *searchController;

// -----
// @name Subviews
// -----

// Location search bar
@property (strong, nonatomic) UISearchBar                   *searchBar;

// Navigation bar at the top of the view
@property (strong, nonatomic) UINavigationBar *navigationBar;

@property (strong, nonatomic) UINavigationItem *navigationItem;

// Done button inside navigation bar
@property (strong, nonatomic) UIBarButtonItem *doneButton;

@property (strong, nonatomic) DataDownloader *getData;


@end


#pragma mark - SOLAddLocationViewController Implementation

@implementation AddLocationViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    self.citiesList = [[NSMutableArray alloc]init];
    self.cityInfo = [[NSMutableDictionary alloc]init];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.view.opaque = NO;
    [self.view addSubview:self.tableView];
    
//    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
    
    [self.view addSubview:self.blurredOverlayView];


    
    
    PendulumView *pendulum = [[PendulumView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-50, self.view.frame.size.height/2, 100, 40) ballColor:[UIColor whiteColor] ballDiameter:14];
    pendulum.tag=12;
    [self.view addSubview:pendulum];
    
    
    [self InitializeObjects];
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        if (wasSuccessful)
        {
            self.citiesDictionary = data;
            
            for (NSString *item in self.citiesDictionary)
            {
                [self.citiesList addObject:[item valueForKey:@"name"]];
                [self.cityInfo setValue:[item valueForKey:@"name"] forKey:[item valueForKey:@"id"]];
            }
            
            self.filterdCitiesList = [[NSMutableArray alloc]initWithCapacity:[self.citiesList count]];
            [self.tableView reloadData];
            
            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
            [self.searchController setActive:YES animated:NO];
            [self.searchController.searchBar becomeFirstResponder];
            
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
    
    [self.getData RequestCitiesList:callback];


}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}

- (void)InitializeObjects {
    
    self.navigationBar =[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 75, self.view.bounds.size.width, 75)];

    [self.view addSubview:self.navigationBar];
    
    
    self.searchBar = [UISearchBar new];
    self.searchBar.showsCancelButton = YES;
    [self.searchBar sizeToFit];
    self.searchBar.placeholder = @"نام شهر یا روستای خود را وارد نایید";

    UIView *barWrapper = [[UIView alloc]initWithFrame:CGRectMake(0, 45, self.searchBar.frame.size.width, self.searchBar.frame.size.height)];
    [barWrapper addSubview:self.searchBar];
    [barWrapper setBackgroundColor:[UIColor clearColor]];
    
    self.navigationItem =[[UINavigationItem alloc] initWithTitle:@""];
    
    self.navigationItem.titleView = barWrapper;

    [self.navigationBar setItems:[NSArray arrayWithObject:self.navigationItem] animated:YES];
    
    
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    

    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:@"بازگشت"];
    
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitleTextAttributes:@{
                                                             NSFontAttributeName : [UIFont fontWithName:@"B Koodak" size:15]
                                                             } forState:UIControlStateNormal];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    

      [self performSegueWithIdentifier:@"addLocationToMain" sender:self];
}

#pragma mark UIViewController Methods

- (void)viewDidAppear:(BOOL)animated
{
//    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//    [self.searchController setActive:NO animated:NO];
//    [self.searchController.searchBar resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self.delegate dismissAddLocationViewController];
}

#pragma mark DoneButton Methods

- (void)doneButtonPressed
{
    [self performSegueWithIdentifier:@"addLocationToMain" sender:self];
}

#pragma mark UISearchDisplayControllerDelegate Methods


- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
//    [tableView setFrame:CGRectMake(0, CGRectGetHeight(self.navigationBar.bounds), CGRectGetWidth(self.view.bounds),
//                                   CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.navigationBar.bounds))];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [tableView setFrame:CGRectMake(0, CGRectGetHeight(self.navigationBar.bounds), CGRectGetWidth(self.view.bounds),
                                       CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.navigationBar.bounds))];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.delegate = self;
        [self.view addSubview:tableView];
    }
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    // Update the filtered array based on the search text and scope.
    
    // Remove all objects from the filtered search array
    [self.filterdCitiesList removeAllObjects];
    
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",[searchText stringByReplacingOccurrencesOfString:@"ك" withString:@"ک"]];
    NSArray *tempArray = [self.citiesList filteredArrayUsingPredicate:predicate];
    
    self.filterdCitiesList = [NSMutableArray arrayWithArray:tempArray];
}

#pragma mark - UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}



#pragma mark UITableViewDelegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    // Dequeue cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textAlignment = NSTextAlignmentRight;
    }
    
    // Configure cell for the search results table view
    if(tableView == self.searchController.searchResultsTableView) {
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        NSString *cellText = [self.filterdCitiesList objectAtIndex:indexPath.row];
        
        cell.textLabel.text = cellText;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.searchController.searchResultsTableView)
    {
      NSString *knownObject =  [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        
      NSArray *temp = [self.cityInfo allKeysForObject:knownObject];
      NSString *key = [temp lastObject];
        
        Settings *setting = [[Settings alloc]init];
        setting.settingId = key;
        setting.cityInfo = knownObject;
        
        [DBManager createTable];
        [DBManager saveOrUpdataSetting:setting];
        [self performSegueWithIdentifier:@"addLocationToMain" sender:self];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.filterdCitiesList count];
    }
    else
    {
        return [self.citiesList count];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.navigationBar.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y,
                                          CGRectGetWidth(self.navigationBar.frame),
                                          CGRectGetHeight(self.navigationBar.frame));    
}



@end

