//
//  TubeLineStatus.m
//  ShauMapMobile
//
//  Created on 22/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//

#import "TubeLineStatus.h"

@implementation TubeLineStatus

- (void) setLineName: (NSString *) name {
    lineName = name;
}
- (NSString *) getLineName {
    return lineName;
}

- (void) setLineStatusDetails: (NSString *) statusDetails {
    lineStatusDetails = statusDetails;
}
- (NSString *) getLineStatusDetails {
    return lineStatusDetails;
}

- (void) setLineStatusDescription: (NSString *) statusDescripton {
    lineStatusDescription = statusDescripton;
}
- (NSString *) getLineStatusDescription {
    return lineStatusDescription;
}

- (void) setLineOk: (bool) ok {
    lineOk = ok;
}
- (bool) getLineOk {
    return lineOk;
}

@end
