//
//  RootViewController.m
//  DealsNearby
//
//  Created by Roger on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "RootViewTableCell.h"
#import "DetailViewController.h"
#import "SettingsViewController.h"


@implementation RootViewController
@synthesize currentLocation;
@synthesize searchResults;
@synthesize searchbar;
@synthesize forwardGeocoder;
@synthesize hoverView;
@synthesize selectedIndexPath;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	firstTimeLoad = YES;
	CLLocationManager *locationManager=[[CLLocationManager alloc] init];
	locationManager.delegate=self;
	locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
	
	[locationManager startUpdatingLocation];
	
	// determine the size of HoverView
	CGRect frame = hoverView.frame;
	frame.origin.x = round((self.view.frame.size.width - frame.size.width) / 2.0);
	frame.origin.y = self.view.frame.size.height - 260;
	hoverView.frame = frame;
	
	[self.view addSubview:hoverView];
	
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)showHideHoverView:(BOOL)show{
	if(show){
		self.hoverView.alpha = 1.0;
		[self.hoverView.activityIndicator startAnimating];
	}else{
		self.hoverView.alpha = 0.0;
		[self.hoverView.activityIndicator stopAnimating];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[self.tableView deselectRowAtIndexPath:selectedIndexPath animated:NO];
	[self.navigationController setNavigationBarHidden:true animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	self.currentLocation = newLocation; 
	
	if(firstTimeLoad){
		if ([self isDataSourceAvailable] == NO) {
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Network Required"
								  message:@"DealsNearby requires that you have a connection to the internet."
								  delegate: nil
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		}else{
			currentSearchedLocation = newLocation.coordinate;
			[self showHideHoverView:YES];
			[[SyncRequest requestWithDelegate:self] getDeals:self.currentLocation.coordinate];
			//reverse geocoding
			MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:self.currentLocation.coordinate];
			[geocoder setDelegate:self];
			[geocoder start];
			[manager stopUpdatingLocation];
		}
	}
	firstTimeLoad = NO;
	
	//NSArray *results = [delegate doSearch:[self getBounds:self.currentLocation.coordinate.latitude longitude:self.currentLocation.coordinate.longitude]];
	
}

-(IBAction)refreshButtonClicked:(id)sender{
	[self showHideHoverView:YES];
	[[SyncRequest requestWithDelegate:self] getDeals:currentSearchedLocation];
}

-(IBAction)locateButtonClicked:(id)sender{
	CLLocationManager *locationManager=[[CLLocationManager alloc] init];
	locationManager.delegate=self;
	locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
	
	[locationManager startUpdatingLocation];
	firstTimeLoad = YES;
}

-(IBAction)settingsButtonClicked:(id)sender{
	[self showShowSettingsView];
}


- (void)showShowSettingsView{
	SettingsViewController *controller = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
	[self presentModalViewController:controller animated:YES];
	//[self presentModalViewController:addNoteController animated:YES];
	//[controller release];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
	self.title = placemark.locality;
	searchbar.text = placemark.locality;
}

- (BOOL)isDataSourceAvailable
{
    static BOOL checkNetwork = YES;
    if (checkNetwork) { // Since checking the reachability of a host can be expensive, cache the result and perform the reachability check once.
        checkNetwork = NO;
        
        Boolean success;    
        const char *host_name = "www.dealsnearby.us";
		
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
        SCNetworkReachabilityFlags flags;
        success = SCNetworkReachabilityGetFlags(reachability, &flags);
        _isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
        CFRelease(reachability);
    }
    return _isDataSourceAvailable;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

//Sync Request Delegate Callback
- (void)request:(SyncRequest*)request didLoadSyncRequest:(NSArray *)result{
	
	if(request.method == @"getDeals") {
		self.searchResults = result;
		[self.tableView reloadData];
		[self showHideHoverView:NO];
	}
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.searchResults count] > 0){
		return [self.searchResults count];
	}else{
		return 0;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }*/
	RootViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RootViewTableCell" owner:self options:nil];
        //cell = [[[RootViewTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell = [nib objectAtIndex:0];
	}
	
	NSUInteger row = [indexPath row];
	NSDictionary *deal = [self.searchResults objectAtIndex:row];
	[cell setDetails: deal];
    //cell.textLabel.text = [deal objectForKey:@"announcement_title"];
	//cell.detailTextLabel.text = [deal objectForKey:@"deal_title"];
	// Configure the cell.

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 100;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	
	if ([self isDataSourceAvailable] == NO) {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Network Required"
							  message:@"PeepsNearby requires that you have a connection to the internet."
							  delegate: nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}else{
		[searchBar resignFirstResponder];
		if(!forwardGeocoder){
			forwardGeocoder = [[MJGeocoder alloc] init];
			forwardGeocoder.delegate = self;
		}
		[self showHideHoverView:YES];
		//show network indicator
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		
		[forwardGeocoder findLocationsWithAddress:searchbar.text title:nil];
		
	}
	//if reverse geocoder is not initialized, initilize it 
}

- (void)geocoder:(MJGeocoder *)geocoder didFindLocations:(NSArray *)locations{
	//hide network indicator
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	AddressComponents *foundLocation = [locations objectAtIndex:0];
	
	[[SyncRequest requestWithDelegate:self] getDeals:foundLocation.coordinate];
	currentSearchedLocation = foundLocation.coordinate;
	
	//[self showHideHoverView:NO];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSUInteger row = [indexPath row];
	NSDictionary *deal = [self.searchResults objectAtIndex:row];	
	self.selectedIndexPath = indexPath;
	 DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	detailViewController.title = [deal objectForKey:@"merchant"];
	[detailViewController loadUrl:[deal objectForKey:@"deal_url"]];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	// [detailViewController release];
	 
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

