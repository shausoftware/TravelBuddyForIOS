//
//  LocationTableViewCell.m
//  ShauMapMobile
//
//  Created on 13/03/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//

#import "LocationTableViewCell.h"

@implementation LocationTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier: (NSString *) reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    float screenWidth = self.frame.size.width;
    
    if (self) {
    
        actionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(17, 12, 25, 25)];
        
        UITapGestureRecognizer *actionSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(actionSingleTapGestureCaptured)];
        [actionIcon addGestureRecognizer: actionSingleTap];
        [actionIcon setMultipleTouchEnabled:YES];
        [actionIcon setUserInteractionEnabled:YES];
        actionIcon.image = [UIImage imageNamed:@"ic_undefined.png"];
        [self addSubview:actionIcon];
        
        mapIcon = [[UIImageView alloc] initWithFrame:CGRectMake(50, 12, 25, 25)];
        
        UITapGestureRecognizer *mapSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(mapSingleTapGestureCaptured)];
        [mapIcon addGestureRecognizer: mapSingleTap];
        [mapIcon setMultipleTouchEnabled:YES];
        [mapIcon setUserInteractionEnabled:YES];
        mapIcon.image = [UIImage imageNamed:@"ic_undefined.png"];
        [self addSubview: mapIcon];
        
        saveIcon = [[UIImageView alloc] initWithFrame:CGRectMake(83, 12, 25, 25)];
        saveIcon.image = [UIImage imageNamed:@"ic_undefined.png"];
        [self addSubview: saveIcon];
        
        textView = [[UITextView alloc] initWithFrame: CGRectMake(116, 12, screenWidth - 116, 30)];
        textView.backgroundColor = [UIColor blackColor];
        textView.textColor = [UIColor whiteColor];
        textView.editable = false;
        [self addSubview: textView];
    }
    
    return self;
}

- (void) setGeometry: (ShauKmlGeometry *) geometry withIcons: (NSDictionary *) appIcons enableSave: (bool) enableSave actionCompletion: (void(^)(ShauKmlGeometry *)) actionHandler mapCompletion: (void(^)(ShauKmlGeometry *)) mapHandler saveCompletion: (void(^)(ShauKmlGeometry *)) saveHandler {
    
    _actionCompletionHandler = [actionHandler copy];
    _mapCompletionHandler = [mapHandler copy];
    _saveCompletionHandler = [saveHandler copy];
    
    mAppIcons = appIcons;
    mEnableSave = enableSave;
    mGeometry = geometry;
    
    [textView setText: [mGeometry getStopName]];
    
    actionIcon.image = [mAppIcons objectForKey: [geometry getIconName]];
    mapIcon.image = [mAppIcons objectForKey: @"map"];
    
    if (mEnableSave) {
        saveIcon.image = [mAppIcons objectForKey: @"save"];
        UITapGestureRecognizer *saveSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(saveSingleTapGestureCaptured)];
        [saveIcon addGestureRecognizer: saveSingleTap];
        [saveIcon setMultipleTouchEnabled:YES];
        [saveIcon setUserInteractionEnabled:YES];
    } else {
        saveIcon.image = [mAppIcons objectForKey: @"disabled"];
    }
}

- (void) actionSingleTapGestureCaptured {
    
    if ([mGeometry getStopCategory] == kShauMapMobile_TransportCategoryUndefined) {
        //do nothing
    } else if ([mGeometry getStopCategory] == kShauMapMobile_TransportCategoryLocation) {
        //no timetable associated with location
        //open map instead via callback
        _actionCompletionHandler(mGeometry);
        
    } else {
        //open timetable
        //use key as url to open browser
        NSURL *url = [NSURL URLWithString: [mGeometry getLink]];
        [[UIApplication sharedApplication] openURL:url];
    }
}
- (void) mapSingleTapGestureCaptured {
    if ([mGeometry getStopCategory] != kShauMapMobile_TransportCategoryUndefined) {
        //open map via callback
        _mapCompletionHandler(mGeometry);
    }
}
- (void) saveSingleTapGestureCaptured {
    if ([mGeometry getStopCategory] != kShauMapMobile_TransportCategoryUndefined) {
        //save location
        _saveCompletionHandler(mGeometry);
    }
}

@end
