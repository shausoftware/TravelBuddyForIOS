//
//  MapViewController.m
//  ShauMapMobile
//
//  Created on 04/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    infoWindowOpening = false;
    
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    appIcons = [app getAppIcons];
    
    kmlParser = [ShauKmlParser alloc];
    markers = [NSMutableDictionary new];

    //current positiond
    currentPosition = [app getCurrentPosition];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: currentPosition.latitude
                                                            longitude: currentPosition.longitude
                                                                 zoom: 16];
    
    gMap = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    gMap.myLocationEnabled = YES;
    gMap.settings.myLocationButton = YES;
    gMap.settings.compassButton = YES;
    gMap.delegate = self;
    
    self.view = gMap;
    
    [self configureToolbarItems];
}

- (void) configureToolbarItems {

    UIBarButtonItem *helpAndInfoButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"ic_action_help"] style: UIBarButtonItemStyleDone target:self action:@selector(openHelpAndInfoView)];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"ic_action_search"] style: UIBarButtonItemStyleDone target:self action:@selector(openSearchView)];
    UIBarButtonItem *alertsButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"ic_action_error"] style: UIBarButtonItemStyleDone target:self action:@selector(openAlertsView)];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"ic_action_settings"] style: UIBarButtonItemStyleDone target:self action:@selector(openShauSettingsView)];
    
    self.navigationItem.rightBarButtonItems = @[settingsButton, alertsButton, searchButton, helpAndInfoButton];
}

- (void) openHelpAndInfoView {
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    UIViewController *helpAndInfoViewController = [[ShauAppInfoViewController alloc] init];
    helpAndInfoViewController.title = @"Help and Info";
    [app pushView: helpAndInfoViewController];
}

- (void) openSearchView {
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    UIViewController *searchViewController = [[ShauSearchViewController alloc] init];
    searchViewController.title = @"Search";
    [app pushView: searchViewController];
}

- (void) openAlertsView {
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    UIViewController *alertsViewController = [[ShauAlertsViewController alloc] init];
    alertsViewController.title = @"Alerts & Map Key";
    [app pushView: alertsViewController];
}

- (void) openShauSettingsView {
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    UIViewController *settingsViewController = [[ShauSettingsViewController alloc] init];
    settingsViewController.title = @"Alert Settings";
    [app pushView: settingsViewController];
}

- (void) loadKmlData {
    
    //get bounds of current view
    CLLocationCoordinate2D southWest = gMap.projection.visibleRegion.nearLeft;
    CLLocationCoordinate2D northEast = gMap.projection.visibleRegion.farRight;
    
    //generate KML URL
    NSString *bbox = [NSString stringWithFormat: @"?BBOX=%g,%g,%g,%g", southWest.longitude, southWest.latitude, northEast.longitude, northEast.latitude];
    NSString *URLString = [@"http://www.shaustuff.com/kml/River Boat/Hail and Ride/Bus Stop/Tube Station/Train Station" stringByAppendingString: bbox];
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:URLString];

    //download data
    [AppDelegate downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        
        // Check if any data returned.
        if (data != nil) {
            
            //clear markers
            [gMap clear];
            //clear marker references
            markers = [NSMutableDictionary new];
            
            //parse kml
            [kmlParser parseKml: data];
            
            NSMutableArray *geometries = [kmlParser getLoadedGeometries];
            NSString *lastKmlUpdate = [kmlParser getLastKmlUpdate];
            AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
            [app setLastKmlUpdate: lastKmlUpdate];
            
            //iterate through geometries
            for (int i = 0; i < [geometries count]; i++) {
                
                ShauKmlGeometry *geometry = [geometries objectAtIndex: i];
                
                //only draw if valid and not already on map
                if (!markers[[geometry getLink]]) {
                    if ([geometry isValid]) {
                        [self drawGeometry: geometry];
                    }
                }
            }
        }
    }];
}

- (void) drawGeometry: (ShauKmlGeometry *) kmlGeometry {
    
    //Marker
    NSMutableArray *coordinates = [kmlGeometry getCoordinates];
    CLLocationCoordinate2D position = [[coordinates objectAtIndex: 0] getLocation];
        
    //check if position valid - if not get a valid one
    position = [self getNextValidMarkerPosition: position];
        
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = position;
    marker.title = [kmlGeometry getStopName];
    if ([kmlGeometry getStopCategory] == kShauMapMobile_TransportCategoryBusStop ||
        [kmlGeometry getStopCategory] == kShauMapMobile_TransportCategoryHailAndRide ||
        [kmlGeometry getStopCategory] == kShauMapMobile_TransportCategoryRiverBoat) {
        marker.snippet = [kmlGeometry getStopRoute];
    }
    marker.icon = [self getIcon: kmlGeometry];
    marker.map = gMap;
        
    //so we can get url to open on click event
    [markers setObject: marker forKey: [kmlGeometry getLink]];
}

- (CLLocationCoordinate2D) getNextValidMarkerPosition: (CLLocationCoordinate2D) position {

    for (id key in markers.allKeys) {

        GMSMarker *marker = [markers objectForKey: key];
        if (marker.position.latitude == position.latitude && marker.position.longitude == position.longitude) {
            //position clash
            //move marker up a bit
            position.latitude += 0.0003f;
            //try again
            position = [self getNextValidMarkerPosition: position];
        }
    }
    
    return position;
}

- (UIImage *) getIcon: (ShauKmlGeometry *) kmlGeometry {
   
    UIImage *icon = [appIcons objectForKey: [kmlGeometry getIconName]];

    return icon;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GMSMapViewDelegate

- (void) mapView: (GMSMapView *) mapView idleAtCameraPosition: (GMSCameraPosition *) position {
    
    if (infoWindowOpening) {
        infoWindowOpening = false;
    } else {
        if (position.zoom > 14) {
            [self loadKmlData];
        }
    }
}

-(BOOL) mapView: (GMSMapView *) mapView didTapMarker: (GMSMarker *)marker {
    infoWindowOpening = true;
    return NO;
}

- (void) mapView: (GMSMapView *) mapView didTapInfoWindowOfMarker: (GMSMarker *) marker {
    
    for (id key in markers.allKeys) {
        GMSMarker *value = [markers objectForKey: key];
        if (value.hash == marker.hash) {
            //use key as url to open browser
            NSURL *url = [NSURL URLWithString: key];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void) locationManager: (CLLocationManager *) manager didUpdateLocations: (NSArray *) locations {
    
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    bool foundMe = [app isFoundMe];
    
    if (!foundMe) {
        
        //at start move to where we are now
        CLLocation *here = [locations lastObject];
        currentPosition.latitude = here.coordinate.latitude;
        currentPosition.longitude = here.coordinate.longitude;
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: currentPosition.latitude longitude: currentPosition.longitude zoom: 16];
        [gMap setCamera: camera];
        [app foundMe: true];
    }
}

@end
