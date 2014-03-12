//
//  RegionCodesController.m
//  RussiaRoutes
//

#import "RegionCodesController.h"
#import "RegionCodeCell.h"
#import "RussiaRoutesAppDelegate.h"

@implementation RegionCodesController

@synthesize table;
@synthesize regionCodes;
@synthesize allRegionCodes;
@synthesize search;
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
    [regionCodes release];
    [allRegionCodes release];
    [search release];
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
	self.allRegionCodes = [appDelegate.routesDb getRegionCodes];
    
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
    self.regionCodes = nil;
    self.allRegionCodes = nil;
    self.search = nil;
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
	return [regionCodes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *regionCodeCellId = @"RegionCodeCellId";
	
	RegionCodeCell *cell = (RegionCodeCell *)[tableView dequeueReusableCellWithIdentifier:regionCodeCellId];
	
	if (nil == cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RegionCodeCell" owner:self options:nil];
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:[RegionCodeCell class]]) {
				cell = (RegionCodeCell *)oneObject;
			}
		}
	}
    
    NSUInteger row = [indexPath row];
    NSMutableArray *regionCodeData = [regionCodes objectAtIndex:row];
    NSNumber *regionCode = [regionCodeData objectAtIndex:0];
    NSString *regionName = [regionCodeData objectAtIndex:1];
	
	cell.regionCode.text = [regionCode stringValue];
    if (1 == [cell.regionCode.text length]) {
        cell.regionCode.text = [NSString stringWithFormat:@"0%@", regionCode];
    }
    
	cell.regionName.text = regionName;
	
	return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[search resignFirstResponder];
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
	NSMutableArray *allRegionCodesCopy = [self.allRegionCodes mutableCopy];
	self.regionCodes = allRegionCodesCopy;
	[allRegionCodesCopy release];
}

- (void)handleSearchForTerm:(NSString *)searchTerm {
	NSMutableArray *toRemove = [[NSMutableArray alloc] init];
	[self resetSearch];
	
	for (NSMutableArray *regionCodeData in self.regionCodes) {
        NSNumber *regionCode = [regionCodeData objectAtIndex:0];
        NSString *regionName = [regionCodeData objectAtIndex:1];
        if (([[regionCode stringValue] rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != 0)
            && ([regionName rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != 0)) {
            [toRemove addObject:regionCodeData];
        }
	}
    
	[self.regionCodes removeObjectsInArray:toRemove];
	[toRemove release];
	
	[table reloadData];
}

@end
