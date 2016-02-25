//
//  RouteAlert.m
//  ShauMapMobile
//
//  Created on 21/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//

#import "RouteAlert.h"

@implementation RouteAlert

- (id) initWithRouteName: (NSString *) route image : (NSString *) image hasAlert: (bool) enabled on: (bool) on {
    
    self = [super init];
    
    routeName = route;
    imageName = image;
    alertOn = on;
    hasAlert = enabled;
    
    return self;
}

- (void) setRouteName: (NSString *) name {
    routeName = name;
}
- (NSString *) getRouteName {
    return routeName;
}

- (void) setImageName: (NSString *) name {
    imageName = name;
}
- (NSString *) getImageName {
    return imageName;
}

- (void) setAlertOn: (bool) on {
    alertOn = on;
}
- (bool) getAlertOn {
    if (!hasAlert) {
        return false;
    }
    return alertOn;
}

@end
