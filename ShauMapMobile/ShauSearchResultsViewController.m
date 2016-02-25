//
//  ShauSearchResultsViewController.m
//  ShauMapMobile
//
//  Created on 12/03/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//

#import "ShauSearchResultsViewController.h"

@implementation ShauSearchResultsViewController

@synthesize searchResults;

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    kmlParser = [ShauKmlParser alloc];
    
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    appIcons = [app getAppIcons];
    enableSave = [app isLocationSlotAvailable];
    
    if ([mSearchParameter length] > 0) {
        [self search];
    }
}

- (void) setSearchParameter: (NSString *) searchParameter {
    mSearchParameter = searchParameter;
}

- (NSString *) prepareSearchParameter {
    
    NSString *preparedSearchParameter = [mSearchParameter stringByReplacingOccurrencesOfString: @" " withString: @"%20"];
    preparedSearchParameter = [preparedSearchParameter stringByReplacingOccurrencesOfString: @"&" withString: @"and"];
    preparedSearchParameter = [preparedSearchParameter stringByReplacingOccurrencesOfString: @"?" withString: @""];
    preparedSearchParameter = [preparedSearchParameter stringByReplacingOccurrencesOfString: @"'" withString: @""];
    
    return preparedSearchParameter;
}


- (void) search {
    
    NSString *searchParameter = [self prepareSearchParameter];
    
    NSString *URLString = [@"http://www.shaustuff.com/kml/search?SEARCH_PARAMETER=" stringByAppendingString: searchParameter];
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:URLString];
    
    //download data
    [AppDelegate downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        
        // Check if any data returned.
        if (data != nil) {
            
            //parse kml
            [kmlParser parseKml: data];
            searchResults = [kmlParser getLoadedGeometries];
            
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView {
    [tableView setAllowsSelection: false];
    return 1;
}

- (NSInteger) tableView:( UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return [searchResults count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    
    static NSString *simpleTableIdentifier = @"SearchResultTableItem";
    
    ShauKmlGeometry *geometry = [searchResults objectAtIndex: indexPath.row];

    LocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
    if (cell == nil) {
        cell = [[LocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    [cell setGeometry: geometry withIcons: appIcons enableSave: enableSave actionCompletion: ^(ShauKmlGeometry *result){[self loadMap: result];} mapCompletion: ^(ShauKmlGeometry *result){[self loadMap: result];} saveCompletion: ^(ShauKmlGeometry *result){[self saveMyLocation: result];} ];

    cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}

- (void) loadMap: (ShauKmlGeometry *) selectedSearchResult {

    //set current position
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableArray *coords = [selectedSearchResult getCoordinates];
    ShauLatLng *latLng = [coords objectAtIndex: 0];
    [app setCurrentPosition: latLng.getLocation];
    //open map
    [app openMapPage];
}

- (void) saveMyLocation: (ShauKmlGeometry *) selectedSearchResult {
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [app addLocation: selectedSearchResult];
    //go back to search
    [app popView];
}

@end
