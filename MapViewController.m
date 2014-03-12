//
//  MapViewController.m
//  RussiaRoutes
//

#import "MapViewController.h"
#import "City.h"

@implementation MapViewController

@synthesize delegate;
@synthesize mapView;
@synthesize routeDetails;
@synthesize routeLine;
@synthesize routeLineView;
@synthesize changeMapTypeButton;

- (void)dealloc {
    [super dealloc];
    
    mapView.delegate = nil;
    [mapView release];
    [routeLine release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [self createRouteOverlay];
    [self setVisibleArea];
    [mapView addOverlay:self.routeLine];
    locationFound = NO;
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self setVisibleArea];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.mapView = nil;
    self.routeLine = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (IBAction)done:(id)sender {
	[self.delegate mapViewControllerDidFinish:self];
}

- (IBAction)locate:(id)sender {
    mapView.showsUserLocation = YES;
    if (locationFound) {
        [mapView setCenterCoordinate:mapView.userLocation.coordinate animated:YES];
    }
}

- (void)setVisibleArea {
    [self.mapView setVisibleMapRect:routeRect];
}

- (void)createRouteOverlay {
    int totalPoints = ([[self routeDetails] count] + 1) / 2;
    MKMapPoint *points = malloc(sizeof(CLLocationCoordinate2D) * totalPoints);
    
    MKMapPoint northEastPoint; 
    MKMapPoint southWestPoint;
    
    for (int index = 0; index < [[self routeDetails] count]; index += 2) {
        City *city = [[self routeDetails] objectAtIndex:index];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = city.latitude.doubleValue;
        coordinate.longitude = city.longitude.doubleValue;
        
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        points[index / 2] = point;
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        annotation.title = [NSString stringWithFormat:@"%@, %d км", city.name, city.distance];
        [mapView addAnnotation:annotation];
        [annotation release];
        
        // calculate bounding rectangle
        if (0 == index) {
            northEastPoint = point;
            southWestPoint = point;
        } else {
            if (point.x > northEastPoint.x) {
                northEastPoint.x = point.x;
            }
            if(point.y > northEastPoint.y) {
                northEastPoint.y = point.y;
            }
            if (point.x < southWestPoint.x) {
                southWestPoint.x = point.x;
            }
            if (point.y < southWestPoint.y) {
                southWestPoint.y = point.y;
            }
        }
    }
    
    self.routeLine = [MKPolyline polylineWithPoints:points count:totalPoints];
    
    routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, 
                              northEastPoint.x - southWestPoint.x, northEastPoint.y - southWestPoint.y);
    
    free(points);
}

- (IBAction)changeMapType {
    if (0 == changeMapTypeButton.selectedSegmentIndex) {
        [mapView setMapType:MKMapTypeStandard];
    } else {
        [mapView setMapType:MKMapTypeHybrid];
    }
}

#pragma mark MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        if (nil == self.routeLineView) {
            self.routeLineView = [[[MKPolylineView alloc] initWithPolyline:self.routeLine] autorelease];
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 3;
        }
        
        return self.routeLineView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!locationFound) {
        [aMapView setCenterCoordinate:aMapView.userLocation.coordinate animated:YES];
        locationFound = YES;
    }
}

- (void)mapView:(MKMapView *)aMapView didFailToLocateUserWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Ошибка"
						  message:@"Не удалось определить координаты."
						  delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
