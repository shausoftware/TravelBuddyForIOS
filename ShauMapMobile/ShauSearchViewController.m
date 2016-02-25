//
//  ShauSearchViewController.m
//  ShauMapMobile
//
//  Created on 12/03/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//
#import "ShauSearchViewController.h"

@implementation ShauSearchViewController

@synthesize myLocations;

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    float screenWidth = self.view.frame.size.width;
    self.view.backgroundColor = [UIColor blackColor];

    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;

    mAppIcons = [app getAppIcons];
    
    //search bar
    NSString *currentSearchParameter = [app getCurrentSearchParameter];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(0, 70, screenWidth, 50)];
    [searchBar setText: currentSearchParameter];
    [searchBar setDelegate: self];
    searchBar.barTintColor = [UIColor blackColor];
    [self.view addSubview: searchBar];
    
    //search help
    NSString *searchHelpText = @"Searches can be performed for the following:\n\n- Train stations\n- Tube Stations\n- Bus Stops\n- Piers\n- Tube Lines\n- Bus Routes\n- Places\n- Postcodes\n\nView results on the map or add them to the list of your favourite locations for further recall.\n";
    
    UITextView *searchHelpTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 450)];
    searchHelpTextView.textColor = [UIColor whiteColor];
    searchHelpTextView.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    searchHelpTextView.backgroundColor = [UIColor blackColor];
    searchHelpTextView.editable = false;
    searchHelpTextView.text = searchHelpText;
    
    [self.view addSubview: searchHelpTextView];
    
    //my locations
    myLocationsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 400, screenWidth, 200) style:UITableViewStylePlain];
    [myLocationsTableView setAllowsSelection: false];
    [myLocationsTableView setAutoresizesSubviews:YES];
    [myLocationsTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [myLocationsTableView setDelegate: self];
    [myLocationsTableView setDataSource: self];
    [self.view addSubview:myLocationsTableView];
}

- (void)viewWillAppear: (BOOL) animated {

    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    //sort array
    NSArray *sortedLocations = [[app getMyLocations] sortedArrayUsingComparator: ^NSComparisonResult(id a, id b) {
        
        ShauKmlGeometry *first = (ShauKmlGeometry *) a;
        ShauKmlGeometry *second = (ShauKmlGeometry *) b;
        
        if ([first getStopCategory] == kShauMapMobile_TransportCategoryUndefined) {
            if ([second getStopCategory] == kShauMapMobile_TransportCategoryUndefined) {
                return NSOrderedSame;
            }
            return NSOrderedDescending;
        } else if ([second getStopCategory] == kShauMapMobile_TransportCategoryUndefined) {
            return NSOrderedAscending;
        }
        
        return [[first getStopName] compare: [second getStopName]];
    }];
    myLocations = [NSMutableArray arrayWithArray: sortedLocations];
    
    [myLocationsTableView reloadData];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *) bar {
    
    //enable seaarch button even if empty
    UITextField *searchBarTextField = nil;
    
    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f) ? bar.subviews : [[bar.subviews objectAtIndex:0] subviews];
    
    for (UIView *subview in views) {
        if ([subview isKindOfClass:[UITextField class]]) {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    
    searchBarTextField.enablesReturnKeyAutomatically = NO;
}

- (void) searchBarSearchButtonClicked: (UISearchBar *) searchBar {
    
    NSString *searchText = [searchBar text];
    
    if ([searchText length] > 0) {
        
        //save current search for recall
        AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
        [app setCurrentSearchParameter: searchText];

        //open search results view
        UIViewController *searchResultsViewController = [[ShauSearchResultsViewController alloc] init];
        searchResultsViewController.title = @"Search Results";
        [(ShauSearchResultsViewController *) searchResultsViewController setSearchParameter: searchText];
        [app pushView: searchResultsViewController];
    }
    
    [searchBar resignFirstResponder];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection: (NSInteger) section {
    return @"My Locations";
}

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView {
    return 1;
}

- (NSInteger) tableView:( UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return [myLocations count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    
    static NSString *simpleTableIdentifier = @"SearchResultTableItem";
    
    ShauKmlGeometry *geometry = [myLocations objectAtIndex: indexPath.row];
    
    MyLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[MyLocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    
    [cell setGeometry: geometry withIcons: mAppIcons actionCompletion: ^(ShauKmlGeometry *result){[self loadMap: result];} mapCompletion: ^(ShauKmlGeometry *result){[self loadMap: result];} deleteCompletion: ^(ShauKmlGeometry *result){[self deleteMyLocation: result];}];
    
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void) loadMap: (ShauKmlGeometry *) selectedSearchResult {

    //set current position
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ShauLatLng *latLng = [[selectedSearchResult getCoordinates] objectAtIndex: 0];
    [app setCurrentPosition: latLng.getLocation];
    //open map
    [app openMapPage];
}

- (void) deleteMyLocation: (ShauKmlGeometry *) selectedSearchResult {

    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle: @"Alert"
                                          message: @"Delete selected location?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action) {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                   [app deleteLocation: selectedSearchResult];
                                   //reload page
                                   if ([self isViewLoaded]) {
                                       [self viewWillAppear: YES];
                                   }
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
