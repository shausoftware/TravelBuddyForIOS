//
//  ShauKmlParser.h
//  ShauMapMobile
//
//  Created on 05/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ShauKmlGeometry.h"

#ifndef ShauMapMobile_ShauKmlParser_h
#define ShauMapMobile_ShauKmlParser_h

@interface ShauKmlParser : NSObject <NSXMLParserDelegate> {

    bool inPlacemark;
    bool inCoordinates;
    bool inExtendedData;
    bool inData;
    bool inValue;
    bool inLastUpdate;
    
    NSString *fieldName;
    NSString *stopType;
    NSString *lastUpdate;
    ShauKmlGeometry *geometry;
}

@property (nonatomic, strong) NSXMLParser *xmlParser;

@property (nonatomic, strong) NSMutableArray *geometries;

@property (nonatomic, strong) NSMutableDictionary *dictTempDataStorage;

@property (nonatomic, strong) NSMutableString *foundValue;

@property (nonatomic, strong) NSString *currentElement;

- (void) parseKml: (NSData *) kmlData;

- (NSMutableArray *) getLoadedGeometries;
- (NSString *) getLastKmlUpdate;

- (void) parserDidStartDocument: (NSXMLParser *) parser;

- (void) parserDidEndDocument: (NSXMLParser *) parser;

- (void) parser: (NSXMLParser *) parser parseErrorOccurred: (NSError *) parseError;

- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName
                                         namespaceURI: (NSString *) namespaceURI
                                        qualifiedName: (NSString *) qName
                                           attributes: (NSDictionary *) attributeDict;

- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName
                                        namespaceURI: (NSString *) namespaceURI
                                       qualifiedName: (NSString *) qName;

- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) string;

@end

#endif
