//
//  ShauSettingsViewController.m
//  ShauMapMobile
//
//  Created on 22/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//

#import "ShauSettingsViewController.h"

@implementation ShauSettingsViewController

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor = [UIColor blackColor];
    
    CGFloat visibleAreaTop = 70;
    CGFloat screenWidth = self.view.frame.size.width;
    
    UILabel *alertPollingOnLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, visibleAreaTop, 200, 44)];
    [alertPollingOnLabel setText: @"Alert Polling"];
    [alertPollingOnLabel setTextColor: [UIColor whiteColor]];
    [alertPollingOnLabel setFont: [UIFont systemFontOfSize:20]];
    
    UILabel *notificationSoundOnLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, visibleAreaTop + 44, 200, 44)];
    [notificationSoundOnLabel setText: @"Notification Sound"];
    [notificationSoundOnLabel setTextColor: [UIColor whiteColor]];
    [notificationSoundOnLabel setFont: [UIFont systemFontOfSize:20]];

    UISwitch *alertPollingOnSwitch = [[UISwitch alloc] initWithFrame: CGRectMake(screenWidth - 60, visibleAreaTop, 60, 44)];
    [alertPollingOnSwitch setOn: [app isAlertPollingOn]];
    [alertPollingOnSwitch addTarget:self action:@selector(alertPollingStateChanged:) forControlEvents:UIControlEventValueChanged];
    
    UISwitch *notificationSoundOnSwitch = [[UISwitch alloc] initWithFrame: CGRectMake(screenWidth - 60, visibleAreaTop + 44, 60, 44)];
    [notificationSoundOnSwitch setOn: [app isNotificationSoundOn]];
    [notificationSoundOnSwitch addTarget:self action:@selector(notificationSoundStateChanged:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview: alertPollingOnLabel];
    [self.view addSubview: alertPollingOnSwitch];
    [self.view addSubview: notificationSoundOnLabel];
    [self.view addSubview: notificationSoundOnSwitch];
}

- (void) alertPollingStateChanged: (id) sender {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app setAlertPollingState: [sender isOn]];
}

- (void) notificationSoundStateChanged: (id) sender {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app setNotificationSoundState: [sender isOn]];
}

- (void) notificationVibrateStateChanged: (id) sender {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app setNotificationVibrateState: [sender isOn]];
}

@end

