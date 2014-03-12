//
//  RussiaRoutesViewController.m
//  RussiaRoutes
//

#import "RussiaRoutesViewController.h"
#import "RussiaRoutesAppDelegate.h"

@implementation RussiaRoutesViewController

@synthesize selectStartCityButton;
@synthesize selectEndCityButton;
@synthesize selectInterCity1Button;
@synthesize selectInterCity2Button;
@synthesize selectInterCity3Button;
@synthesize selectInterCity4Button;
@synthesize findRouteButton;
@synthesize cancelStartCity;
@synthesize cancelEndCity;
@synthesize cancelInterCity1;
@synthesize cancelInterCity2;
@synthesize cancelInterCity3;
@synthesize cancelInterCity4;
@synthesize swapCitiesButton;
@synthesize backgroundImage;
@synthesize buttonsContainer;
@synthesize startCity;
@synthesize endCity;
@synthesize interCity1;
@synthesize interCity2;
@synthesize interCity3;
@synthesize interCity4;
@synthesize routeDetails;
@synthesize isRouteChanged;
@synthesize popoverController;

- (void)viewDidLoad {
    [self initButtons];
	
    if (startCity) {
        currentSelectButton = selectStartCityButton;
        [self setCity:startCity];
    }

    if (interCity1) {
        currentSelectButton = selectInterCity1Button;
        [self setCity:interCity1];
    }

    if (interCity2) {
        currentSelectButton = selectInterCity2Button;
        [self setCity:interCity2];
    }

    if (interCity3) {
        currentSelectButton = selectInterCity3Button;
        [self setCity:interCity3];
    }

    if (interCity4) {
        currentSelectButton = selectInterCity4Button;
        [self setCity:interCity4];
    }

    if (endCity) {
        currentSelectButton = selectEndCityButton;
        [self setCity:endCity];
    }
    
    [self adjustInterface:[[UIApplication sharedApplication] statusBarOrientation]];
	
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    RussiaRoutesAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
	if (nil == appDelegate.routesDb) {
		[self showLoadingIndicator:@"Загрузка базы данных..." sel:@selector(loadDatabase:)];
	}
    
    [self adjustInterface:[[UIApplication sharedApplication] statusBarOrientation]];
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

- (void)showLoadingIndicator:(NSString *)aTitle sel:(SEL)aSelector {
	UIActivityIndicatorView *progressView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(5, 10, 25, 25)];
    progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:aTitle  
															 delegate:self  
													cancelButtonTitle:nil  
											   destructiveButtonTitle:nil  
													otherButtonTitles:nil
								  ];  
	
    [actionSheet addSubview:progressView];  
    [actionSheet showInView:self.view];
    [progressView startAnimating];  
	
    [self performSelector:aSelector withObject:actionSheet afterDelay:0.1f];  
    [progressView release];  
}

- (void)loadDatabase:(id)sender {
	RussiaRoutesAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	appDelegate.routesDb = [[RoutesDb alloc] init];
	
    UIActionSheet *actionSheet = (UIActionSheet *)sender;  
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];  
    [actionSheet release];
}

- (void)initButtons {
	UIImage *whiteButtonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *whiteStretchableButtonImageNormal = [whiteButtonImageNormal
											 stretchableImageWithLeftCapWidth:12
											 topCapHeight:0];
	[selectStartCityButton setBackgroundImage:whiteStretchableButtonImageNormal forState:UIControlStateNormal];
	[selectEndCityButton setBackgroundImage:whiteStretchableButtonImageNormal forState:UIControlStateNormal];
    [selectInterCity1Button setBackgroundImage:whiteStretchableButtonImageNormal forState:UIControlStateNormal];
    [selectInterCity2Button setBackgroundImage:whiteStretchableButtonImageNormal forState:UIControlStateNormal];
    [selectInterCity3Button setBackgroundImage:whiteStretchableButtonImageNormal forState:UIControlStateNormal];
    [selectInterCity4Button setBackgroundImage:whiteStretchableButtonImageNormal forState:UIControlStateNormal];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [swapCitiesButton setBackgroundImage:whiteStretchableButtonImageNormal forState:UIControlStateNormal];
    }
	
	UIImage *blueButtonImageNormal = [UIImage imageNamed:@"blueButton.png"];
	UIImage *blueStretchableButtonImageNormal = [blueButtonImageNormal
											 stretchableImageWithLeftCapWidth:12
											 topCapHeight:0];
	[findRouteButton setBackgroundImage:blueStretchableButtonImageNormal forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
	// TODO: Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.selectStartCityButton = nil;
	self.selectEndCityButton = nil;
    self.selectInterCity1Button = nil;
    self.selectInterCity2Button = nil;
    self.selectInterCity3Button = nil;
    self.selectInterCity4Button = nil;
	self.findRouteButton = nil;
    self.cancelStartCity = nil;
    self.cancelEndCity = nil;
    self.cancelInterCity1 = nil;
    self.cancelInterCity2 = nil;
    self.cancelInterCity3 = nil;
    self.cancelInterCity4 = nil;
    self.swapCitiesButton = nil;
	
	[super viewDidUnload];
}

