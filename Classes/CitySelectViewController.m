//
//  CitySelectViewController.m
//  RussiaRoutes
//

#import "CitySelectViewController.h"
#import "NSDictionary-MutableDeepCopy.h"
#import "RussiaRoutesAppDelegate.h"

@implementation CitySelectViewController

@synthesize table;
@synthesize search;
@synthesize locate;
@synthesize navigationItem;
@synthesize delegate;
@synthesize keys;
@synthesize citiesDict;
@synthesize allCitiesDict;
@synthesize defaultCityName;
@synthesize isStartCity;
@synthesize locationManager;

- (void)viewDidLoad {
    [locate setEnabled:isStartCity];
    
	RussiaRoutesAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	self.allCitiesDict = [appDelegate.routesDb getCities];
	[self resetSearch];
	[table reloadData];

	if (![defaultCityName isEqualToString:@"выбрать город"]) {
		[self showDefaultCity];
	}
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationItem.leftBarButtonItem = nil;
    }
    
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.table = nil;
	self.search = nil;
    self.locate = nil;
    self.navigationItem = nil;
	self.keys = nil;
	self.citiesDict = nil;
	self.allCitiesDict = nil;
	
    [super viewDidUnload];
}

- (void)dealloc {
	[table release];
	[search release];
    [locate release];
    [navigationItem release];
	[keys release];
	[citiesDict release];
	[allCitiesDict release];
    [locationManager release];
	
    [super dealloc];
}

- (BOOL)shouldAutorotate {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }

    return NO;
}

#pragma mark -
#pragma mark Table View methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	NSArray *citiesSection = [citiesDict objectForKey:[keys objectAtIndex:section]];
	City *city = [citiesSection objectAtIndex:row];
	
	[self.delegate setCity:city];
	
	[self.delegate citySelectViewControllerDidFinish:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return ([keys count] > 0) ? [keys count] : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (0 == [keys count]) {
		return 0;
	}
	
	NSMutableArray *citiesSection = (NSMutableArray *)[citiesDict valueForKey:(NSString *)[keys objectAtIndex:section]];
	return [citiesSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	
	NSString *key = [keys objectAtIndex:section];
	NSArray *citiesSection = [citiesDict objectForKey:key];
	
	static NSString *citySelectTableId = @"CitySelectTableId";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:citySelectTableId];
	
	if (nil == cell) {
		cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleSubtitle
				 reuseIdentifier:citySelectTableId] autorelease];
	}
	
	City *city = [citiesSection objectAtIndex:row];
	cell.textLabel.text = city.name;
	cell.detailTextLabel.text = city.region;
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (0 == [keys count]) {
		return nil;
	}
	
	NSString *key = [keys objectAtIndex:section];
	return key;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if (isSearching) {
		return nil;
	}
	
	return keys;
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
		isSearching = NO;
		[self resetSearch];
		[table reloadData];
		return;
	}
	
	isSearching = YES;
	[self handleSearchForTerm:searchTerm];
}

#pragma mark -
#pragma mark Custom methods

- (void)resetSearch {
	NSMutableDictionary *allCitiesDictCopy = [self.allCitiesDict mutableDeepCopy];
	self.citiesDict = allCitiesDictCopy;
	[allCitiesDictCopy release];
	
	NSMutableArray *keyArray = [[NSMutableArray alloc] init];
	[keyArray addObjectsFromArray:[[self.allCitiesDict allKeys] sortedArrayUsingSelector:@selector(compare:)]];
	self.keys = keyArray;
	[keyArray release];
}

- (void)handleSearchForTerm:(NSString *)searchTerm {
	NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
	[self resetSearch];
	
	for (NSString *key in self.keys) {
		NSMutableArray *array = [citiesDict valueForKey:key];
		NSMutableArray *toRemove = [[NSMutableArray alloc] init];
		
		for (City *city in array) {
			NSString *name = city.name;
			if ([name rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != 0) {
				[toRemove addObject:city];
			}
		}
		
		if ([array count] == [toRemove count]) {
			[sectionsToRemove addObject:key];
		}
		
		[array removeObjectsInArray:toRemove];
		[toRemove release];
	}
	
	[self.keys removeObjectsInArray:sectionsToRemove];
	[sectionsToRemove release];
	
	[table reloadData];
}

- (IBAction)done:(id)sender {
	[self.delegate citySelectViewControllerDidFinish:self];
}

- (IBAction)locate:(id)sender {
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [manager stopUpdatingLocation];

    RussiaRoutesAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	City *city = [appDelegate.routesDb getCityByLocation:newLocation];
    [self.delegate setCity:city];
    
    [self.delegate citySelectViewControllerDidFinish:self];
}

- (void)showDefaultCity {
	search.text = defaultCityName;
	
	NSString *firstChar = [NSString stringWithFormat:@"%C", [defaultCityName characterAtIndex:0]];
	NSUInteger sectionIndex = [[[allCitiesDict allKeys] sortedArrayUsingSelector:@selector(compare:)] indexOfObject:firstChar];
	
	NSMutableArray *section = (NSMutableArray *)[allCitiesDict valueForKey:firstChar];
	NSUInteger rowIndex = 0;
	for (int index = 0; index < [section count]; index++) {
		City *city = [section objectAtIndex:index];
		if ([defaultCityName isEqualToString:city.name]) {
			rowIndex = index;
			break;
		}
	}
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
	[table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];	
}

@end
