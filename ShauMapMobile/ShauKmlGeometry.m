//
//  ShauKmlGeometry.m
//  ShauMapMobile
//
//  Created on 04/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//
#import "ShauKmlGeometry.h"
#import <Foundation/Foundation.h>

@implementation ShauKmlGeometry

- (void) initialiseState {
    
    STATE_DELIMITER = @"&&&";
    STATE_UNDEFINED = @"UNDEFINED";
    
    mStopCategory = kShauMapMobile_TransportCategoryUndefined;
    mStopName = STATE_UNDEFINED;
    mStopRoute = STATE_UNDEFINED;
    mStopId = STATE_UNDEFINED;
    mStopLink = STATE_UNDEFINED;
}

- (void) setSettingsSlot: (NSString *) slot {
    mSettingSlot = slot;
}
- (NSString *) getSettingsSlot {
    return mSettingSlot;
}

- (void) setStateFromString: (NSString *) stateAsString {
    
    NSArray *split = [stateAsString componentsSeparatedByString: STATE_DELIMITER];
    
    NSString *sCategory = [split objectAtIndex: 0];
    mStopCategory = [sCategory intValue];
    mStopName = [split objectAtIndex: 1];
    mStopRoute = [split objectAtIndex: 2];
    mStopId = [split objectAtIndex: 3];
    mStopLink = [split objectAtIndex: 4];
    
    NSString *sCoords = [split objectAtIndex: 6];
    NSArray *coordsSplit = [sCoords componentsSeparatedByString: @":"];
    coordinates = [[NSMutableArray alloc] init];
    for (int i = 0; i < [coordsSplit count]; i++) {
        NSString *sCoord = [coordsSplit objectAtIndex: i];
        NSArray *coordSplit = [sCoord componentsSeparatedByString: @","];
        NSString *sLat = [coordSplit objectAtIndex: 0];
        NSString *sLon = [coordSplit objectAtIndex: 1];
        ShauLatLng *latLng = [[ShauLatLng alloc] init];
        [latLng setLatWith: [sLat doubleValue] Lng: [sLon doubleValue]];
        [coordinates addObject: latLng];
    }
}
- (NSString *) getStateAsString {
    
    NSString *state;
    
    state = [NSString stringWithFormat: @"%d", mStopCategory];
    state = [state stringByAppendingString: STATE_DELIMITER];
    state = [state stringByAppendingString: mStopName];
    state = [state stringByAppendingString: STATE_DELIMITER];
    state = [state stringByAppendingString: mStopRoute];
    state = [state stringByAppendingString: STATE_DELIMITER];
    state = [state stringByAppendingString: mStopId];
    state = [state stringByAppendingString: STATE_DELIMITER];
    state = [state stringByAppendingString: mStopLink];
    state = [state stringByAppendingString: STATE_DELIMITER];
    
    for (int i = 0; i < [coordinates count]; i++) {
        ShauLatLng *latLng = [coordinates objectAtIndex: i];
        if (i != 0) {
            state = [state stringByAppendingString: @":"];
        }
        state = [state stringByAppendingString: [latLng getCoordinatesAsString]];
    }

    return state;
}

- (NSString *) getIconName {

    NSString *iconName = @"undefined";
    
    if (kShauMapMobile_TransportCategoryBusStop == mStopCategory) {
        iconName = @"busstop";
    } else if (kShauMapMobile_TransportCategoryHailAndRide == mStopCategory) {
        iconName = @"hailandride";
    } else if (kShauMapMobile_TransportCategoryLocation == mStopCategory) {
        iconName = @"location";
    } else if (kShauMapMobile_TransportCategoryRiverBoat == mStopCategory) {
        iconName = @"river";
    } else if (kShauMapMobile_TransportCategoryTrainStation == mStopCategory) {
        iconName = @"trainstation";
    } else if (kShauMapMobile_TransportCategoryTubeStation == mStopCategory) {
        
        if ([mStopRoute isEqualToString: @"bakerloo"]) {
            iconName = @"bakerloo";
        } else if ([mStopRoute isEqualToString: @"central"]) {
            iconName = @"central";
        } else if ([mStopRoute isEqualToString: @"circle"]) {
            iconName = @"circle";
        } else if ([mStopRoute isEqualToString: @"district"]) {
            iconName = @"district";
        } else if ([mStopRoute isEqualToString: @"dlr"]) {
            iconName = @"dlr";
        } else if ([mStopRoute isEqualToString: @"hammersmith-city"]) {
            iconName = @"hammersmithcity";
        } else if ([mStopRoute isEqualToString: @"jubilee"]) {
            iconName = @"jubilee";
        } else if ([mStopRoute isEqualToString: @"northern"]) {
            iconName = @"northern";
        } else if ([mStopRoute isEqualToString: @"metropolitan"]) {
            iconName = @"metropolitan";
        } else if ([mStopRoute isEqualToString: @"piccadilly"]) {
            iconName = @"piccadilly";
        } else if ([mStopRoute isEqualToString: @"victoria"]) {
            iconName = @"victoria";
        } else if ([mStopRoute isEqualToString: @"waterloo-city"]) {
            iconName = @"dlr";
        }
    }
    
    return iconName;
}

