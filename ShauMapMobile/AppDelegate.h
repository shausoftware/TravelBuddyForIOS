//
//  AppDelegate.h
//  ShauMapMobile
//
//  Created on 04/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TubeLineParser.h"
#import "ShauKmlGeometry.h"
#import "ShauLatLng.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSMutableArray *alertsState;
    NSDictionary *iconDictionary;
    bool alertPollingOn;
    bool notificationSoundOn;
    bool notificationVibrateOn;
    TubeLineParser *tubeLineParser;
    NSMutableArray *myLocations;
    
    NSString *currentSearchParameter;
    NSString *lastKmlUpdate;
    
    CLLocationCoordinate2D mCurrentPosition;
    bool foundMe;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (NSMutableArray *) getAlertsState;
- (void) saveAlertsState: (NSMutableArray *) state;
- (bool) isAlertPollingOn;
- (void) setAlertPollingState: (bool) on;
- (bool) isNotificationSoundOn;
- (void) setNotificationSoundState: (bool) on;
- (bool) isNotificationVibrateOn;
- (void) setNotificationVibrateState: (bool) on;
- (NSDictionary *) getAppIcons;
- (void) loadMyLocations;
- (void) addLocation: (ShauKmlGeometry *) location;
- (void) deleteLocation: (ShauKmlGeometry *) location;
- (bool) isLocationSlotAvailable;
- (NSMutableArray *) getMyLocations;

- (void) setCurrentSearchParameter: (NSString *) searchParameter;
- (NSString *) getCurrentSearchParameter;
- (void) setLastKmlUpdate: (NSString *) lastUpdate;
- (NSString *) getLastKmlUpdate;
- (void) setLastAlertsUpdate: (NSString *) lastUpdate;
- (NSString *) getLastAlertsUpdate;

- (void) setCurrentPosition: (CLLocationCoordinate2D) currentPosition;
- (CLLocationCoordinate2D) getCurrentPosition;

- (void) openMapPage;
- (void) pushView: (UIViewController *) view;
- (void) popView;

- (void) foundMe: (bool) found;
- (bool) isFoundMe;

+ (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *data))completionHandler;

@end