//
//  MyLocationTableViewCell.m
//  ShauMapMobile
//
//  Created on 14/03/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//

#import "MyLocationTableViewCell.h"

@implementation MyLocationTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier: (NSString *) reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    float screenWidth = self.frame.size.width;
    
    if (self) {
        
        actionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(17, 12, 25, 25)];
        actionIcon.image = [UIImage imageNamed:@"ic_undefined.png"];
        [self addSubview:actionIcon];
        
        mapIcon = [[UIImageView alloc] initWithFrame:CGRectMake(50, 12, 25, 25)];
        mapIcon.image = [UIImage imageNamed:@"ic_undefined.png"];
        [self addSubview: mapIcon];
        
        deleteIcon = [[UIImageView alloc] initWithFrame:CGRectMake(83, 12, 25, 25)];
        deleteIcon.image = [UIImage imageNamed:@"ic_undefined.png"];
        [self addSubview: deleteIcon];
        
        textView = [[UITextView alloc] initWithFrame: CGRectMake(116, 12, screenWidth - 116, 30)];
        textView.backgroundColor = [UIColor blackColor];
        textView.textColor = [UIColor whiteColor];
        textView.editable = false;
        [self addSubview: textView];
    }
    
    return self;
}

- (void) setGeometry: (ShauKmlGeometry *) geometry withIcons: (NSDictionary *) appIcons actionCompletion: (void(^)(ShauKmlGeometry *)) actionHandler mapCompletion: (void(^)(ShauKmlGeometry *)) mapHandler deleteCompletion: (void(^)(ShauKmlGeometry *)) deleteHandler {
    
    _actionCompletionHandler = [actionHandler copy];
    _mapCompletionHandler = [mapHandler copy];
    _deleteCompletionHandler = [deleteHandler copy];
    
    mAppIcons = appIcons;
    mGeometry = geometry;
    
    [textView setText: [mGeometry getStopName]];
    
    actionIcon.image = [mAppIcons objectForKey: [geometry getIconName]];
    if ([geometry getStopCategory] != kShauMapMobile_TransportCategoryUndefined) {
        
        UITapGestureRecognizer *actionSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(actionSingleTapGestureCaptured)];
        [actionIcon addGestureRecognizer: actionSingleTap];
        [actionIcon setMultipleTouchEnabled:YES];
        [actionIcon setUserInteractionEnabled:YES];
    }
    
    if ([geometry getStopCategory] == kShauMapMobile_TransportCategoryUndefined) {
        mapIcon.image = [mAppIcons objectForKey: @"disabled"];
    } else {
        
        mapIcon.image = [mAppIcons objectForKey: @"map"];
        
        UITapGestureRecognizer *mapSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(mapSingleTapGestureCaptured)];
        [mapIcon addGestureRecognizer: mapSingleTap];
        [mapIcon setMultipleTouchEnabled:YES];
        [mapIcon setUserInteractionEnabled:YES];
    }
    
    if ([geometry getStopCategory] == kShauMapMobile_TransportCategoryUndefined) {
        deleteIcon.image = [mAppIcons objectForKey: @"disabled"];
    } else {

        deleteIcon.image = [mAppIcons objectForKey: @"delete"];
        
        UITapGestureRecognizer *saveSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(deleteSingleTapGestureCaptured)];
        [deleteIcon addGestureRecognizer: saveSingleTap];
        [deleteIcon setMultipleTouchEnabled:YES];
        [deleteIcon setUserInteractionEnabled:YES];
    }
}

- (void) actionSingleTapGestureCaptured {
    
    if ([mGeometry getStopCategory] == kShauMapMobile_TransportCategoryUndefined) {
        //do nothing
    } else if ([mGeometry getStopCategory] == kShauMapMobile_TransportCategoryLocation) {
        //no timetable associated with location
        //open map instead
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
        //open map
        _mapCompletionHandler(mGeometry);
    }
}
- (void) deleteSingleTapGestureCaptured {
    if ([mGeometry getStopCategory] != kShauMapMobile_TransportCategoryUndefined) {
        //delete favourite
        _deleteCompletionHandler(mGeometry);
    }
}

@end
