//
//  RouteDetailsController.h
//  RussiaRoutes
//

#import <UIKit/UIKit.h>


@interface RouteDetailsController : UIViewController {
    NSMutableArray *routeInfoData;
    UILabel *routeNumberLabel;
    UILabel *routeNumberTitleLabel;
    UILabel *routeNameLabel;
    UILabel *routeNameTitleLabel;
    UILabel *routeDetailsLabel;
    UILabel *routeDetailsTitleLabel;
    UINavigationItem *navigationTitle;
    UIImageView *backgroundImage;
    UIView *dataContainer;
}

@property (nonatomic, assign) NSMutableArray *routeInfoData;
@property (nonatomic, retain) IBOutlet UILabel *routeNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel *routeNumberTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *routeNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *routeNameTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *routeDetailsLabel;
@property (nonatomic, retain) IBOutlet UILabel *routeDetailsTitleLabel;
@property (nonatomic, retain) IBOutlet UINavigationItem *navigationTitle;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) IBOutlet UIView *dataContainer;

- (IBAction)done:(id)sender;
- (void)adjustInterface:(UIInterfaceOrientation)interfaceOrientation;

@end
