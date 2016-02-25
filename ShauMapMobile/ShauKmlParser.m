//
//  ShauKmlParser.m
//  ShauMapMobile
//
//  Created on 05/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//

#import "ShauKmlParser.h"
#import <Foundation/Foundation.h>

@implementation ShauKmlParser 

NSString const* ATTR_PLACEMARK = @"Placemark";
NSString const* ATTR_COORDINATES = @"coordinates";
NSString const* ATTR_EXTENDED_DATA = @"ExtendedData";
NSString const* ATTR_DATA = @"Data";
NSString const* ATTR_VALUE = @"value";
NSString const* ATTR_LAST_UPDATE = @"LastDataUpdate";

- (void) parseKml: (NSData *) kmlData {
    
    inPlacemark = false;
    inCoordinates = false;
    inExtendedData = false;
    inData = false;
    inValue = false;
    inLastUpdate = false;
    
    self.xmlParser = [[NSXMLParser alloc] initWithData:kmlData];
    self.xmlParser.delegate = self;
    
    // Initialize the mutable string that we'll use during parsing.
    self.foundValue = [[NSMutableString alloc] init];
    
    // Start parsing.
    [self.xmlParser parse];
}

- (NSMutableArray *) getLoadedGeometries {
    return self.geometries;
}

- (NSString *) getLastKmlUpdate {
    return lastUpdate;
}

- (void) parserDidStartDocument: (NSXMLParser *) parser {
    //Initialize the geometry data array.
    self.geometries = [[NSMutableArray alloc] init];
}

- (void) parserDidEndDocument: (NSXMLParser *) parser {
    
}

- (void) parser: (NSXMLParser *) parser parseErrorOccurred: (NSError *) parseError {
    NSLog(@"%@", [parseError localizedDescription]);
}

- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName
                                           namespaceURI: (NSString *) namespaceURI
                                          qualifiedName: (NSString *) qName
                                             attributes: (NSDictionary *) attributeDict {
    
    if ([ATTR_LAST_UPDATE isEqualToString: elementName]) {
        inLastUpdate = true;
    } else if ([ATTR_PLACEMARK isEqualToString: elementName]) {
        geometry = [ShauKmlGeometry alloc];
        [geometry initialiseState];
        inPlacemark = true;
    } else if ([ATTR_COORDINATES isEqualToString: elementName]) {
        inCoordinates = true;
    } else if ([ATTR_EXTENDED_DATA isEqualToString: elementName]) {
        inExtendedData = true;
    } else if ([ATTR_DATA isEqualToString: elementName]) {
        fieldName = [attributeDict objectForKey: @"name"];
        inData = true;
    } else if ([ATTR_VALUE isEqualToString: elementName]) {
        inValue = true;
    }
}

- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName
                                         namespaceURI: (NSString *) namespaceURI
                                        qualifiedName: (NSString *) qName {
    
    if ([ATTR_LAST_UPDATE isEqualToString: elementName]) {
        inLastUpdate = false;
    } else if ([ATTR_PLACEMARK isEqualToString: elementName]) {
        [self.geometries addObject: geometry];
        inPlacemark = false;
    } else if ([ATTR_COORDINATES isEqualToString: elementName]) {
        inCoordinates = false;
    } else if ([ATTR_EXTENDED_DATA isEqualToString: elementName]) {
        inExtendedData = false;
    } else if ([ATTR_DATA isEqualToString: elementName]) {
        inData = false;
    } else if ([ATTR_VALUE isEqualToString: elementName]) {
        inValue = false;
    }
}

- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) string {
    
    if (inLastUpdate) {
        lastUpdate = string;
    }
    
    if (inCoordinates) {
        [geometry buildGeometry: string];
    }
    
    if (inExtendedData) {
        
        if (inData) {
            if (inValue) {
                
                if ([@"stopType" isEqualToString: fieldName]) {
                    stopType = string;
                } else {
                    
                    if ([@"Bus Stop" isEqualToString: stopType]) {
                        
                        //Bus Stops
                        if ([@"stopName" isEqualToString: fieldName]) {
                            //Bus Stop Name
                            [geometry setStopName: string];
                        } else if ([@"stopRoute" isEqualToString: fieldName]) {
                            //Bus Route
                            [geometry setStopRoute: string];
                        } else if ([@"stopId" isEqualToString: fieldName]) {
                            //Bus Stop Id
                            [geometry setStopId: string];
                            [geometry setStopCategory: kShauMapMobile_TransportCategoryBusStop];
                            [geometry buildLink];
/*
                            //debug if geometry invalid
                            if (![geometry isValid]) {
                                NSLog(@"* BUS STOP GEOMETRY INVALID *");
                                NSLog(@"name:%@", [geometry getStopName]);
                                NSLog(@"route:%@", [geometry getStopRoute]);
                                NSLog(@"id:%@", [geometry getStopId]);
                            }
 //*/
                        }

                    } else if ([@"Tube Station" isEqualToString: stopType]) {
                        
                        //Tube Stations
                        if ([@"stopName" isEqualToString: fieldName]) {
                            //Tube Station Name
                            [geometry setStopName: string];
                        } else if ([@"stopRoute" isEqualToString: fieldName]) {
                            //Tube Line
                            [geometry setStopRoute: string];
                        } else if ([@"stopId" isEqualToString: fieldName]) {
                            //Station Id
                            [geometry setStopId: string];
                            [geometry setStopCategory: kShauMapMobile_TransportCategoryTubeStation];
                            [geometry buildLink];
/*
                            //debug if geometry invalid
                            if (![geometry isValid]) {
                                NSLog(@"* TUBE STATION GEOMETRY INVALID *");
                                NSLog(@"name:%@", [geometry getStopName]);
                                NSLog(@"route:%@", [geometry getStopRoute]);
                                NSLog(@"id:%@", [geometry getStopId]);
                            }
 //*/
                        }
                        
                    } else if ([@"Train Station" isEqualToString: stopType]) {
                        
                        //Train Stations
                        if ([@"stopName" isEqualToString: fieldName]) {
                            //Station Name
                            [geometry setStopName: string];
                        } else if ([@"stopRoute" isEqualToString: fieldName]) {
                            //Station Route - not implemented
                            [geometry setStopRoute: string];
                        } else if ([@"stopId" isEqualToString: fieldName]) {
                            //Station Id
                            [geometry setStopId: string];
                            [geometry setStopCategory: kShauMapMobile_TransportCategoryTrainStation];
                            [geometry buildLink];
/*
                            //debug if geometry invalid
                            if (![geometry isValid]) {
                                NSLog(@"* TRAIN STATION GEOMETRY INVALID *");
                                NSLog(@"name:%@", [geometry getStopName]);
                                NSLog(@"route:%@", [geometry getStopRoute]);
                                NSLog(@"id:%@", [geometry getStopId]);
                            }
 //*/
                        }
                        
                    } else if ([@"Location" isEqualToString: stopType]) {
                        
                        //Location
                        if ([@"stopName" isEqualToString: fieldName]) {
                            //Location Name
                            [geometry setStopName: string];
                            [geometry setStopRoute: string];
                        } else if ([@"stopRoute" isEqualToString: fieldName]) {
                            //not implemented
                        } else if ([@"stopId" isEqualToString: fieldName]) {
                            
                            [geometry setStopId: string];
                            [geometry setStopCategory: kShauMapMobile_TransportCategoryLocation];
                            [geometry buildLink];
/*
                            //debug if geometry invalid
                            if (![geometry isValid]) {
                                NSLog(@"* LOCATION GEOMETRY INVALID *");
                                NSLog(@"name:%@", [geometry getStopName]);
                                NSLog(@"route:%@", [geometry getStopRoute]);
                                NSLog(@"id:%@", [geometry getStopId]);
                            }
 //*/
                        }
                    } else if ([@"River Boat" isEqualToString: stopType]) {

                        //Similar to Bus Stops
                        if ([@"stopName" isEqualToString: fieldName]) {
                            //Pier Name
                            [geometry setStopName: string];
                        } else if ([@"stopRoute" isEqualToString: fieldName]) {
                            //Pier Route
                            [geometry setStopRoute: string];
                        } else if ([@"stopId" isEqualToString: fieldName]) {
                            //Pier Id
                            [geometry setStopId: string];
                            [geometry setStopCategory: kShauMapMobile_TransportCategoryRiverBoat];
                            [geometry buildLink];
/*
                            //debug if geometry invalid
                            if (![geometry isValid]) {
                                NSLog(@"* RIVER PIER GEOMETRY INVALID *");
                                NSLog(@"name:%@", [geometry getStopName]);
                                NSLog(@"route:%@", [geometry getStopRoute]);
                                NSLog(@"id:%@", [geometry getStopId]);
                            }
 //*/
                        }
                        
                    } else if ([@"Hail and Ride" isEqualToString: stopType]) {

                        //Similar to Bus Stops
                        if ([@"stopName" isEqualToString: fieldName]) {
                            //Bus Stop Name
                            [geometry setStopName: string];
                        } else if ([@"stopRoute" isEqualToString: fieldName]) {
                            //Bus Route
                            [geometry setStopRoute: string];
                        } else if ([@"stopId" isEqualToString: fieldName]) {
                            //Bus Stop Id
                            [geometry setStopId: string];
                            [geometry setStopCategory: kShauMapMobile_TransportCategoryHailAndRide];
                            [geometry buildLink];
/*
                            //debug if geometry invalid
                            if (![geometry isValid]) {
                                NSLog(@"* HAILAND RIDE GEOMETRY INVALID *");
                                NSLog(@"name:%@", [geometry getStopName]);
                                NSLog(@"route:%@", [geometry getStopRoute]);
                                NSLog(@"id:%@", [geometry getStopId]);
                            }
 //*/
                        }
                    }
                }
            }
        }
    }
}

@end