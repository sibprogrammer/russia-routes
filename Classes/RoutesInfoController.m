//
//  RoutesInfoController.m
//  RussiaRoutes
//

#import "RoutesInfoController.h"
#import "RussiaRoutesAppDelegate.h"
#import "RouteDetailsController.h"

@implementation RoutesInfoController

@synthesize table;
@synthesize search;
@synthesize allRoutesInfo;
@synthesize routesInfo;
@synthesize navigationItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [table release];
    [search release];
    [allRoutesInfo release];
    [routesInfo release];
    [navigationItem release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RussiaRoutesAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	self.allRoutesInfo = [appDelegate.routesDb getRoutesInfo];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationItem.leftBarButtonItem = nil;
    }
    
    [self resetSearch];
	[table reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.table = nil;
    self.search = nil;
    self.allRoutesInfo = nil;
    self.routesInfo = nil;
    self.navigationItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark -

- (IBAction)done:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table View methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [routesInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *routeInfoCellId = @"RouteInfoCellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:routeInfoCellId];
    
    if (nil == cell) {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:routeInfoCellId] autorelease];
    }
    
    NSUInteger row = [indexPath row];
    NSMutableArray *routeInfoData = [routesInfo objectAtIndex:row];
    NSString *routeNumber = [routeInfoData objectAtIndex:0];
    NSString *routeName = [routeInfoData objectAtIndex:1];
    
    cell.textLabel.text = routeNumber;
    cell.detailTextLabel.text = routeName;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[search resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showRouteDetails:indexPath];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self showRouteDetails:indexPath];
}

- (void)showRouteDetails:(NSIndexPath *)indexPath {
    NSString *nibName = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"iPadRouteDetailsView" : @"RouteDetailsController";
    
    RouteDetailsController *routeDetailsController = [[RouteDetailsController alloc]
                                                    initWithNibName:nibName
                                                    bundle:nil];
    
    NSUInteger row = [indexPath row];
    NSMutableArray *routeInfoData = [routesInfo objectAtIndex:row];
    routeDetailsController.routeInfoData = routeInfoData;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        routeDetailsController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    } else {
        routeDetailsController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    
    [self presentModalViewController:routeDetailsController animated:YES];
    
    [routeDetailsController release];
}

#pragma mark -
#pragma mark Search Bar methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSString *searchTerm = [searchBar text];
	[self handleSearchForTerm:searchTerm];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm {
	if (0 == [searchTerm length]) {
		[self resetSearch];
		[table reloadData];
		return;
	}
	
	[self handleSearchForTerm:searchTerm];
}

#pragma mark -
#pragma mark Custom methods

- (void)resetSearch {
	NSMutableArray *allRoutesInfoCopy = [self.allRoutesInfo mutableCopy];
	self.routesInfo = allRoutesInfoCopy;
	[allRoutesInfoCopy release];
}

- (void)handleSearchForTerm:(NSString *)searchTerm {
	NSMutableArray *toRemove = [[NSMutableArray alloc] init];
	[self resetSearch];
	
	for (NSMutableArray *routeInfoData in self.routesInfo) {
        NSString *routeNumber = [routeInfoData objectAtIndex:0];
        NSString *routeName = [routeInfoData objectAtIndex:1];
        NSString *routeDetails = [routeInfoData objectAtIndex:2];
        if (([routeNumber rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location == NSNotFound)
            && ([routeDetails rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location == NSNotFound)
            && ([routeName rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != 0)
        ) {
            [toRemove addObject:routeInfoData];
        }
	}
    
	[self.routesInfo removeObjectsInArray:toRemove];
	[toRemove release];
	
	[table reloadData];
}

@end
