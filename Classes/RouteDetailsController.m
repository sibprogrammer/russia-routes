//
//  RouteDetailsController.m
//  RussiaRoutes
//

#import "RouteDetailsController.h"


@implementation RouteDetailsController

@synthesize routeInfoData;
@synthesize routeNumberLabel;
@synthesize routeNumberTitleLabel;
@synthesize routeNameLabel;
@synthesize routeDetailsLabel;
@synthesize routeNameTitleLabel;
@synthesize routeDetailsTitleLabel;
@synthesize navigationTitle;
@synthesize backgroundImage;
@synthesize dataContainer;

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
    [routeNumberLabel release];
    [routeNumberTitleLabel release];
    [routeNameLabel release];
    [routeDetailsLabel release];
    [routeNameTitleLabel release];
    [routeDetailsTitleLabel release];
    [navigationTitle release];
    [backgroundImage release];
    [dataContainer release];
    
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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *routeNumber = [routeInfoData objectAtIndex:0];
    NSString *routeName = [routeInfoData objectAtIndex:1];
    NSString *routeDetails = [routeInfoData objectAtIndex:2];
    
    routeNumberLabel.text = routeNumber;
    routeNameLabel.text = (0 == [routeName length]) ? @"—" : routeName;
    navigationTitle.title = [NSString stringWithFormat:@"Трасса %@", routeNumber];
    
    CGSize labelSize = CGSizeMake(280, 180);
    CGSize theStringSize = [routeDetails sizeWithFont:routeDetailsLabel.font constrainedToSize:labelSize lineBreakMode:routeDetailsLabel.lineBreakMode];
    routeDetailsLabel.frame = CGRectMake(routeDetailsLabel.frame.origin.x, routeDetailsLabel.frame.origin.y, theStringSize.width, theStringSize.height);
    routeDetailsLabel.text = routeDetails;
    
    [self adjustInterface:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.routeNumberLabel = nil;
    self.routeNumberTitleLabel = nil;
    self.routeNameLabel = nil;
    self.routeDetailsLabel = nil;
    self.routeNameTitleLabel = nil;
    self.routeDetailsTitleLabel = nil;
    self.navigationTitle = nil;
    self.backgroundImage = nil;
    self.dataContainer = nil;
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
	[self dismissModalViewControllerAnimated:YES];
}

- (void)adjustInterface:(UIInterfaceOrientation)interfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
            backgroundImage.frame = CGRectMake(0, 0, 768, 1004);
            backgroundImage.image = [UIImage imageNamed:@"Default-Portrait~ipad.png"];
            dataContainer.frame = CGRectMake(0, 54, 768, 451);
        } else {
            backgroundImage.frame = CGRectMake(0, 0, 1024, 748);
            backgroundImage.image = [UIImage imageNamed:@"Default-Landscape~ipad.png"];
            dataContainer.frame = CGRectMake(128, 54, 768, 451);
        }
    }
}

@end