- (IBAction)selectStartCity:(id)sender {
	[self selectCity:sender];
}

- (IBAction)selectEndCity:(id)sender {
	[self selectCity:sender];
}

- (IBAction)selectInterCity1:(id)sender {
	[self selectCity:sender];
}

- (IBAction)selectInterCity2:(id)sender {
	[self selectCity:sender];
}

- (IBAction)selectInterCity3:(id)sender {
	[self selectCity:sender];
}

- (IBAction)selectInterCity4:(id)sender {
	[self selectCity:sender];
}

- (void)selectCity:(id)sender {
	currentSelectButton = (UIButton *)sender;
	
	CitySelectViewController *citySelectController = [[CitySelectViewController alloc]
													  initWithNibName:@"CitySelectViewController"
													  bundle:nil];
	citySelectController.delegate = self;
	citySelectController.defaultCityName = currentSelectButton.titleLabel.text;
    citySelectController.isStartCity = (currentSelectButton == selectStartCityButton);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        citySelectController.contentSizeForViewInPopover = CGSizeMake(500, 650);
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:citySelectController];
        [popoverController presentPopoverFromRect:currentSelectButton.frame inView:self.buttonsContainer permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        citySelectController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:citySelectController animated:YES];
    }
      
	[citySelectController release];
}

- (IBAction)swapCities:(id)sender {
    [self swapTwoCities:&startCity secondCity:&endCity firstButton:selectStartCityButton secondButton:selectEndCityButton];
    [self swapTwoCities:&interCity1 secondCity:&interCity4 firstButton:selectInterCity1Button secondButton:selectInterCity4Button];
    [self swapTwoCities:&interCity2 secondCity:&interCity3 firstButton:selectInterCity2Button secondButton:selectInterCity3Button];
    isRouteChanged = YES;
}

