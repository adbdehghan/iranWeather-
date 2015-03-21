//
//  LocationManagerViewController.m
//  Iran Weather
//
//  Created by aDb on 12/20/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import "SettingsViewController.h"
#import "MKPersianFont.h"
#import "Settings.h"
#import "DBManager.h"

@interface SettingsViewController ()
@property (strong, nonatomic) UIView *ribbon;
// Displays the location metadata
@property (strong, nonatomic) UITableView           *locationsTableView;

// Navigation bar for the controller, contains the done button
@property (strong, nonatomic) UINavigationBar       *navigationBar;

// Done button inside navigation bar
@property (strong, nonatomic) UIBarButtonItem       *doneButton;

// Displays the title of the locations table view
@property (strong, nonatomic) UILabel               *locationsTableViewTitleLabel;

// Aesthetic line drawn beneath the locations table view title label
@property (strong, nonatomic) UIView                *tableSeparatorView;

// Control to change the temperature scale
@property (strong, nonatomic) UISegmentedControl    *temperatureControl;

@property (strong, nonatomic) UISegmentedControl    *localLocationControl;

@property (strong, nonatomic) UISegmentedControl    *speedControl;


@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
    [self.view addSubview:self.blurredOverlayView];
    
    self.ribbon = [[UIView alloc]initWithFrame:CGRectMake(0, 63 , self.view.bounds.size.width, 155)];
    [self.ribbon setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.25]];
    [self.view addSubview:self.ribbon];
    
    MKPersianFont *title = [[MKPersianFont alloc]init];
    [title setPersianFont:@"koodak" withText:@"موقعیت کنونی➣" fontSize:20 textAlignment:RIGHT textWrapped:YES fontColor:[UIColor whiteColor]];
    [title setFrame:CGRectMake(-4,20, self.ribbon.frame.size.width ,self.ribbon.frame.size.height)];
    
    [self.ribbon addSubview:title];
    
    MKPersianFont *tempTitle = [[MKPersianFont alloc]init];
    [tempTitle setPersianFont:@"koodak" withText:@"واحد دما" fontSize:20 textAlignment:RIGHT textWrapped:YES fontColor:[UIColor whiteColor]];
    [tempTitle setFrame:CGRectMake(-4,69, self.ribbon.frame.size.width ,self.ribbon.frame.size.height)];
    
    [self.ribbon addSubview:tempTitle];
    
    MKPersianFont *speedTitle = [[MKPersianFont alloc]init];
    [speedTitle setPersianFont:@"koodak" withText:@"واحد سرعت" fontSize:20 textAlignment:RIGHT textWrapped:YES fontColor:[UIColor whiteColor]];
    [speedTitle setFrame:CGRectMake(-4,116, self.ribbon.frame.size.width ,self.ribbon.frame.size.height)];
    
    [self.ribbon addSubview:speedTitle];
    
    
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
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc]initWithTitle:@"تنظیمات"];
    [navigationItem setRightBarButtonItem:self.doneButton];
    [self.navigationBar setItems:@[navigationItem]];
    
    
    [self initializeLocationsTableView];
    [self initializeTemperatureControl];
    [self initializeLocationsTableViewTitleLabel];
    [self initializeLocalLocationControl];
    [self initializeSpeedControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Show delete and reorder controls
    [self.locationsTableView setEditing:YES animated:YES];
    [self.locationsTableView reloadData];
    
    // Fade in locations table view title if there are table view elements
    CGFloat animationDuration = ([self.locations count] == 0)? 0.0: 0.3;
    [UIView animateWithDuration:animationDuration animations: ^ {
        self.tableSeparatorView.alpha = ([self.locations count] == 0)? 0.0: 1.0;
        self.locationsTableViewTitleLabel.alpha = ([self.locations count] == 0)? 0.0: 1.0;
    }];
}

#pragma mark Initialize Subviews

- (void)initializeLocationsTableView
{
    self.locationsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 253,
                                                                           CGRectGetWidth(self.view.bounds), self.view.center.y)
                                                          style:UITableViewStylePlain];
    self.locationsTableView.dataSource = self;
    self.locationsTableView.delegate = self;
    self.locationsTableView.backgroundColor = [UIColor clearColor];
    self.locationsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.locationsTableView];
}

- (void)initializeTemperatureControl
{
    self.temperatureControl = [[UISegmentedControl alloc]initWithItems:@[@"F°", @"C°"]];
    [self.temperatureControl setFrame:CGRectMake(5, 60, 120, 37)];
    //[self.temperatureControl setCenter:CGPointMake(self.view.center.x, 0.60 * self.view.center.y)];
    [self.temperatureControl addTarget:self action:@selector(temperatureControlChanged:) forControlEvents:UIControlEventValueChanged];
    [self.temperatureControl setSelectedSegmentIndex:[StateManager temperatureScale]];
    [self.temperatureControl setTintColor:[UIColor whiteColor]];
    [self.ribbon addSubview:self.temperatureControl];
}

