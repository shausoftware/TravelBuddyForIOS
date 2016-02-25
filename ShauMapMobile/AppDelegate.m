//
//  AppDelegate.m
//  ShauMapMobile
//
//  Created on 04/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MapViewController.h"

@implementation AppDelegate

int const IDX_BUS = 0;
int const IDX_TRAIN = 1;
int const IDX_BAKERLOO = 2;
int const IDX_CENTRAL = 3;
int const IDX_CIRCLE = 4;
int const IDX_DISTRICT = 5;
int const IDX_DLR = 6;
int const IDX_HAMMERSMITH_CITY = 7;
int const IDX_JUBILEE = 8;
int const IDX_METROPOLITAN = 9;
int const IDX_NORTHERN = 10;
int const IDX_PICCADILLY = 11;
int const IDX_VICTORIA = 12;
int const IDX_WATERLOO_CITY = 13;

NSString *ALERT_POLLING_STATE = @"ALERT_POLLING_STATE";
NSString *NOTIFICATION_SOUND_STATE = @"NOTIFICATION_SOUND_STATE";
NSString *NOTIFICATION_VIBRATE_STATE = @"NOTIFICATION_VIBRATE_STATE";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    foundMe = false;
    alertPollingOn = false;
    notificationSoundOn = false;
    notificationVibrateOn = false;
    lastKmlUpdate = @"Unavailable";
    
    //default locatiom
    mCurrentPosition = CLLocationCoordinate2DMake(51.5072, 0.1275);
    
    tubeLineParser = [TubeLineParser alloc];
    
    [self initAppIcons];
    //initialise alerts state array
    [self initialiseAlerts];
    //load any persisted state
    [self loadApplicationSettings];
    
    //Google Map API Key
    [GMSServices provideAPIKey:@"Your Google Maps iOS API Key"];

    [self openMapPage];
    
    if ([self isAlertPollingOn]) {
        [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    } else {
        [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalNever];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(defaultsChanged)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    
    return YES;
}

- (void) openMapPage {
    
    UIViewController *mapViewController = [[MapViewController alloc] init];
    mapViewController.title = @"Map";
    self.navigationController = [[UINavigationController alloc] initWithRootViewController: mapViewController];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
}

- (void) pushView: (UIViewController *) view {
    [self.navigationController pushViewController: view animated: YES];
}
- (void) popView {
    [self.navigationController popViewControllerAnimated: YES];
}

- (void) foundMe: (bool) found {
    foundMe = found;
}
- (bool) isFoundMe {
    return foundMe;
}

- (UIInterfaceOrientationMask) application: (UIApplication *) application supportedInterfaceOrientationsForWindow: (UIWindow *) window {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "SHAU.ShauMapMobile" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ShauMapMobile" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ShauMapMobile.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Class method implementation

+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler{
    // Instantiate a session configuration object.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Instantiate a session object.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // Create a data task object to perform the data downloading.
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            // If any error occurs then just display its description on the console.
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            // If no error occurs, check the HTTP status code.
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            // If it's other than 200, then show it on the console.
            if (HTTPStatusCode != 200) {
                NSLog(@"HTTP status code = %ld", (long) HTTPStatusCode);
            }
            
            // Call the completion handler with the returned data on the main thread.
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
    }];
    
    // Resume the task.
    [task resume];
}

- (void)application: (UIApplication *) application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

