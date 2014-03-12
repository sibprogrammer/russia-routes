//
//  ReferenceController.m
//  RussiaRoutes
//

#import "ReferenceController.h"
#import "RegionCodesController.h"
#import "RoutesInfoController.h"

@implementation ReferenceController

@synthesize regionCodesButton;
@synthesize routesInfoButton;
@synthesize popoverController;
@synthesize backgroundImage;

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
    [regionCodesButton release];
    [routesInfoButton release];
    [popoverController release];
    [backgroundImage release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self adjustInterface:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)viewDidLoad
{
    [self initButtons];
    [self adjustInterface:[[UIApplication sharedApplication] statusBarOrientation]];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.regionCodesButton = nil;
    self.routesInfoButton = nil;
    self.backgroundImage = nil;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self adjustInterface:toInterfaceOrientation];
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

#pragma mark -

- (void)initButtons {
    UIImage *whiteButtonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *whiteStretchableButtonImageNormal = [whiteButtonImageNormal
                                                  stretchableImageWithLeftCapWidth:12
                                                  topCapHeight:0];
	[regionCodesButton setBackgroundImage:whiteStretchableButtonImageNormal forState:UIControlStateNormal];
    [routesInfoButton setBackgroundImage:whiteStretchableButtonImageNormal forState:UIControlStateNormal];
}

- (IBAction)showRegionCodes:(id)sender {
    RegionCodesController *regionCodesController = [[RegionCodesController alloc]
                                                    initWithNibName:@"RegionCodesController"
                                                    bundle:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        regionCodesController.contentSizeForViewInPopover = CGSizeMake(500, 650);
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:regionCodesController];
        [popoverController presentPopoverFromRect:regionCodesButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        regionCodesController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:regionCodesController animated:YES];
    }

    [regionCodesController release];
}

- (void)showRoutesInfo:(id)sender {
    RoutesInfoController *routesInfoController = [[RoutesInfoController alloc]
                                                  initWithNibName:@"RoutesInfoController"
                                                  bundle:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        routesInfoController.contentSizeForViewInPopover = CGSizeMake(500, 650);
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:routesInfoController];
        [popoverController presentPopoverFromRect:routesInfoButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        routesInfoController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:routesInfoController animated:YES];
    }
    
    [routesInfoController release];
}

- (void)adjustInterface:(UIInterfaceOrientation)interfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
            backgroundImage.frame = CGRectMake(0, 0, 768, 1004);
            backgroundImage.image = [UIImage imageNamed:@"Default-Portrait~ipad.png"];
            
            CGRect regionCodesButtonFrame = regionCodesButton.frame;
            regionCodesButtonFrame.origin.x = 76;
            regionCodesButton.frame = regionCodesButtonFrame;
            CGRect routesInfoButtonFrame = routesInfoButton.frame;
            routesInfoButtonFrame.origin.x = 413;
            routesInfoButton.frame = routesInfoButtonFrame;
        } else {
            backgroundImage.frame = CGRectMake(0, 0, 1024, 748);
            backgroundImage.image = [UIImage imageNamed:@"Default-Landscape~ipad.png"];
            
            CGRect regionCodesButtonFrame = regionCodesButton.frame;
            regionCodesButtonFrame.origin.x = 204;
            regionCodesButton.frame = regionCodesButtonFrame;
            CGRect routesInfoButtonFrame = routesInfoButton.frame;
            routesInfoButtonFrame.origin.x = 541;
            routesInfoButton.frame = routesInfoButtonFrame;
        }
    }
}

@end
