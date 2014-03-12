//
//  ReferenceController.h
//  RussiaRoutes
//

#import <UIKit/UIKit.h>


@interface ReferenceController : UIViewController {
    UIButton *regionCodesButton;
    UIButton *routesInfoButton;
    UIPopoverController *popoverController;
    UIImageView *backgroundImage;
}

@property (nonatomic, retain) IBOutlet UIButton *regionCodesButton;
@property (nonatomic, retain) IBOutlet UIButton *routesInfoButton;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;

- (void)initButtons;
- (IBAction)showRegionCodes:(id)sender;
- (IBAction)showRoutesInfo:(id)sender;
- (void)adjustInterface:(UIInterfaceOrientation)interfaceOrientation;

@end
