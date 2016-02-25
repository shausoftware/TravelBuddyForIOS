//
//  RouteAlert.h
//  ShauMapMobile
//
//  Created on 21/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef ShauMapMobile_RouteAlert_h
#define ShauMapMobile_RouteAlert_h

@interface RouteAlert : NSObject {
    NSString *routeName;
    NSString *imageName;
    bool alertOn;
    bool hasAlert;
}

- (id) initWithRouteName: (NSString *) route image : (NSString *) image hasAlert: (bool) enabled on: (bool) on;

- (void) setRouteName: (NSString *) name;
- (NSString *) getRouteName;

- (void) setImageName: (NSString *) name;
- (NSString *) getImageName;

- (void) setAlertOn: (bool) on;
- (bool) getAlertOn;


@end
#endif
