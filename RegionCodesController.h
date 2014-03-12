//
//  RegionCodesController.h
//  RussiaRoutes
//

#import <UIKit/UIKit.h>

@interface RegionCodesController : UIViewController 
    <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    UITableView *table;
    NSMutableArray *allRegionCodes;
    NSMutableArray *regionCodes;
    UISearchBar *search;
    UINavigationItem *navigationItem;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *allRegionCodes;
@property (nonatomic, retain) NSMutableArray *regionCodes;
@property (nonatomic, retain) IBOutlet UISearchBar *search;
@property (nonatomic, retain) IBOutlet UINavigationItem *navigationItem;

- (IBAction)done:(id)sender;
- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;

@end
