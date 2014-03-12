//
//  ResultsViewController.m
//  RussiaRoutes
//

#import "ResultsViewController.h"
#import "City.h"
#import "Segment.h"
#import "RussiaRoutesAppDelegate.h"
#import "ResultCell.h"
#import "MapViewController.h"

@implementation ResultsViewController

@synthesize delegate;
@synthesize routeDetails;
@synthesize startCityLabel;
@synthesize endCityLabel;
@synthesize distanceLabel;
@synthesize timeLabel;
@synthesize navigationItem;

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidLoad {
	City *city = [routeDetails objectAtIndex:0];
	startCityLabel.text = city.name;
	city = [routeDetails objectAtIndex:[routeDetails count]-1];
	endCityLabel.text = city.name;
	distanceLabel.text = [NSString stringWithFormat:@"%d км", city.distance];
    timeLabel.text = [self getFormattedTime:city.time];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationItem.leftBarButtonItem = nil;
    }
	
	[super viewDidLoad];
}

- (void)viewDidUnload {
	self.startCityLabel = nil;
	self.endCityLabel = nil;
	self.distanceLabel = nil;
    self.timeLabel = nil;
    self.navigationItem = nil;
	
	[super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)dealloc {
	[startCityLabel release];
	[endCityLabel release];
	[distanceLabel release];
    [timeLabel release];
    [navigationItem release];
	
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else if (toInterfaceOrientation == UIDeviceOrientationPortrait || toInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSInteger)supportedInterfaceOrientations {
    NSInteger mask = 0;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationLandscapeRight])
        mask |= UIInterfaceOrientationMaskLandscapeRight;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationLandscapeLeft])
        mask |= UIInterfaceOrientationMaskLandscapeLeft;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationPortrait])
        mask |= UIInterfaceOrientationMaskPortrait;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationPortraitUpsideDown])
        mask |= UIInterfaceOrientationMaskPortraitUpsideDown;
    return mask;
}

#pragma mark -

- (IBAction)done:(id)sender {
	[self.delegate resultsViewControllerDidFinish:self];
}

- (IBAction)showMap:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.delegate resultsViewControllerShowMap];
        return;
    }
    
    MapViewController *mapController = [[MapViewController alloc]
                                        initWithNibName:@"MapViewController"
                                        bundle:nil];
	mapController.delegate = self;
    mapController.routeDetails = self.routeDetails;
	mapController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:mapController animated:YES];
	[mapController release];

}

#pragma mark -
#pragma mark Table View methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([routeDetails count] + 1) / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *resultCellId = @"ResultCellId";
	
	ResultCell *cell = (ResultCell *)[tableView dequeueReusableCellWithIdentifier:resultCellId];
	
	if (nil == cell) {
        NSString *resultCellNib;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            resultCellNib = @"iPadResultCell";
        } else {
            resultCellNib = @"ResultCell";
        }
        
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:resultCellNib owner:self options:nil];
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:[ResultCell class]]) {
				cell = (ResultCell *)oneObject;
			}
		}
	}
	
	NSUInteger row = [indexPath row];
	int index = (row + 1) * 2 - 1;
	City *city = (City *)[routeDetails objectAtIndex:index-1];

	cell.cityName.text = city.name;
	cell.distance.text = [NSString stringWithFormat:@"%d км", city.distance];
    cell.time.text = [self getFormattedTime:city.time];
	
	NSString *cityPosition = @"";
	
	if (0 == row) {
		cityPosition = @"_top";
	} else if (index == [routeDetails count]) {
		cityPosition = @"_bottom";
	}
	
	UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"city_size_%d%@.png", city.population, cityPosition]];
	cell.image.image = image;

	if (0 == row) {
		cell.diffDistance.text = @"";
		cell.routeName.text = @"";
        cell.diffTime.text = @"";
		CGRect frame = cell.cityName.frame;
		frame.origin.y = 11;
		cell.cityName.frame = frame;
	} else {
		Segment *segment = (Segment *)[routeDetails objectAtIndex:index-2];
		cell.diffDistance.text = [NSString stringWithFormat:@"+%d км", segment.distance];
		cell.routeName.text = segment.name;
        cell.diffTime.text = [NSString stringWithFormat:@"+%@", [self getFormattedTime:segment.time]];
        
		CGRect frame = cell.cityName.frame;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            frame.origin.y = 11;
        } else {
            frame.origin.y = 19;
        }
		cell.cityName.frame = frame;
        
	}
	
	return cell;
}

#pragma mark -

- (void)mapViewControllerDidFinish:(MapViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

- (NSString *)getFormattedTime:(int)time {
    int hours = floor(time / 60);
    int minutes = time % 60;
    
    NSString *result = [NSString stringWithFormat:@"%02d:%02d", hours, minutes]; 
    
    return result;
}

@end