//    NSLog(@"* BACKGROUND *");
    
    //get tube line status from London datastore
    NSString *tubeLineStatusUrl = @"http://cloud.tfl.gov.uk/TrackerNet/LineStatus";
    NSURL *url = [NSURL URLWithString: tubeLineStatusUrl];
    
    //download data
    [AppDelegate downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        
        // Check if any data returned.
        if (data == nil) {
            
            completionHandler(UIBackgroundFetchResultNoData);
            
        } else {
            
            //parse xml
            [tubeLineParser parseXml: data];
            NSMutableDictionary *tubeLineStatusMap = [tubeLineParser getTubeLineStatus];
            
            NSLog(@"tubeLineStatusMap:%lu", (unsigned long)[tubeLineStatusMap count]);

            RouteAlert *routeAlert = [alertsState objectAtIndex: IDX_BAKERLOO];
            if ([routeAlert getAlertOn]) {
                NSString *routeTitle = @"Bakerloo";
                TubeLineStatus *tubeLineStatus = [tubeLineStatusMap objectForKey: routeTitle];
                if (![tubeLineStatus getLineOk]) {
                    [self fireNotificationWithTitle: routeTitle body: [tubeLineStatus getLineStatusDetails] icon: [routeAlert getImageName] id: 1];
                }
            }
            
            routeAlert = [alertsState objectAtIndex: IDX_CENTRAL];
            if ([routeAlert getAlertOn]) {
                NSString *routeTitle = @"Central";
                TubeLineStatus *tubeLineStatus = [tubeLineStatusMap objectForKey: routeTitle];
                if (![tubeLineStatus getLineOk]) {
                    [self fireNotificationWithTitle: routeTitle body: [tubeLineStatus getLineStatusDetails] icon: [routeAlert getImageName] id: 2];
                }
            }
            
            routeAlert = [alertsState objectAtIndex: IDX_CIRCLE];
            if ([routeAlert getAlertOn]) {
                NSString *routeTitle = @"Circle";
                TubeLineStatus *tubeLineStatus = [tubeLineStatusMap objectForKey: routeTitle];
                if (![tubeLineStatus getLineOk]) {
                    [self fireNotificationWithTitle: routeTitle body: [tubeLineStatus getLineStatusDetails] icon: [routeAlert getImageName] id: 2];
                }
            }

            routeAlert = [alertsState objectAtIndex: IDX_DISTRICT];
            if ([routeAlert getAlertOn]) {
                NSString *routeTitle = @"District";
                TubeLineStatus *tubeLineStatus = [tubeLineStatusMap objectForKey: routeTitle];
                if (![tubeLineStatus getLineOk]) {
                    [self fireNotificationWithTitle: routeTitle body: [tubeLineStatus getLineStatusDetails] icon: [routeAlert getImageName] id: 2];
                }
            }

            routeAlert = [alertsState objectAtIndex: IDX_DLR];
            if ([routeAlert getAlertOn]) {
                NSString *routeTitle = @"DLR";
                TubeLineStatus *tubeLineStatus = [tubeLineStatusMap objectForKey: routeTitle];
                if (![tubeLineStatus getLineOk]) {
                    [self fireNotificationWithTitle: routeTitle body: [tubeLineStatus getLineStatusDetails] icon: [routeAlert getImageName] id: 2];
                }
            }
            
            routeAlert = [alertsState objectAtIndex: IDX_HAMMERSMITH_CITY];
            if ([routeAlert getAlertOn]) {
                NSString *routeTitle = @"Hammersmith and City";
                TubeLineStatus *tubeLineStatus = [tubeLineStatusMap objectForKey: routeTitle];
                if (![tubeLineStatus getLineOk]) {
                    [self fireNotificationWithTitle: routeTitle body: [tubeLineStatus getLineStatusDetails] icon: [routeAlert getImageName] id: 2];
                }
            }
            
            routeAlert = [alertsState objectAtIndex: IDX_JUBILEE];
            if ([routeAlert getAlertOn]) {
                NSString *routeTitle = @"Jubilee";
                TubeLineStatus *tubeLineStatus = [tubeLineStatusMap objectForKey: routeTitle];
                if (![tubeLineStatus getLineOk]) {
                    [self fireNotificationWithTitle: routeTitle body: [tubeLineStatus getLineStatusDetails] icon: [routeAlert getImageName] id: 2];
                }
            }

            routeAlert = [alertsState objectAtIndex: IDX_METROPOLITAN];
            if ([routeAlert getAlertOn]) {
                NSString *routeTitle = @"Metropolitan";
                TubeLineStatus *tubeLineStatus = [tubeLineStatusMap objectForKey: routeTitle];
                if (![tubeLineStatus getLineOk]) {
                    [self fireNotificationWithTitle: routeTitle body: [tubeLineStatus getLineStatusDetails] icon: [routeAlert getImageName] id: 2];
                }
            }

            routeAlert = [alertsState objectAtIndex: IDX_NORTHERN];
            if ([routeAlert getAlertOn]) {
                NSString *routeTitle = @"Northern";
                TubeLineStatus *tubeLineStatus = [tubeLineStatusMap objectForKey: routeTitle];
                if (![tubeLineStatus getLineOk]) {
                    [self fireNotificationWithTitle: routeTitle body: [tubeLineStatus getLineStatusDetails] icon: [routeAlert getImageName] id: 2];
                }
            }

            routeAlert = [alertsState objectAtIndex: IDX_PICCADILLY];
            if ([routeAlert getAlertOn]) {
                NSString *routeTitle = @"Piccadilly";
                TubeLineStatus *tubeLineStatus = [tubeLineStatusMap objectForKey: routeTitle];
                if (![tubeLineStatus getLineOk]) {
                    [self fireNotificationWithTitle: routeTitle body: [tubeLineStatus getLineStatusDetails] icon: [routeAlert getImageName] id: 2];
                }
            }

            routeAlert = [alertsState objectAtIndex: IDX_VICTORIA];
            if ([routeAlert getAlertOn]) {
                NSString *routeTitle = @"Victoria";
                TubeLineStatus *tubeLineStatus = [tubeLineStatusMap objectForKey: routeTitle];
                if (![tubeLineStatus getLineOk]) {
                    [self fireNotificationWithTitle: routeTitle body: [tubeLineStatus getLineStatusDetails] icon: [routeAlert getImageName] id: 2];
                }
            }

            routeAlert = [alertsState objectAtIndex: IDX_WATERLOO_CITY];
            if ([routeAlert getAlertOn]) {
                NSString *routeTitle = @"Waterloo and City";
                TubeLineStatus *tubeLineStatus = [tubeLineStatusMap objectForKey: routeTitle];
                if (![tubeLineStatus getLineOk]) {
                    [self fireNotificationWithTitle: routeTitle body: [tubeLineStatus getLineStatusDetails] icon: [routeAlert getImageName] id: 2];
                }
            }
            
            //update last update
            NSDateFormatter *formatter;
            NSString        *dateString;
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
            dateString = [formatter stringFromDate:[NSDate date]];
            
            [self setLastAlertsUpdate: dateString];
            
            completionHandler(UIBackgroundFetchResultNewData);
        }
    }];

    completionHandler(UIBackgroundFetchResultFailed);
}