- (bool) isValid {
    return mValid;
}

- (void) buildGeometry: (NSString *) geometryString {
    
    mValid = true;
    
    //split on carriage return line break
    NSArray *split = [geometryString componentsSeparatedByString:@"\r\n"];
    
    //initialise local coordinate array
    coordinates = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [split count]; i++) {
        
        NSString *line = [split objectAtIndex:i];
        
        line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        
        if (line != nil && [line length] > 0) {
            
            NSArray *coordpairs = [line componentsSeparatedByString:@","];
            
            if ([coordpairs count] > 1) {

                ShauLatLng *latLng = [[ShauLatLng alloc] init];
                [latLng setLatWith: [[coordpairs objectAtIndex:0] doubleValue] Lng: [[coordpairs objectAtIndex:1] doubleValue]];
                [coordinates addObject: latLng];

            } else {
                mValid = false;
            }
        }
    }
}

- (void) buildLink {
    
    if (mStopCategory == kShauMapMobile_TransportCategoryBusStop || mStopCategory == kShauMapMobile_TransportCategoryRiverBoat || mStopCategory == kShauMapMobile_TransportCategoryHailAndRide) {

        mStopLink = [@"http://m.countdown.tfl.gov.uk/arrivals/" stringByAppendingString:mStopId];
    
    } else if (mStopCategory == kShauMapMobile_TransportCategoryTubeStation) {
    
        mStopLink = [@"https://www.tfl.gov.uk/tube/timetable/" stringByAppendingString:mStopRoute];
        mStopLink = [mStopLink stringByAppendingString:@"?FromId="];
        mStopLink = [mStopLink stringByAppendingString:mStopId];
    
    } else if (mStopCategory == kShauMapMobile_TransportCategoryTrainStation) {
    
        mStopLink = [@"http://ojp.nationalrail.co.uk/service/ldbboard/dep/" stringByAppendingString:mStopId];
    }
}

- (NSString *) getLink {
    return mStopLink;
}

- (NSMutableArray *) getCoordinates {
    return coordinates;
}

- (void) setStopCategory: (int) stopCategory {
    mStopCategory = stopCategory;
}
- (int) getStopCategory {
    return mStopCategory;
}

- (void) setStopName: (NSString *) stopName {
    mStopName = stopName;
}
- (NSString *) getStopName {
    return mStopName;
}

- (void) setStopRoute: (NSString *) stopRoute {
    mStopRoute = stopRoute;
}
- (NSString *) getStopRoute {
    
    NSString *displayName = mStopRoute;
    if (mStopCategory == kShauMapMobile_TransportCategoryBusStop || mStopCategory == kShauMapMobile_TransportCategoryRiverBoat || mStopCategory == kShauMapMobile_TransportCategoryHailAndRide) {
        
        if (displayName != nil && [displayName length] > 0) {
            if ([displayName characterAtIndex:0] == 58) {
                //magic 58 = :
                displayName = [displayName substringFromIndex:1];
            }
        }
    }
    return displayName;
}

- (void) setStopId: (NSString *) stopId {
    mStopId = stopId;
}
- (NSString *) getStopId {
    return mStopId;
}

@end