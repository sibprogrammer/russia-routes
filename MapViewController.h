//
//  MapViewController.h
//  RussiaRoutes
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol MapViewControllerDelegate;

@interface MapViewController : UIViewController <MKMapViewDelegate> {
    id <MapViewControllerDelegate> delegate;
    MKMapView *mapView;
    NSMutableArray *routeDetails;
    MKPolyline *routeLine;
    MKPolylineView *routeLineView;
    MKMapRect routeRect;
    BOOL locationFound;
    UISegmentedControl *changeMapTypeButton;
}

@property (nonatomic, assign) id <MapViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, assign) NSMutableArray *routeDetails;
@property (nonatomic, retain) MKPolyline *routeLine;
@property (nonatomic, retain) MKPolylineView *routeLineView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *changeMapTypeButton;

- (IBAction)done:(id)sender;
- (IBAction)locate:(id)sender;
- (void)setVisibleArea;
- (void)createRouteOverlay;
- (IBAction)changeMapType;

@end

@protocol MapViewControllerDelegate
- (void)mapViewControllerDidFinish:(MapViewController *)controller;
@end
