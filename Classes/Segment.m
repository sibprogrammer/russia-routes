//
//  Segment.m
//  RussiaRoutes
//

#import "Segment.h"

@implementation Segment

@synthesize name;
@synthesize distance;
@synthesize time;

- (id)initWithNameAndDistance:(NSString *)aName distance:(int)aDistance time:(int)aTime {
	self = [super init];
	
	if (self) {
		name = [aName copy];
		distance = aDistance;
        time = aTime;
	}
	
	return self;
}

- (void)dealloc {
	[name release];
	
	[super dealloc];
}

@end
