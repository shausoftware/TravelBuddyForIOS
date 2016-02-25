//
//  MapViewController.h
//  ShauMapMobile
//
//  Created on 04/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "ShauKmlGeometry.h"
#import "ShauKmlParser.h"
#import "AppDelegate.h"
#import "ShauAppInfoViewController.h"
#import "ShauAlertsViewController.h"
#import "ShauSettingsViewController.h"
#import "ShauSearchViewController.h"

@interface MapViewController : UIViewController<GMSMapViewDelegate, CLLocationManagerDelegate> {
    GMSMapView *gMap;
    ShauKmlParser *kmlParser;
    NSMutableDictionary *markers;
    NSDictionary *appIcons;
    CLLocationCoordinate2D currentPosition;
    CLLocationManager *locationManager;
    
    BOOL infoWindowOpening;
}

- (void) loadKmlData;

- (void) drawGeometry: (ShauKmlGeometry *) kmlGeometry;

- (UIImage *) getIcon: (ShauKmlGeometry *) kmlGeometry;

- (CLLocationCoordinate2D) getNextValidMarkerPosition: (CLLocationCoordinate2D) position;

@end

