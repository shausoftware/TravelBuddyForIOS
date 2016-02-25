//
//  ShauAppInfoViewController.m
//  ShauMapMobile
//
//  Created by on 07/02/2015.
//  Copyright (c) 2015 SHAU. All rights reserved.
//
#import "ShauAppInfoViewController.h"

@implementation ShauAppInfoViewController

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    NSString *sLastKmlUpdate = [app getLastKmlUpdate];
    
    CGRect fullScreenRect = [[UIScreen mainScreen] applicationFrame];
    CGRect scrollScreenRect = CGRectMake(fullScreenRect.origin.x, fullScreenRect.origin.y, fullScreenRect.size.width, fullScreenRect.size.height - 80);
    CGRect contentScreenRect = CGRectMake(fullScreenRect.origin.x, fullScreenRect.origin.y, fullScreenRect.size.width, 1280);
    
    UIScrollView *outerView = [[UIScrollView alloc] initWithFrame: scrollScreenRect];
    outerView.contentSize = contentScreenRect.size;
    [self.view addSubview: outerView];
    
    UITextView *introductionTitle = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    introductionTitle.textColor = [UIColor whiteColor];
    introductionTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    introductionTitle.backgroundColor = [UIColor blackColor];
    introductionTitle.editable = false;
    introductionTitle.scrollEnabled = false;
    introductionTitle.text = @"Introduction";
    [outerView addSubview: introductionTitle];

    NSString *introText = @"The ‘Travel Buddy London’ application is an easy to use tool that allows you to find embarkation points and view live timetables for the following modes of public transport in London:\n\n- Bus Stops (Except ‘Hail & Ride’)\n- Tube Stations\n- National Rail Stations\n- River Boats\n";
    UITextView *introductionText = [[UITextView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 200)];
    introductionText.textColor = [UIColor whiteColor];
    introductionText.font = [UIFont fontWithName:@"Helvetica" size:15];
    introductionText.backgroundColor = [UIColor blackColor];
    introductionText.editable = false;
    introductionText.scrollEnabled = false;
    introductionText.text = introText;
    [outerView addSubview: introductionText];
    
    UITextView *mapTitle = [[UITextView alloc] initWithFrame:CGRectMake(0, 220, self.view.frame.size.width, 30)];
    mapTitle.textColor = [UIColor whiteColor];
    mapTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    mapTitle.backgroundColor = [UIColor blackColor];
    mapTitle.editable = false;
    mapTitle.scrollEnabled = false;
    mapTitle.text = @"Map Page";
    [outerView addSubview: mapTitle];

    NSString *mapHelpText = @"On the main 'Map' page navigate the google map around London to see the embarkation points in the vicinity. Selecting an embarkation point on the map displays the name of the stop or station. Selecting the text displayed in the information window opens a link to the appropriate timetable in your devices web browser. The tube station icons are colour coded to indicate the the line to which they belong.\nTo prevent excessive data loading it should be noted that zooming out too far will prevent load of embarkation points.\nAllow ‘Location Services’ in the Settings page for this application to locate embarkation points in your local vicinity.\n";
    UITextView *mapText = [[UITextView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 250)];
    mapText.textColor = [UIColor whiteColor];
    mapText.font = [UIFont fontWithName:@"Helvetica" size:15];
    mapText.backgroundColor = [UIColor blackColor];
    mapText.editable = false;
    mapText.scrollEnabled = false;
    mapText.text = mapHelpText;
    [outerView addSubview: mapText];
    
    UITextView *searchTitle = [[UITextView alloc] initWithFrame:CGRectMake(0, 490, self.view.frame.size.width, 30)];
    searchTitle.textColor = [UIColor whiteColor];
    searchTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    searchTitle.backgroundColor = [UIColor blackColor];
    searchTitle.editable = false;
    searchTitle.scrollEnabled = false;
    searchTitle.text = @"Search Page";
    [outerView addSubview: searchTitle];

    NSString *searchHelpText = @"Searches can be performed for bus stops, stations, piers, bus routes, tube lines, places and postcodes. A list of 5 of your favourite locations are displayed at the bottom of the page. If defined the location displays 3 icons:\n- Selecting the leftmost icon opens the timetable in the web browser (for postcodes and places the user is redirected to the map page).\n- Selecting the middle icon opens the map page at the selected coordinates.\n- Selecting the rightmost icon removes the location from the list.\nOnce a search is performed another three icons are displayed for each matching search result.\n- Selecting the leftmost icon opens the timetable in the web browser (for postcodes and places the user is redirected to the map page).\n- Selecting the middle icon opens the map page at the selected coordinates.\n- Selecting the rightmost icon adds the location to the 'My Locations' list. The icon will not be displayed if there are no free 'My Location' slots available.\n";
    UITextView *searchText = [[UITextView alloc] initWithFrame:CGRectMake(0, 520, self.view.frame.size.width, 470)];
    searchText.textColor = [UIColor whiteColor];
    searchText.font = [UIFont fontWithName:@"Helvetica" size:15];
    searchText.backgroundColor = [UIColor blackColor];
    searchText.editable = false;
    searchText.scrollEnabled = false;
    searchText.text = searchHelpText;
    [outerView addSubview: searchText];
    
    UITextView *alertsTitle = [[UITextView alloc] initWithFrame:CGRectMake(0, 990, self.view.frame.size.width, 30)];
    alertsTitle.textColor = [UIColor whiteColor];
    alertsTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    alertsTitle.backgroundColor = [UIColor blackColor];
    alertsTitle.editable = false;
    alertsTitle.scrollEnabled = false;
    alertsTitle.text = @"Alerts Page";
    [outerView addSubview: alertsTitle];

    NSString *alertsHelpText = @"On the 'Alerts' page it is possible to set up alerts for tube lines. The alerts generate notifications when there is service disruption. Alerts are switched on for the individual tube lines by selecting the rightmost checkmark.\nNotification sound and polling can be configured from the 'Settings Page'.\n";
    UITextView *alertsText = [[UITextView alloc] initWithFrame:CGRectMake(0, 1020, self.view.frame.size.width, 160)];
    alertsText.textColor = [UIColor whiteColor];
    alertsText.font = [UIFont fontWithName:@"Helvetica" size:15];
    alertsText.backgroundColor = [UIColor blackColor];
    alertsText.editable = false;
    alertsText.scrollEnabled = false;
    alertsText.text = alertsHelpText;
    [outerView addSubview: alertsText];
    
    UITextView *dataTitle = [[UITextView alloc] initWithFrame:CGRectMake(0, 1160, self.view.frame.size.width, 30)];
    dataTitle.textColor = [UIColor whiteColor];
    dataTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    dataTitle.backgroundColor = [UIColor blackColor];
    dataTitle.editable = false;
    dataTitle.scrollEnabled = false;
    dataTitle.text = @"Data";
    [outerView addSubview: dataTitle];

    NSString *dataHelpText = @"This application uses data leveraged from Transport for London via London Datastore and National Rail Enquiries.\n\nLast Data Update: ";
    
    dataHelpText = [dataHelpText stringByAppendingString: sLastKmlUpdate];
    UITextView *dataText = [[UITextView alloc] initWithFrame:CGRectMake(0, 1190, self.view.frame.size.width, 140)];
    dataText.textColor = [UIColor whiteColor];
    dataText.font = [UIFont fontWithName:@"Helvetica" size:15];
    dataText.backgroundColor = [UIColor blackColor];
    dataText.editable = false;
    dataText.scrollEnabled = false;
    dataText.text = dataHelpText;
    [outerView addSubview: dataText];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end