- (void) fireNotificationWithTitle: (NSString *) title body: (NSString *) body icon: (NSString *) icon id: (int) id {
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.alertAction = title;
    localNotif.alertBody = body;
    localNotif.alertLaunchImage = icon;
    localNotif.fireDate = [NSDate date];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    if (notificationSoundOn) {
        localNotif.soundName = UILocalNotificationDefaultSoundName;
    }
//    localNotif.applicationIconBadgeNumber = id;
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObject: @"Tube Alert" forKey: @"Tube Alert"];
//    localNotif.userInfo = userInfo;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

- (void) defaultsChanged {
}

- (void) loadApplicationSettings {
    
    alertPollingOn = [[NSUserDefaults standardUserDefaults] boolForKey: ALERT_POLLING_STATE];
    notificationSoundOn = [[NSUserDefaults standardUserDefaults] boolForKey: NOTIFICATION_SOUND_STATE];
    notificationVibrateOn = [[NSUserDefaults standardUserDefaults] boolForKey: NOTIFICATION_VIBRATE_STATE];
    
    for (RouteAlert *routeAlert in alertsState) {
        bool alertOn = [[NSUserDefaults standardUserDefaults] boolForKey: [routeAlert getRouteName]];
        [routeAlert setAlertOn: alertOn];
    }
}

