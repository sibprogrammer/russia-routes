//
//  RoutesDb.h
//  RussiaRoutes
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "City.h"
#import "Segment.h"
#import <CoreLocation/CoreLocation.h>

@interface RoutesDb : NSObject {
	sqlite3 *database;
	NSMutableDictionary *allCities;
	NSMutableArray *citiesIndex;
	NSMutableDictionary *allRoutes;
	NSMutableDictionary *citiesIds;
}

@property (nonatomic, retain) NSMutableDictionary *allCities;
@property (nonatomic, retain) NSMutableArray *citiesIndex;
@property (nonatomic, retain) NSMutableDictionary *allRoutes;
@property (nonatomic, retain) NSMutableDictionary *citiesIds;

- (NSMutableDictionary *)getCities;
- (NSMutableDictionary *)loadCities;
- (void)loadRoutes;
- (NSMutableArray *)calculateRoute:(City *)startCity interCity1:(City *)interCity1 interCity2:(City *)interCity2 
                        interCity3:(City *)interCity3 interCity4:(City *)interCity4 endCity:(City *)endCity;
- (NSMutableArray *)calculateTwoCitiesRoute:(City *)startCity endCity:(City *)endCity;
- (NSMutableArray *)mergeRoutes:(NSMutableArray *)firstRoute secondRoute:(NSMutableArray *)secondRoute;
- (int)getDistance:(int)startCity endCity:(int)endCity;
- (City *)getCityByIdentity:(int)anIdentity;
- (Segment *)getSegment:(City *)aStartCity endCity:(City *)anEndCity;
- (City *)getCityByLocation:(CLLocation *)location;
- (NSMutableArray *)getRegionCodes;
- (NSMutableArray *)getRoutesInfo;
- (int)getCityDelay:(int)aCitySize;
- (int)getRoadTime:(int)aDistance roadType:(int)aRoadType;

@end
