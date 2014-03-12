//
//  Segment.h
//  RussiaRoutes
//

#import <Foundation/Foundation.h>

@interface Segment : NSObject {
	NSString *name;
	int distance;
    int time;
}

@property (nonatomic, retain) NSString *name;
@property int distance;
@property int time;

- (id)initWithNameAndDistance:(NSString *)aName distance:(int)aDistance time:(int)aTime;

@end