- (void) setCurrentPosition: (CLLocationCoordinate2D) currentPosition {
    mCurrentPosition = currentPosition;
}
- (CLLocationCoordinate2D) getCurrentPosition {
    return mCurrentPosition;
}

- (void) initAppIcons {
    
    UIImage *undefinedImage = [UIImage imageNamed:@"ic_undefined"];
    UIImage *busImage = [UIImage imageNamed:@"ic_bus"];
    UIImage *hailandrideImage = [UIImage imageNamed:@"ic_hailandride"];
    UIImage *trainImage = [UIImage imageNamed:@"ic_britishrail"];
    UIImage *riverImage = [UIImage imageNamed:@"ic_riverboat"];
    UIImage *bakerlooImage = [UIImage imageNamed:@"ic_bakerloo"];
    UIImage *centralImage = [UIImage imageNamed:@"ic_central"];
    UIImage *circleImage = [UIImage imageNamed:@"ic_circle"];
    UIImage *districtImage = [UIImage imageNamed:@"ic_district"];
    UIImage *dlrImage = [UIImage imageNamed:@"ic_dlr"];
    UIImage *hammersmithcityImage = [UIImage imageNamed:@"ic_hammersmithcity"];
    UIImage *jubileeImage = [UIImage imageNamed:@"ic_jubilee"];
    UIImage *metropolitanImage = [UIImage imageNamed:@"ic_metropolitan"];
    UIImage *northernImage = [UIImage imageNamed:@"ic_northern"];
    UIImage *piccadillyImage = [UIImage imageNamed:@"ic_piccadilly"];
    UIImage *victoriaImage = [UIImage imageNamed:@"ic_victoria"];
    UIImage *waterloocityImage = [UIImage imageNamed:@"ic_dlr"];
    UIImage *locationImage = [UIImage imageNamed:@"ic_location"];
    UIImage *saveImage = [UIImage imageNamed:@"ic_save"];
    UIImage *deleteImage = [UIImage imageNamed:@"ic_delete"];
    UIImage *mapImage = [UIImage imageNamed:@"ic_map"];
    UIImage *disabledImage = [UIImage imageNamed:@"ic_disabled"];
    
    iconDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                      undefinedImage, @"undefined",
                      busImage, @"busstop",
                      hailandrideImage, @"hailandride",
                      trainImage, @"trainstation",
                      riverImage, @"river",
                      bakerlooImage, @"bakerloo",
                      centralImage, @"central",
                      circleImage, @"circle",
                      districtImage, @"district",
                      dlrImage, @"dlr",
                      hammersmithcityImage, @"hammersmithcity",
                      jubileeImage, @"jubilee",
                      metropolitanImage, @"metropolitan",
                      northernImage, @"northern",
                      piccadillyImage, @"piccadilly",
                      victoriaImage, @"victoria",
                      waterloocityImage, @"waterloocity",
                      locationImage, @"location",
                      saveImage, @"save",
                      deleteImage, @"delete",
                      mapImage, @"map",
                      disabledImage, @"disabled", nil];
}

- (NSDictionary *) getAppIcons {
    return iconDictionary;
}

- (void) clearLocations {
    [[NSUserDefaults standardUserDefaults] setObject: nil forKey: @"SHAU_LOCATION_0"];
    [[NSUserDefaults standardUserDefaults] setObject: nil forKey: @"SHAU_LOCATION_1"];
    [[NSUserDefaults standardUserDefaults] setObject: nil forKey: @"SHAU_LOCATION_2"];
    [[NSUserDefaults standardUserDefaults] setObject: nil forKey: @"SHAU_LOCATION_3"];
    [[NSUserDefaults standardUserDefaults] setObject: nil forKey: @"SHAU_LOCATION_4"];
}

