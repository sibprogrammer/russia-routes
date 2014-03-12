//
//  RoutesInfoController.h
//  RussiaRoutes
//

#import <UIKit/UIKit.h>


@interface RoutesInfoController : UIViewController
    <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    UITableView *table;
    UISearchBar *search;
    NSMutableArray *allRoutesInfo;
    NSMutableArray *routesInfo;
    UINavigationItem *navigationItem;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UISearchBar *search;
@property (nonatomic, retain) IBOutlet NSMutableArray *allRoutesInfo;
@property (nonatomic, retain) IBOutlet NSMutableArray *routesInfo;
@property (nonatomic, retain) IBOutlet UINavigationItem *navigationItem;

- (IBAction)done:(id)sender;
- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;
- (void)showRouteDetails:(NSIndexPath *)indexPath;

@end
