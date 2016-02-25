//
//  ShauKmlGeometry.h
//  ShauMapMobile
//
//  Created on 04/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ShauLatLng.h"

#ifndef ShauMapMobile_ShauKmlGeometry_h
#define ShauMapMobile_ShauKmlGeometry_h

enum {
    kShauMapMobile_TransportCategoryUndefined = 0,
    kShauMapMobile_TransportCategoryBusStop = 1,
    kShauMapMobile_TransportCategoryTubeStation = 2,
    kShauMapMobile_TransportCategoryTrainStation = 3,
    kShauMapMobile_TransportCategoryRiverBoat = 4,
    kShauMapMobile_TransportCategoryHailAndRide = 5,
    kShauMapMobile_TransportCategoryLocation = 6
};

@interface ShauKmlGeometry : NSObject {
    
    int mStopCategory;
    NSString *mStopName;
    NSString *mStopRoute;
    NSString *mStopId;
    NSString *mStopLink;
    NSString *mSettingSlot;
    
    NSMutableArray *coordinates;
    
    NSString *STATE_UNDEFINED;
    NSString *STATE_DELIMITER;
    
    bool mValid;
}

- (void) initialiseState;

- (void) buildGeometry: (NSString *) geometryString;
- (void) buildLink;

- (void) setSettingsSlot: (NSString *) slot;
- (NSString *) getSettingsSlot;

- (void) setStateFromString: (NSString *) stateAsString;
- (NSString *) getStateAsString;

- (bool) isValid;

- (NSString *) getLink;

- (NSMutableArray *) getCoordinates;

- (void) setStopCategory: (int) stopCategory;
- (int) getStopCategory;

- (void) setStopName: (NSString *) stopName;
- (NSString *) getStopName;

- (void) setStopRoute: (NSString *) stopRoute;
- (NSString *) getStopRoute;

- (void) setStopId: (NSString *) stopId;
- (NSString *) getStopId;

- (NSString *) getIconName;

@end
#endif