- (void) loadMyLocations {
    
    myLocations = [[NSMutableArray alloc] init];
    for (int slot = 0; slot < 5; slot++) {
        NSString *slotName = [NSString stringWithFormat: @"SHAU_LOCATION_%d", slot];
        ShauKmlGeometry *location = [ShauKmlGeometry alloc];
        [location initialiseState];
        [location setSettingsSlot: slotName];
        NSString *sSetting = [[NSUserDefaults standardUserDefaults] objectForKey: slotName];
        if ([sSetting length] > 0) {
            [location setStateFromString: sSetting];
        }
        [myLocations addObject: location];
    }
}
- (void) addLocation: (ShauKmlGeometry *) location {
    
    for (int i = 0; i < [myLocations count]; i++) {
        ShauKmlGeometry *slotLocation = [myLocations objectAtIndex: i];
        if ([slotLocation getStopCategory] == kShauMapMobile_TransportCategoryUndefined) {
            //free slot
            NSString *slotName = [NSString stringWithFormat: @"SHAU_LOCATION_%d", i];
            [[NSUserDefaults standardUserDefaults] setObject: [location getStateAsString] forKey: slotName];
            break;
        }
    }
}
- (void) deleteLocation: (ShauKmlGeometry *) location {
    
    for (int i = 0; i < [myLocations count]; i++) {
        ShauKmlGeometry *arrayLocation = [myLocations objectAtIndex: i];
        if ([[arrayLocation getStateAsString] isEqualToString: [location getStateAsString]]) {
            NSString *slotName = [NSString stringWithFormat: @"SHAU_LOCATION_%d", i];
            [[NSUserDefaults standardUserDefaults] setObject: nil forKey: slotName];
            break;
        }
    }
}
- (bool) isLocationSlotAvailable {
    
    bool isSlotAvailable = false;
    
    for (int i = 0; i < [myLocations count]; i++) {
        ShauKmlGeometry *location = [myLocations objectAtIndex: i];
        if ([location getStopCategory] == kShauMapMobile_TransportCategoryUndefined) {
            //free slot
            isSlotAvailable = true;
            break;
        }
    }
    
    return isSlotAvailable;
}

- (NSMutableArray *) getMyLocations {
    [self loadMyLocations];
    return myLocations;
}

- (void) setCurrentSearchParameter: (NSString *) searchParameter {
    currentSearchParameter = searchParameter;
}
- (NSString *) getCurrentSearchParameter {
    return  currentSearchParameter;
}
- (void) setLastKmlUpdate: (NSString *) lastUpdate {
    lastKmlUpdate = lastUpdate;
}
- (NSString *) getLastKmlUpdate {
    return lastKmlUpdate;
}
- (void) setLastAlertsUpdate: (NSString *) lastUpdate {
    [[NSUserDefaults standardUserDefaults] setObject: lastUpdate forKey: @"SHAU_LAST_ALERT_UPDATE"];
}
- (NSString *) getLastAlertsUpdate {
    NSString *lastAlertsUpdate = [[NSUserDefaults standardUserDefaults] objectForKey: @"SHAU_LAST_ALERT_UPDATE"];
    if (lastAlertsUpdate == nil || [lastAlertsUpdate length] < 1) {
        lastAlertsUpdate = @"Undefined";
    }
    return lastAlertsUpdate;
}

- (bool) isAlertPollingOn {
    return alertPollingOn;
}
- (void) setAlertPollingState: (bool) on {
    
    NSLog(@"setAlertPollingState ENTRY");
    
    [[NSUserDefaults standardUserDefaults] setBool: on forKey: ALERT_POLLING_STATE];
    alertPollingOn = on;
    
    if (on) {

        NSLog(@"setAlertPollingState ON");

        //need to let user allow local notifications
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound
                                                                                                                  categories:nil]];
        }
        //switch on background fetch
        [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
        
    } else {
        NSLog(@"setAlertPollingState OFF");

        //switch off background fetch
        [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalNever];
    }
    
}

- (bool) isNotificationSoundOn {
    return notificationSoundOn;
}
- (void) setNotificationSoundState: (bool) on {
    [[NSUserDefaults standardUserDefaults] setBool: on forKey: NOTIFICATION_SOUND_STATE];
    notificationSoundOn = on;
}

