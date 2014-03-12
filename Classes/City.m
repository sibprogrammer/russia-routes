//
//  City.m
//  RussiaRoutes
//

#import "City.h"

@implementation City

@synthesize identity;
@synthesize name;
@synthesize distance;
@synthesize time;
@synthesize population;
@synthesize region;
@synthesize latitude;
@synthesize longitude;

- (id)initWithNameAndIdentity:(NSString *)aName identity:(int)anIdentity {
	self = [super init];
	
	if (self) {
		name = [aName copy];
		identity = anIdentity;
		distance = 0;
        time = 0;
		population = 0;
	}
	
	return self;
}

- (void)dealloc {
	[name release];
	[region release];
    [latitude release];
    [longitude release];
	
	[super dealloc];
}

@end
