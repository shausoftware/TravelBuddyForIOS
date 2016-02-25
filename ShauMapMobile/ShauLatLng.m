//
//  ShauLatLng.m
//  ShauMapMobile
//
//  Created on 06/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShauLatLng.h"

@implementation ShauLatLng


- (void) setLatWith: (double) lat Lng: (double) lng {
    latitide = lat;
    longitude = lng;
}

- (void) offsetLatWith: (double) lat Lng: (double) lng {
    latitide += lat;
    longitude += lng;
}

- (CLLocationCoordinate2D) getLocation {
    return CLLocationCoordinate2DMake(latitide, longitude);
}

- (NSString *) getCoordinatesAsString {
    
    NSString *coordinatesAsString = [NSString stringWithFormat: @"%f", latitide];
    coordinatesAsString = [coordinatesAsString stringByAppendingString: @",%f"];
    coordinatesAsString = [NSString stringWithFormat: coordinatesAsString, longitude];
    
    return coordinatesAsString;
}

@end