- (bool) isNotificationVibrateOn {
    return notificationVibrateOn;
}
- (void) setNotificationVibrateState: (bool) on {
    [[NSUserDefaults standardUserDefaults] setBool: on forKey: NOTIFICATION_VIBRATE_STATE];
    notificationVibrateOn = on;
}

- (NSMutableArray *) getAlertsState {
    return alertsState;
}
- (void) saveAlertsState: (NSMutableArray *) state {
    
    alertsState = state;
    for (RouteAlert *routeAlert in alertsState) {
        [[NSUserDefaults standardUserDefaults] setBool: [routeAlert getAlertOn] forKey: [routeAlert getRouteName]];
    }
}

- (void) initialiseAlerts {
    
    RouteAlert *busRouteAlert = [[RouteAlert alloc] initWithRouteName: @"Bus Stops (Except Hail & Ride)" image: @"ic_bus" hasAlert: false on: false];
    RouteAlert *hailAndRideRouteAlert = [[RouteAlert alloc] initWithRouteName: @"Hail & Ride" image: @"ic_hailandride" hasAlert: false on: false];
    RouteAlert *nationalRailAlert = [[RouteAlert alloc] initWithRouteName: @"National Rail Stations" image: @"ic_britishrail" hasAlert: false on: false];
    RouteAlert *bakerlooLineAlert = [[RouteAlert alloc] initWithRouteName: @"Bakerloo Line" image: @"ic_bakerloo" hasAlert: true on: false];
    RouteAlert *centralLineAlert = [[RouteAlert alloc] initWithRouteName: @"Central Line" image: @"ic_central" hasAlert: true on: false];
    RouteAlert *circleLineAlert = [[RouteAlert alloc] initWithRouteName: @"Circle Line" image: @"ic_circle" hasAlert: true on: false];
    RouteAlert *districtLineAlert = [[RouteAlert alloc] initWithRouteName: @"District Line" image: @"ic_district" hasAlert: true on: false];
    RouteAlert *dlrAlert = [[RouteAlert alloc] initWithRouteName: @"DLR" image: @"ic_dlr" hasAlert: true on: false];
    RouteAlert *hammersmithCityLineAlert = [[RouteAlert alloc] initWithRouteName: @"Hammersmith & City Line" image: @"ic_hammersmithcity" hasAlert: true on: false];
    RouteAlert *jubileeLineAlert = [[RouteAlert alloc] initWithRouteName: @"Jubilee Line" image: @"ic_jubilee" hasAlert: true on: false];
    RouteAlert *metropolitanLineAlert = [[RouteAlert alloc] initWithRouteName: @"Metropolitan Line" image: @"ic_metropolitan" hasAlert: true on: false];
    RouteAlert *northernLineAlert = [[RouteAlert alloc] initWithRouteName: @"Northern Line" image: @"ic_northern" hasAlert: true on: false];
    RouteAlert *piccadillyLineAlert = [[RouteAlert alloc] initWithRouteName: @"Piccadilly Line" image: @"ic_piccadilly" hasAlert: true on: false];
    RouteAlert *victoriaLineAlert = [[RouteAlert alloc] initWithRouteName: @"Victoria Line" image: @"ic_victoria" hasAlert: true on: false];
    RouteAlert *waterlooCityLineAlert = [[RouteAlert alloc] initWithRouteName: @"Waterloo & City Line" image: @"ic_dlr" hasAlert: true on: false];
    RouteAlert *riverBoatAlert = [[RouteAlert alloc] initWithRouteName: @"River" image: @"ic_riverboat" hasAlert: false on: false];
    
    alertsState = [[NSMutableArray alloc] initWithObjects:busRouteAlert,
                       hailAndRideRouteAlert,
                       nationalRailAlert,
                       bakerlooLineAlert,
                       centralLineAlert,
                       circleLineAlert,
                       districtLineAlert,
                       dlrAlert,
                       hammersmithCityLineAlert,
                       jubileeLineAlert,
                       metropolitanLineAlert,
                       northernLineAlert,
                       piccadillyLineAlert,
                       victoriaLineAlert,
                       waterlooCityLineAlert,
                       riverBoatAlert, nil];
}

@end
