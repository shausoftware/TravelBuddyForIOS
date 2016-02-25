//
//  ShauLatLng.h
//  ShauMapMobile
//
//  Created on 06/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//
#import <GoogleMaps/GoogleMaps.h>

#import <UIKit/UIKit.h>

#ifndef ShauMapMobile_ShauLatLng_h
#define ShauMapMobile_ShauLatLng_h


@interface ShauLatLng : NSObject {
    
    double latitide;
    double longitude;
}

- (void) setLatWith: (double) lat Lng: (double) lng;
- (void) offsetLatWith: (double) lat Lng: (double) lng;


- (CLLocationCoordinate2D) getLocation;

- (NSString *) getCoordinatesAsString;

@end
#endif
