//
//  ShauSearchResultsViewController.h
//  ShauMapMobile
//
//  Created on 12/03/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ShauKmlParser.h"
#import "AppDelegate.h"
#import "ShauKmlGeometry.h"
#import "LocationTableViewCell.h"
#import "MapViewController.h"

#ifndef ShauMapMobile_ShauSearchResultsViewController_h
#define ShauMapMobile_ShauSearchResultsViewController_h

@interface ShauSearchResultsViewController : UITableViewController {
    
    NSString *mSearchParameter;
    ShauKmlParser *kmlParser;
    NSDictionary *appIcons;
    bool enableSave;
}

- (void) setSearchParameter: (NSString *) searchParameter;

@property (nonatomic, retain) NSMutableArray *searchResults;

@end

#endif
