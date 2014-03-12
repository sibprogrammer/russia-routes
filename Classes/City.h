//
//  City.h
//  RussiaRoutes
//

#import <Foundation/Foundation.h>

@interface City : NSObject {
	int identity;
	NSString *name;
	int distance;
    int time;
	int population;
	NSString *region;
    NSString *latitude;
    NSString *longitude;
}

@property int identity;
@property (nonatomic, retain) NSString *name;
@property int distance;
@property int time;
@property int population;
@property (nonatomic, retain) NSString *region;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;

- (id)initWithNameAndIdentity:(NSString *)aName identity:(int)anIdentity;

@end
