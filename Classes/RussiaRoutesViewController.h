//
//  RussiaRoutesViewController.h
//  RussiaRoutes
//

#import <UIKit/UIKit.h>
#import "ResultsViewController.h"
#import "CitySelectViewController.h"
#import "City.h"

@class CitySelectViewController;
@class ResultsViewController;

@interface RussiaRoutesViewController : UIViewController 
	<ResultsViewControllerDelegate, CitySelectViewControllerDelegate, UIActionSheetDelegate, MapViewControllerDelegate>
{
	UIButton *selectStartCityButton;
	UIButton *selectEndCityButton;
    UIButton *selectInterCity1Button;
    UIButton *selectInterCity2Button;
    UIButton *selectInterCity3Button;
    UIButton *selectInterCity4Button;
	UIButton *currentSelectButton;
	UIButton *findRouteButton;
    UIButton *cancelStartCity;
    UIButton *cancelEndCity;
    UIButton *cancelInterCity1;
    UIButton *cancelInterCity2;
    UIButton *cancelInterCity3;
    UIButton *cancelInterCity4;
    UIButton *spawCitiesButton;
    UIImageView *backgroundImage;
    UIView *buttonsContainer;
	
	City *startCity;
	City *endCity;
    City *interCity1;
    City *interCity2;
    City *interCity3;
    City *interCity4;
	NSMutableArray *routeDetails;
    BOOL isRouteChanged;
    UIPopoverController *popoverController;
}

@property (nonatomic, retain) IBOutlet UIButton *selectStartCityButton;
@property (nonatomic, retain) IBOutlet UIButton *selectEndCityButton;
@property (nonatomic, retain) IBOutlet UIButton *selectInterCity1Button;
@property (nonatomic, retain) IBOutlet UIButton *selectInterCity2Button;
@property (nonatomic, retain) IBOutlet UIButton *selectInterCity3Button;
@property (nonatomic, retain) IBOutlet UIButton *selectInterCity4Button;
@property (nonatomic, retain) IBOutlet UIButton *findRouteButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelStartCity;
@property (nonatomic, retain) IBOutlet UIButton *cancelEndCity;
@property (nonatomic, retain) IBOutlet UIButton *cancelInterCity1;
@property (nonatomic, retain) IBOutlet UIButton *cancelInterCity2;
@property (nonatomic, retain) IBOutlet UIButton *cancelInterCity3;
@property (nonatomic, retain) IBOutlet UIButton *cancelInterCity4;
@property (nonatomic, retain) IBOutlet UIButton *swapCitiesButton;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) IBOutlet UIView *buttonsContainer;
@property (nonatomic, retain) City *startCity;
@property (nonatomic, retain) City *endCity;
@property (nonatomic, retain) City *interCity1;
@property (nonatomic, retain) City *interCity2;
@property (nonatomic, retain) City *interCity3;
@property (nonatomic, retain) City *interCity4;
@property (nonatomic, retain) NSMutableArray *routeDetails;
@property BOOL isRouteChanged;
@property (nonatomic, retain) UIPopoverController *popoverController;

- (void)initButtons;
- (IBAction)selectStartCity:(id)sender;
- (IBAction)selectEndCity:(id)sender;
- (IBAction)selectInterCity1:(id)sender;
- (IBAction)selectInterCity2:(id)sender;
- (IBAction)selectInterCity3:(id)sender;
- (IBAction)selectInterCity4:(id)sender;
- (void)selectCity:(id)sender;
- (IBAction)calculatePressed:(id)sender;
- (void)showLoadingIndicator:(NSString *)aTitle sel:(SEL)aSelector;
- (void)loadDatabase:(id)sender;
- (void)calculateRoute:(id)sender;
- (void)showErrorAlert:(NSString *)aMessage;
- (void)showResultsView;
- (IBAction)swapCities:(id)sender;
- (IBAction)cancelCitySelection:(id)sender;
- (void)resetButtonState:(UIButton *)button;
- (BOOL)isUniqueCitiesSelected;
- (void)adjustInterface:(UIInterfaceOrientation)interfaceOrientation;
- (void)swapTwoCities:(City **)firstCity secondCity:(City **)secondCity firstButton:(UIButton *)firstButton secondButton:(UIButton *)secondButton;

@end

