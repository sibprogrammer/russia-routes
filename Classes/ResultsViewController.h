//
//  ResultsViewController.h
//  RussiaRoutes
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@class MapViewController;

@protocol ResultsViewControllerDelegate;

@interface ResultsViewController : UIViewController
	<UITableViewDelegate, UITableViewDataSource, MapViewControllerDelegate>
{
	id <ResultsViewControllerDelegate> delegate;
	NSMutableArray *routeDetails;
	UILabel *startCityLabel;
	UILabel *endCityLabel;
	UILabel *distanceLabel;
    UILabel *timeLabel;
    UINavigationItem *navigationItem;
}

@property (nonatomic, assign) id <ResultsViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *routeDetails;
@property (nonatomic, retain) IBOutlet UILabel *startCityLabel;
@property (nonatomic, retain) IBOutlet UILabel *endCityLabel;
@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UINavigationItem *navigationItem;

- (IBAction)done:(id)sender;
- (IBAction)showMap:(id)sender;
- (NSString *)getFormattedTime:(int)time;

@end

@protocol ResultsViewControllerDelegate
- (void)resultsViewControllerDidFinish:(ResultsViewController *)controller;
- (void)resultsViewControllerShowMap;
@end

