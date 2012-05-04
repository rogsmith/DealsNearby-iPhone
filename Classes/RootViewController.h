//
//  RootViewController.h
//  DealsNearby
//
//  Created by Roger on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyncRequest.h"
#import <MapKit/MKReverseGeocoder.h>
#import <MapKit/MKPlacemark.h>
#import "MJGeocodingServices.h"
#import "HoverView.h"

@interface RootViewController : UITableViewController <SyncRequestDelegate, MJGeocoderDelegate, UISearchBarDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, MKReverseGeocoderDelegate> {
	BOOL _isDataSourceAvailable;
	CLLocation *currentLocation;
	BOOL firstTimeLoad;
	NSArray *searchResults;
	IBOutlet UISearchBar *searchbar;
	MJGeocoder *forwardGeocoder;
	IBOutlet HoverView *hoverView;
	CLLocationCoordinate2D currentSearchedLocation;
	NSIndexPath *selectedIndexPath;
}
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) NSArray *searchResults;
@property (nonatomic, retain) UISearchBar *searchbar;
@property(nonatomic, retain) MJGeocoder *forwardGeocoder;
@property (nonatomic, retain) HoverView *hoverView;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;

-(IBAction)refreshButtonClicked:(id)sender;
-(IBAction)locateButtonClicked:(id)sender;
-(IBAction)settingsButtonClicked:(id)sender;

@end
