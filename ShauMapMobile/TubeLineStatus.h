//
//  TubeLineStatus.h
//  ShauMapMobile
//
//  Created on 22/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef ShauMapMobile_TubeLineStatus_h
#define ShauMapMobile_TubeLineStatus_h

@interface TubeLineStatus : NSObject {
    
    NSString *lineName;
    NSString *lineStatusDetails;
    NSString *lineStatusDescription;
    bool lineOk;
}

- (void) setLineName: (NSString *) name;
- (NSString *) getLineName;

- (void) setLineStatusDetails: (NSString *) statusDetails;
- (NSString *) getLineStatusDetails;

- (void) setLineStatusDescription: (NSString *) statusDescripton;
- (NSString *) getLineStatusDescription;

- (void) setLineOk: (bool) ok;
- (bool) getLineOk;

@end

#endif
