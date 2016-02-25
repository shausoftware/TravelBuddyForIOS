//
//  LocationTableViewCell.h
//  ShauMapMobile
//
//  Created on 13/03/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ShauKmlGeometry.h"

#ifndef ShauMapMobile_LocationTableViewCell_h
#define ShauMapMobile_LocationTableViewCell_h

@interface LocationTableViewCell : UITableViewCell {
    
    NSDictionary *mAppIcons;
    ShauKmlGeometry *mGeometry;
    
    UIImageView *actionIcon;
    UIImageView *mapIcon;
    UIImageView *saveIcon;
    UITextView *textView;
    
    bool mEnableSave;
    
    void (^_actionCompletionHandler)(ShauKmlGeometry *selectedResult);
    void (^_mapCompletionHandler)(ShauKmlGeometry *selectedResult);
    void (^_saveCompletionHandler)(ShauKmlGeometry *selectedResult);
}

- (void) setGeometry: (ShauKmlGeometry *) geometry withIcons: (NSDictionary *) appIcons enableSave: (bool) enableSave actionCompletion: (void(^)(ShauKmlGeometry *)) actionHandler mapCompletion: (void(^)(ShauKmlGeometry *)) mapHandler saveCompletion: (void(^)(ShauKmlGeometry *)) saveHandler;

@end

#endif
