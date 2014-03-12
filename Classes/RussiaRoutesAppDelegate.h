//
//  RussiaRoutesAppDelegate.h
//  RussiaRoutes
//

#import <UIKit/UIKit.h>
#import "RoutesDb.h"

@class RussiaRoutesViewController;

@interface RussiaRoutesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UITabBarController *rootController;
	RoutesDb *routesDb;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *rootController;
@property (nonatomic, retain) RoutesDb *routesDb;

@end

