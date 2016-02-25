//
//  TubeLineParser.h
//  ShauMapMobile
//
//  Created on 22/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "TubeLineStatus.h"

#ifndef ShauMapMobile_TubeLineParser_h
#define ShauMapMobile_TubeLineParser_h

@interface TubeLineParser : NSObject <NSXMLParserDelegate> {
    TubeLineStatus *currentTubeLineStatus;
    bool inLineStatus;
    bool inDisruption;
}

@property (nonatomic, strong) NSXMLParser *xmlParser;

@property (nonatomic, strong) NSMutableDictionary *lineStatusMap;

@property (nonatomic, strong) NSMutableDictionary *dictTempDataStorage;

@property (nonatomic, strong) NSMutableString *foundValue;

@property (nonatomic, strong) NSString *currentElement;

- (void) parseXml: (NSData *) xmlData;

- (NSMutableDictionary *) getTubeLineStatus;

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
