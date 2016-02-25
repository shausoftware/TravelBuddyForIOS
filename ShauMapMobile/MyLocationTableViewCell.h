//
//  MyLocationTableViewCell.h
//  ShauMapMobile
//
//  Created on 14/03/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ShauKmlGeometry.h"

#ifndef ShauMapMobile_MyLocationTableViewCell_h
#define ShauMapMobile_MyLocationTableViewCell_h

@interface MyLocationTableViewCell : UITableViewCell {
    
    NSDictionary *mAppIcons;
    ShauKmlGeometry *mGeometry;
    
    UIImageView *actionIcon;
    UIImageView *mapIcon;
    UIImageView *deleteIcon;
    UITextView *textView;
    
    void (^_actionCompletionHandler)(ShauKmlGeometry *selectedResult);
    void (^_mapCompletionHandler)(ShauKmlGeometry *selectedResult);
    void (^_deleteCompletionHandler)(ShauKmlGeometry *selectedResult);
}

- (void) setGeometry: (ShauKmlGeometry *) geometry withIcons: (NSDictionary *) appIcons actionCompletion: (void(^)(ShauKmlGeometry *)) actionHandler mapCompletion: (void(^)(ShauKmlGeometry *)) mapHandler deleteCompletion: (void(^)(ShauKmlGeometry *)) deleteHandler;

@end

#endif