- (void)initializeSpeedControl
{
    self.speedControl = [[UISegmentedControl alloc]initWithItems:@[@"m/s", @"km/h"]];
    [self.speedControl setFrame:CGRectMake(5, 107, 120, 37)];
    //[self.temperatureControl setCenter:CGPointMake(self.view.center.x, 0.60 * self.view.center.y)];
    [self.speedControl addTarget:self action:@selector(speedControlChanged:) forControlEvents:UIControlEventValueChanged];
    [self.speedControl setSelectedSegmentIndex:[StateManager speedScale]];
    [self.speedControl setTintColor:[UIColor whiteColor]];
    [self.ribbon addSubview:self.speedControl];
}

- (void)initializeLocalLocationControl
{
    self.localLocationControl = [[UISegmentedControl alloc]initWithItems:@[@"فعال", @"غیر فعال "]];
    [self.localLocationControl setFrame:CGRectMake(5, 12, 120, 37)];
    //[self.localLocationControl setCenter:CGPointMake(120,0)];
    [self.localLocationControl addTarget:self action:@selector(localLocationControlChanged:) forControlEvents:UIControlEventValueChanged];
    [self.localLocationControl setSelectedSegmentIndex:[StateManager local]];
    [self.localLocationControl setTintColor:[UIColor whiteColor]];
    [self.ribbon addSubview:self.localLocationControl];
}


- (void)initializeLocationsTableViewTitleLabel
{
    static const CGFloat fontSize = 20;
    
    // Initialize table view title label
    self.locationsTableViewTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 220,
                                                                                 CGRectGetWidth(self.view.bounds), 1.5 * fontSize)];
    [self.locationsTableViewTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize]];
    [self.locationsTableViewTitleLabel setTextColor:[UIColor whiteColor]];
    [self.locationsTableViewTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.locationsTableViewTitleLabel setText:@"موقعیت ها"];
    [self.view addSubview:self.locationsTableViewTitleLabel];
    
    // Initialize table view title separator
    self.tableSeparatorView = [[UIView alloc]initWithFrame:CGRectMake(16, 0, CGRectGetWidth(self.view.bounds) - 32, 0.5)];
    self.tableSeparatorView.center = CGPointMake(self.view.center.x, 250);
    self.tableSeparatorView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [self.view addSubview:self.tableSeparatorView];
}

#pragma mark Done Button Methods

- (void)doneButtonPressed
{
    [self performSegueWithIdentifier:@"settingToMain" sender:self];
}

#pragma mark Temperature Control Methods

- (void)temperatureControlChanged:(UISegmentedControl *)control
{
    TemperatureScale scale = (TemperatureScale)[control selectedSegmentIndex];
    [StateManager setTemperatureScale:scale];
    [self.delegate didChangeTemperatureScale:scale];
}

- (void)localLocationControlChanged:(UISegmentedControl *)control
{
    Local isLocal = (Local)[control selectedSegmentIndex];
    [StateManager setLocal:isLocal];
    [self.delegate didChangeLocal:isLocal];
}

- (void)speedControlChanged:(UISegmentedControl *)control
{
    SpeedScale scale = (SpeedScale)[control selectedSegmentIndex];
    [StateManager setSpeedScale:scale];
    [self.delegate didChangeSpeedScale:scale];
}

#pragma mark UITableViewDelegate Methods

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    // Dequeue a cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        // Initialize new cell if cell is null
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textAlignment = NSTextAlignmentRight;
    }
    
    // Configure the cell
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    // Set cell's label text
    
    
    Settings *location = [self.locations objectAtIndex:indexPath.row];
    
    cell.textLabel.text = location.cityInfo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Remove the location with the associated tag, alert the delegate
//        NSNumber *weatherViewTag = [[self.locations objectAtIndex:indexPath.row]lastObject];
//        [self.delegate didRemoveWeatherViewWithTag: weatherViewTag.integerValue];

        NSString *knownObject =  [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        NSString *key;
        
        for (Settings *object in self.locations) {
            if ([object.cityInfo isEqual:knownObject]) {
                key=object.settingId;
            }
        }
        
        [DBManager deleteRow:key];
        
        [self.locations removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
        
        // Fade out the locations table view title label if there are no elements
        [UIView animateWithDuration:0.3 animations: ^ {
            self.locationsTableViewTitleLabel.alpha = ([self.locations count] == 0)? 0.0: 1.0;
            self.tableSeparatorView.alpha = ([self.locations count] == 0)? 0.0: 1.0;
        }];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
//    NSArray *locationMetaData = [self.locations objectAtIndex:sourceIndexPath.row];
//    [self.locations removeObjectAtIndex:sourceIndexPath.row];
//    [self.locations insertObject:locationMetaData atIndex:destinationIndexPath.row];
   // [self.delegate didMoveWeatherViewAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.locations count];
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
