//
//  CitySelectViewController.h
//  RussiaRoutes
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "City.h"

@protocol CitySelectViewControllerDelegate;

@interface CitySelectViewController : UIViewController
	<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate>
{
	UITableView *table;
	UISearchBar *search;
    UIBarButtonItem *locate;
    UINavigationItem *navigationItem;
	id <CitySelectViewControllerDelegate> delegate;
	NSMutableArray *keys;
	NSMutableDictionary *citiesDict;
	NSMutableDictionary *allCitiesDict;
	NSString *defaultCityName;
	BOOL isSearching;
    BOOL isStartCity;
    CLLocationManager *locationManager;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UISearchBar *search;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *locate;
@property (nonatomic, retain) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic, assign) id <CitySelectViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *keys;
@property (nonatomic, retain) NSMutableDictionary *citiesDict;
@property (nonatomic, retain) NSMutableDictionary *allCitiesDict;
@property (nonatomic, assign) NSString *defaultCityName;
@property BOOL isStartCity;
@property (nonatomic, retain) CLLocationManager *locationManager;

- (IBAction)done:(id)sender;
- (IBAction)locate:(id)sender;
- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;
- (void)showDefaultCity;

@end

@protocol CitySelectViewControllerDelegate
- (void)citySelectViewControllerDidFinish:(CitySelectViewController *)controller;
- (void)setCity:(City *)city;
@end


