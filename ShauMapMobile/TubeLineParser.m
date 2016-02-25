//
//  TubeLineParser.m
//  ShauMapMobile
//
//  Created on 22/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TubeLineParser.h"

@implementation TubeLineParser

NSString const* ELEM_LINE_STATUS = @"LineStatus";
NSString const* ELEM_BRANCH_DISRUPTIONS = @"BranchDisruptions";
NSString const* ELEM_LINE = @"Line";
NSString const* ELEM_STATUS = @"Status";
NSString const* ATTR_NAME = @"Name";
NSString const* ATTR_ID = @"ID";
NSString const* ATTR_STATUS_DETAILS = @"StatusDetails";
NSString const* ATTR_STATUS_DESCRIPTION = @"Description";

- (void) parseXml: (NSData *) xmlData {
    
    inLineStatus = false;
    inDisruption = false;
    
    self.xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    self.xmlParser.delegate = self;
    
    // Initialize the mutable string that we'll use during parsing.
    self.foundValue = [[NSMutableString alloc] init];
    
    // Start parsing.
    [self.xmlParser parse];
}

- (NSMutableDictionary *) getTubeLineStatus {
    return self.lineStatusMap;
}

- (void) parserDidStartDocument: (NSXMLParser *) parser {
    self.lineStatusMap = [[NSMutableDictionary alloc] init];
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
    
    if ([ELEM_LINE_STATUS isEqualToString: elementName]) {
        
        currentTubeLineStatus = [TubeLineStatus alloc];
        [currentTubeLineStatus setLineStatusDetails: [attributeDict objectForKey: ATTR_STATUS_DETAILS]];
        
        inLineStatus = true;
    
    } else if ([ELEM_BRANCH_DISRUPTIONS isEqualToString: elementName]) {
        
        inDisruption = true;
        
    } else if ([ELEM_LINE isEqualToString: elementName]) {
        
        if (inLineStatus && !inDisruption) {

            NSString *lineName = [attributeDict objectForKey: ATTR_NAME];
            [currentTubeLineStatus setLineName: lineName];
        }
        
    } else if ([ELEM_STATUS isEqualToString: elementName]) {
        
        if (inLineStatus && !inDisruption) {

            NSString *description = [attributeDict objectForKey: ATTR_STATUS_DESCRIPTION];
            [currentTubeLineStatus setLineStatusDescription: description];
            if ([@"Good Service" isEqualToString: description] ||
                [description containsString: @"Train service resumes"]) {
                [currentTubeLineStatus setLineOk: true];
            } else {
                [currentTubeLineStatus setLineOk: false];
            }
            //done
            [self.lineStatusMap setObject: currentTubeLineStatus forKey: [currentTubeLineStatus getLineName]];
        }
    }
}

- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName
   namespaceURI: (NSString *) namespaceURI
  qualifiedName: (NSString *) qName {
    
    if ([ELEM_LINE_STATUS isEqualToString: elementName]) {
        inLineStatus = false;
    } else if ([ELEM_BRANCH_DISRUPTIONS isEqualToString: elementName]) {
        inDisruption = false;
    }
}

- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) string {

}

@end