- (void)swapTwoCities:(City **)firstCity secondCity:(City **)secondCity firstButton:(UIButton *)firstButton secondButton:(UIButton *)secondButton {
    City *tmpCity = *firstCity;
    *firstCity = *secondCity;
    *secondCity = tmpCity;
    
    NSString *tmpCityName = [firstButton.titleLabel.text copy]; 
    UIColor *tmpColor = [firstButton titleColorForState:UIControlStateNormal];
    
    [firstButton setTitle:secondButton.titleLabel.text forState:UIControlStateNormal];
    [secondButton setTitle:tmpCityName forState:UIControlStateNormal];
    
	[firstButton setTitleColor:[secondButton titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
    [secondButton setTitleColor:tmpColor forState:UIControlStateNormal];
    
    [tmpCityName release];
}

- (IBAction)cancelCitySelection:(id)sender {
    if (sender == cancelStartCity) {
        startCity = nil;
        [self resetButtonState:selectStartCityButton];
    } else if (sender == cancelEndCity) {
        endCity = nil;
        [self resetButtonState:selectEndCityButton];
    } else if (sender == cancelInterCity1) {
        interCity1 = nil;
        [self resetButtonState:selectInterCity1Button];
    } else if (sender == cancelInterCity2) {
        interCity2 = nil;
        [self resetButtonState:selectInterCity2Button];
    } else if (sender == cancelInterCity3) {
        interCity3 = nil;
        [self resetButtonState:selectInterCity3Button];
    } else if (sender == cancelInterCity4) {
        interCity4 = nil;
        [self resetButtonState:selectInterCity4Button];
    }
	
    isRouteChanged = YES;
}

- (void)resetButtonState:(UIButton *)button {
    [button setTitle:@"выбрать город" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (void)showErrorAlert:(NSString *)aMessage {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Ошибка"
						  message:aMessage
						  delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (IBAction)calculatePressed:(id)sender {
	if (nil == startCity) {
		[self showErrorAlert:@"Выберите город начала маршрута."];
		return;
	} else if (nil == endCity) {
		[self showErrorAlert:@"Выберите город конца маршрута."];
		return;
	}
    
    if (![self isUniqueCitiesSelected]) {
		[self showErrorAlert:@"Города маршрута должны быть уникальными."];
		return;
	}
	
	if (nil == routeDetails || isRouteChanged) {
		[self showLoadingIndicator:@"Расчет маршрута..." sel:@selector(calculateRoute:)];
        isRouteChanged = NO;
	} else {
		[self showResultsView];
	}
}

- (BOOL)isUniqueCitiesSelected {
    NSMutableArray *origCities = [[NSMutableArray alloc] init];
    
    [origCities addObject:startCity];
    [origCities addObject:endCity];

    if (interCity1) {
        [origCities addObject:interCity1];
    }

    if (interCity2) {
        [origCities addObject:interCity2];
    }

    if (interCity3) {
        [origCities addObject:interCity3];
    }

    if (interCity4) {
        [origCities addObject:interCity4];
    }

    NSSet *uniqueCities = [NSSet setWithArray:[origCities valueForKey:@"identity"]];
    BOOL result = [origCities count] == [uniqueCities count];
    
    [origCities release];
    
    return result;
}

- (void)calculateRoute:(id)sender {
	RussiaRoutesAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	self.routeDetails = [appDelegate.routesDb calculateRoute:startCity interCity1:interCity1 interCity2:interCity2 
                                                  interCity3:interCity3 interCity4:interCity4 endCity:endCity];
	
	UIActionSheet *actionSheet = (UIActionSheet *)sender;  
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];  
    [actionSheet release];
	
	if (nil == routeDetails) {
		[self showErrorAlert:@"Нет маршрута."];
	} else {
		[self showResultsView];
	}
}

- (void)showResultsView {
	ResultsViewController *resultsController = [[ResultsViewController alloc]
												initWithNibName:@"ResultsViewController"
												bundle:nil];
	
	resultsController.routeDetails = self.routeDetails;
	resultsController.delegate = self;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        resultsController.contentSizeForViewInPopover = CGSizeMake(500, 1024);
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:resultsController];
        [popoverController presentPopoverFromRect:findRouteButton.frame inView:self.buttonsContainer permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        resultsController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:resultsController animated:YES];
    }
    
	[resultsController release];
}

- (void)dealloc {
	[selectStartCityButton release];
	[selectEndCityButton release];
    [selectInterCity1Button release];
    [selectInterCity2Button release];
    [selectInterCity3Button release];
    [selectInterCity4Button release];
	[findRouteButton release];
    [cancelStartCity release];
    [cancelEndCity release];
    [cancelInterCity1 release];
    [cancelInterCity2 release];
    [cancelInterCity3 release];
    [cancelInterCity4 release];
    [swapCitiesButton release];
	[startCity release];
	[endCity release];
    [interCity1 release];
    [interCity2 release];
    [interCity3 release];
    [interCity4 release];
    [popoverController release];
    [buttonsContainer release];
	
    [super dealloc];
}

#pragma mark -

- (void)resultsViewControllerDidFinish:(ResultsViewController *)controller {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [popoverController dismissPopoverAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)resultsViewControllerShowMap {
    [popoverController dismissPopoverAnimated:YES];
    
    MapViewController *mapController = [[MapViewController alloc]
                                        initWithNibName:@"MapViewController"
                                        bundle:nil];
	mapController.delegate = self;
    mapController.routeDetails = self.routeDetails;
	mapController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:mapController animated:YES];
	[mapController release];
}

- (void)mapViewControllerDidFinish:(MapViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
    [self showResultsView];
}

- (void)citySelectViewControllerDidFinish:(CitySelectViewController *)controller {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [popoverController dismissPopoverAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)setCity:(City *)city {
	UIButton *button = currentSelectButton;	
	[button setTitle:city.name forState:UIControlStateNormal];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

	if (currentSelectButton == selectStartCityButton) {
		startCity = city;
    } else if (currentSelectButton == selectInterCity1Button) {
        interCity1 = city;
    } else if (currentSelectButton == selectInterCity2Button) {
        interCity2 = city;
    } else if (currentSelectButton == selectInterCity3Button) {
        interCity3 = city;
    } else if (currentSelectButton == selectInterCity4Button) {
        interCity4 = city;
	} else {
		endCity = city;
	}

    isRouteChanged = YES;
}

- (void)adjustInterface:(UIInterfaceOrientation)interfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
            backgroundImage.frame = CGRectMake(0, 0, 768, 1004);
            backgroundImage.image = [UIImage imageNamed:@"Default-Portrait~ipad.png"];
            buttonsContainer.frame = CGRectMake(0, 60, 768, 131);
        } else {
            backgroundImage.frame = CGRectMake(0, 0, 1024, 748);
            backgroundImage.image = [UIImage imageNamed:@"Default-Landscape~ipad.png"];
            buttonsContainer.frame = CGRectMake(128, 60, 768, 131);
        }
    }
}

@end
