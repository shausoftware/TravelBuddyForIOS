//
//  ShauSearchViewController.h
//  ShauMapMobile
//
//  Created on 12/03/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ShauSearchResultsViewController.h"
#import "MyLocationTableViewCell.h"

#ifndef ShauMapMobile_ShauSearchViewController_h
#define ShauMapMobile_ShauSearchViewController_h

@interface ShauSearchViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    NSDictionary *mAppIcons;
    UITableView *myLocationsTableView;    
}

@property (nonatomic, retain) NSMutableArray *myLocations;

@end

#endif
