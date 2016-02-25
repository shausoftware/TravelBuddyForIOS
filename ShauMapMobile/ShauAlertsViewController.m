//
//  ShauAlertsViewController.m
//  ShauMapMobile
//
//  Created on 21/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShauAlertsViewController.h"

@implementation ShauAlertsViewController

@synthesize transportRoutes;

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    //[self initialiseAlerts];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    transportRoutes = [app getAlertsState];
}

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView {
    return 1;
}

- (NSInteger) tableView:( UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return [transportRoutes count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection: (NSInteger) section {
    NSString *headerText = @"Last Updated: ";
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    headerText = [headerText stringByAppendingString: [app getLastAlertsUpdate]];
    return headerText;
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    
    static NSString *simpleTableIdentifier = @"AlertTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    RouteAlert *route = [transportRoutes objectAtIndex: indexPath.row];
    
    cell.textLabel.text = [route getRouteName];
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed: [route getImageName]];
    if ([route getAlertOn]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    RouteAlert *route = [transportRoutes objectAtIndex: indexPath.row];
    [route setAlertOn: ![route getAlertOn]];
    
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [app saveAlertsState: transportRoutes];
    
    [self.tableView reloadData];
    
}

@end

