//
//  RoutesDb.m
//  RussiaRoutes
//

#import "RoutesDb.h"
#import "City.h"

#define kInfinity 999999

@implementation RoutesDb

@synthesize allCities;
@synthesize citiesIndex;
@synthesize allRoutes;
@synthesize citiesIds;

- (id)init {
	self = [super init];
	
	if (self) {
		NSString *dbFileName = [[NSBundle mainBundle] pathForResource:@"routes" ofType:@"db"];
		if (sqlite3_open([dbFileName UTF8String], &database) != SQLITE_OK) {
			sqlite3_close(database);
			NSAssert(0, @"Failed to open database.");
		}
		self.allCities = [self loadCities];
		[self loadRoutes];
	}
	
	return self;
}

- (void)dealloc {
	sqlite3_close(database);
	[allCities release];
	[citiesIndex release];
	[allRoutes release];
	[citiesIds release];
	
	[super dealloc];
}

- (NSMutableDictionary *)getCities {
	return allCities;
}

- (NSMutableDictionary *)loadCities {
	NSMutableDictionary *allCitiesDict = [[NSMutableDictionary alloc] init];
	self.citiesIndex = [[NSMutableArray alloc] init];
	self.citiesIds = [[NSMutableDictionary alloc] init];
	
	NSString *query = @"SELECT cities.id, cities.name, regions.name, latitude, longitude, population FROM cities LEFT JOIN regions ON cities.region_id = regions.id ORDER BY cities.name";
	sqlite3_stmt *statement;
	int cityIndex = 0;
	
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			int cityId = sqlite3_column_int(statement, 0);
			char *cityName = (char *)sqlite3_column_text(statement, 1);
			char *regionName = (char *)sqlite3_column_text(statement, 2);
            char *latitude = (char *)sqlite3_column_text(statement, 3);
            char *longitude = (char *)sqlite3_column_text(statement, 4);
            int population = sqlite3_column_int(statement, 5);
			
			[citiesIndex addObject:[NSNumber numberWithInt:cityId]];
			[citiesIds setValue:[NSNumber numberWithInt:cityIndex] forKey:[[NSNumber numberWithInt:cityId] stringValue]];
			cityIndex++;
			
			NSString *cityNameString = [[NSString alloc] initWithUTF8String:cityName];
			City *city = [[City alloc] initWithNameAndIdentity:cityNameString identity:cityId];
			city.latitude = [NSString stringWithUTF8String:latitude];
            city.longitude = [NSString stringWithUTF8String:longitude];
			city.region = (NULL == regionName) ? @"" : [NSString stringWithUTF8String:regionName];
            city.population = population;
			
			NSString *firstChar = [NSString stringWithFormat:@"%C", [cityNameString characterAtIndex:0]];
			
			NSMutableArray *citiesSectionFromDict = (NSMutableArray *)[allCitiesDict valueForKey:firstChar];
			NSMutableArray *citiesSection;
			
			if (nil == citiesSectionFromDict) {
				citiesSection = [[NSMutableArray alloc] init];
			} else {
				citiesSection = citiesSectionFromDict;
			}
			
			[citiesSection addObject:city];
			[allCitiesDict setValue:citiesSection forKey:firstChar];
			
			[cityNameString release];
			[city release];
		}
		
		sqlite3_finalize(statement);
	}
	
	return [allCitiesDict autorelease];
}

- (void)loadRoutes {
	self.allRoutes = [[NSMutableDictionary alloc] init];
	
	NSString *query = @"SELECT city1, city2, length FROM routes ORDER BY id";
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			int city1Id = sqlite3_column_int(statement, 0);
			int city2Id = sqlite3_column_int(statement, 1);
			int length = sqlite3_column_int(statement, 2);
			
			NSMutableDictionary *routesVector;
			NSNumber *routeLength;

			routesVector = [allRoutes objectForKey:[NSNumber numberWithInt:city1Id]];

			if (nil == routesVector) {
				NSMutableDictionary *newRoutesVector = [[NSMutableDictionary alloc] init];
				[allRoutes setObject:newRoutesVector forKey:[NSNumber numberWithInt:city1Id]];
				[newRoutesVector release];
				routesVector = [allRoutes objectForKey:[NSNumber numberWithInt:city1Id]];
			}
			
			routeLength = [NSNumber numberWithInt:length];
			[routesVector setObject:routeLength forKey:[NSNumber numberWithInt:city2Id]];
			
			routesVector = [allRoutes objectForKey:[NSNumber numberWithInt:city2Id]];

			if (nil == routesVector) {
				NSMutableDictionary *newRoutesVector = [[NSMutableDictionary alloc] init];
				[allRoutes setObject:newRoutesVector forKey:[NSNumber numberWithInt:city2Id]];
				[newRoutesVector release];
				routesVector = [allRoutes objectForKey:[NSNumber numberWithInt:city2Id]];
			}
			
			routeLength = [NSNumber numberWithInt:length];
			[routesVector setObject:routeLength forKey:[NSNumber numberWithInt:city1Id]];
		}
		
		sqlite3_finalize(statement);
	}
}

- (int)getDistance:(int)startCity endCity:(int)endCity {
	if (startCity == endCity) {
		return 0;
	}
	
	NSMutableDictionary *routesVector;
	
	routesVector = [allRoutes objectForKey:[NSNumber numberWithInt:startCity]];
					
	if (nil == routesVector) {
		return kInfinity;
	}
	
	NSNumber *distance = [routesVector objectForKey:[NSNumber numberWithInt:endCity]];
	
	if (nil == distance) {
		return kInfinity;
	}
	
	return [distance intValue];
}

- (NSMutableArray *)calculateRoute:(City *)startCity interCity1:(City *)interCity1 interCity2:(City *)interCity2 
                        interCity3:(City *)interCity3 interCity4:(City *)interCity4 endCity:(City *)endCity {
	NSMutableArray *fullRouteDetails = [[NSMutableArray alloc] init];;
    NSMutableArray *partRouteDetails;
    City *prevCity = startCity;
    
    if (interCity1) {
        partRouteDetails = [self calculateTwoCitiesRoute:prevCity endCity:interCity1];
        prevCity = interCity1;
        fullRouteDetails = [self mergeRoutes:fullRouteDetails secondRoute:partRouteDetails];
    }
    
    if (interCity2) {
        partRouteDetails = [self calculateTwoCitiesRoute:prevCity endCity:interCity2];
        prevCity = interCity2;
        fullRouteDetails = [self mergeRoutes:fullRouteDetails secondRoute:partRouteDetails];
    }

    if (interCity3) {
        partRouteDetails = [self calculateTwoCitiesRoute:prevCity endCity:interCity3];
        prevCity = interCity3;
        fullRouteDetails = [self mergeRoutes:fullRouteDetails secondRoute:partRouteDetails];
    }

    if (interCity4) {
        partRouteDetails = [self calculateTwoCitiesRoute:prevCity endCity:interCity4];
        prevCity = interCity4;
        fullRouteDetails = [self mergeRoutes:fullRouteDetails secondRoute:partRouteDetails];
    }

    partRouteDetails = [self calculateTwoCitiesRoute:prevCity endCity:endCity];
    fullRouteDetails = [self mergeRoutes:fullRouteDetails secondRoute:partRouteDetails];

	return fullRouteDetails;
}

- (NSMutableArray *)mergeRoutes:(NSMutableArray *)firstRoute secondRoute:(NSMutableArray *)secondRoute {
    NSMutableArray *result = [firstRoute mutableCopy];
    int deltaDistance = 0;
    
    if ([result count] > 0 && [secondRoute count] > 0) {
        int lastCityIndex = [result count] - 1;
        deltaDistance = [[result objectAtIndex:lastCityIndex] distance];
        [result removeObjectAtIndex:lastCityIndex];
    }
    
    for (id object in secondRoute) {
        [object setDistance:[object distance] + deltaDistance];
        [result addObject:object];
    }
    
    return [result autorelease];
}

- (NSMutableArray *)calculateTwoCitiesRoute:(City *)startCity endCity:(City *)endCity {
    int totalCities = [citiesIndex count];

	int startCityIndex, endCityIndex;
	
	startCityIndex = [citiesIndex indexOfObject:[NSNumber numberWithInt:startCity.identity]];
	endCityIndex = [citiesIndex indexOfObject:[NSNumber numberWithInt:endCity.identity]];
	
	int marks[totalCities];
    int distance[totalCities];
    int route[totalCities];
    int index;
	
	for (index = 0; index < totalCities; index++) {
        marks[index] = 0;
        route[index] = startCityIndex + 1;
        distance[index] = [self getDistance:startCity.identity endCity:[[citiesIndex objectAtIndex:index] intValue]];
    }

    marks[startCityIndex] = 1;
	int markedCities = 1;
    route[startCityIndex] = 0;
    int minDistance = kInfinity;
    int foundCityIndex;
	
	while (1) {
        for (index = 0; index < totalCities; index++) {
            if ((0 == marks[index]) && distance[index] < minDistance) {
                minDistance = distance[index];
                foundCityIndex = index;
            }
        }
		
        if (kInfinity == minDistance) {
            return nil;
        }
		
        if (foundCityIndex == endCityIndex) {
            break;
        }
		
        marks[foundCityIndex] = 1;
		markedCities++;
		
		int foundCity = [[citiesIndex objectAtIndex:foundCityIndex] intValue];
		NSMutableDictionary *routesVector = [allRoutes objectForKey:[NSNumber numberWithInt:foundCity]];
		
		if (nil != routesVector) {
			for (NSNumber *key in [routesVector allKeys]) {
				int nextCity = [key intValue];
				index = [[citiesIds objectForKey:[key stringValue]] intValue];
				int altDistance = distance[foundCityIndex] + [self getDistance:foundCity endCity:nextCity];
				if (altDistance < distance[index]) {
					distance[index] = altDistance;
					route[index] = foundCityIndex + 1;
				}
			}
		} else {
			NSLog(@"route vector not found.");
		}
        
        if (markedCities == totalCities) {
            break;
        }
		
        minDistance = kInfinity;
    }
	
	NSMutableArray *routeDetails = [[NSMutableArray alloc] init];
	int currentCityId;
	City *currentCity, *prevCity;
	
    index = route[endCityIndex];
	currentCityId = [[citiesIndex objectAtIndex:endCityIndex] intValue];
	currentCity = [self getCityByIdentity:currentCityId];
	[routeDetails insertObject:currentCity atIndex:0];
    //NSLog(@"City ID %d", currentCityId);
	prevCity = currentCity;
	
    while (index != 0) {
		currentCityId = [[citiesIndex objectAtIndex:(index-1)] intValue];
		currentCity = [self getCityByIdentity:currentCityId];
		
		Segment *segment = [self getSegment:prevCity endCity:currentCity];
		[routeDetails insertObject:segment atIndex:0];
		
		[routeDetails insertObject:currentCity atIndex:0];
        //NSLog(@"City ID %d", currentCityId);
        index = route[index-1];
		
		prevCity = currentCity;
    }
	
    int totalTime = 0;
    
	for (index = 1; index < [routeDetails count]; index++) {
        if ([[routeDetails objectAtIndex:index] isKindOfClass:[Segment class]]) {
            Segment *segment = [routeDetails objectAtIndex:index];
            totalTime += segment.time;
        }
        
		if (![[routeDetails objectAtIndex:index] isKindOfClass:[City class]]) {
			continue;
		}
        
		City *currentCity = [routeDetails objectAtIndex:index];
		City *prevCity = [routeDetails objectAtIndex:index-2];
		int citiesDistance = [self getDistance:prevCity.identity endCity:currentCity.identity];
		currentCity.distance = prevCity.distance + citiesDistance;
        currentCity.time = totalTime;
	}
	
	return [routeDetails autorelease];
}

- (City *)getCityByIdentity:(int)anIdentity {
	NSString *cityNameString, *latitudeString, *longitudeString;
	int population;
	NSString *query = @"SELECT name, population, latitude, longitude FROM cities WHERE id = ? LIMIT 1";
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		sqlite3_bind_int(statement, 1, anIdentity);
		
		if (sqlite3_step(statement) == SQLITE_ROW) {
			char *cityName = (char *)sqlite3_column_text(statement, 0);
			population = sqlite3_column_int(statement, 1);
            char *latitude = (char *)sqlite3_column_text(statement, 2);
            char *longitude = (char *)sqlite3_column_text(statement, 3);
			cityNameString = [[NSString alloc] initWithUTF8String:cityName];
            latitudeString = [[NSString alloc] initWithUTF8String:latitude];
            longitudeString = [[NSString alloc] initWithUTF8String:longitude];
		} else {
			NSAssert1(0, @"Cannot find city by identity %d", anIdentity);
		}
		
		sqlite3_finalize(statement);
	}
	
	City *city = [[City alloc] initWithNameAndIdentity:cityNameString identity:anIdentity];
	city.population = population;
    city.latitude = [latitudeString copy];
    city.longitude = [longitudeString copy];
	[cityNameString release];
    [latitudeString release];
    [longitudeString release];
	
	return [city autorelease];
}

- (Segment *)getSegment:(City *)aStartCity endCity:(City *)anEndCity {
	NSString *routeNameString;
	int distance, roadType;
	NSString *query = @"SELECT name, length, road_type FROM routes WHERE (city1 = ? AND city2 = ?) OR (city1 = ? AND city2 = ?) LIMIT 1";
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		sqlite3_bind_int(statement, 1, aStartCity.identity);
		sqlite3_bind_int(statement, 2, anEndCity.identity);
		sqlite3_bind_int(statement, 3, anEndCity.identity);
		sqlite3_bind_int(statement, 4, aStartCity.identity);
		
		if (sqlite3_step(statement) == SQLITE_ROW) {
			char *routeName = (char *)sqlite3_column_text(statement, 0);
			distance = sqlite3_column_int(statement, 1);
            roadType = sqlite3_column_int(statement, 2);
			routeNameString = [[NSString alloc] initWithUTF8String:routeName];
		} else {
			NSAssert2(0, @"Cannot find route from city %d to city %d", aStartCity.identity, anEndCity.identity);
		}
		
		sqlite3_finalize(statement);
	}
    
    int time = [self getRoadTime:distance roadType:roadType];
    time += [self getCityDelay:aStartCity.population];
	Segment *segment = [[Segment alloc] initWithNameAndDistance:routeNameString distance:distance time:time];
	[routeNameString release];
	
	return [segment autorelease];
}

- (int)getCityDelay:(int)aCitySize {
    if (1 == aCitySize) {
        return 5;
    } else if (2 == aCitySize) {
        return 10;
    } else if (3 == aCitySize) {
        return 15;
    } else if (4 == aCitySize) {
        return 30;
    } else if (5 == aCitySize) {
        return 60;
    } else if (6 == aCitySize) {
        return 90;
    } else {
        return 0;
    }
}

- (int)getRoadTime:(int)aDistance roadType:(int)aRoadType {
    int time;
    
    if (1 == aRoadType) {
        time = ((float)aDistance / 40 * 60);
    } else if (2 == aRoadType) {
        time = ((float)aDistance / 60 * 60);
    } else if (3 == aRoadType) {
        time = ((float)aDistance / 60 * 60);
    } else if (4 == aRoadType) {
        time = ((float)aDistance / 70 * 60);
    } else if (5 == aRoadType) {
        time = ((float)aDistance / 80 * 60);
    } else if (6 == aRoadType) {
        time = ((float)aDistance / 30 * 60);
    } else if (7 == aRoadType) {
        time = ((float)aDistance / 20 * 60);
    } else {
        time = ((float)aDistance / 60 * 60);
    }
    
    return time;
}

- (City *)getCityByLocation:(CLLocation *)location {
    City *foundCity;
    double latitude = location.coordinate.latitude;
    double longitude = location.coordinate.longitude;
    double cityOffset = 90;

    for (NSString *key in [allCities allKeys]) {
        NSMutableArray *section = [allCities objectForKey:key];
        for (City *city in section) {
            double deltaLatitude = fabs(latitude - city.latitude.doubleValue);
            double deltaLongitude = fabs(longitude - city.longitude.doubleValue);
            double distance = sqrt(pow(deltaLatitude, 2) + pow(deltaLongitude, 2));
            
            if ((6 == city.population) && (distance < 0.2)) {
                foundCity = city;
                goto breakLoop;
            } else if ((deltaLatitude + deltaLongitude) < cityOffset) {
                foundCity = city;
                cityOffset = deltaLatitude + deltaLongitude;
            }
        }
    }
    
breakLoop:;

    return foundCity;
}

- (NSMutableArray *)getRegionCodes {
    NSMutableArray *regionCodes = [[NSMutableArray alloc] init];
    NSMutableArray *regionCodeData;
    NSString *regionNameString;
    
    NSString *query = @"SELECT region_codes.code, regions.name FROM region_codes LEFT JOIN regions ON region_codes.region_id = regions.id ORDER BY region_codes.code";
    
    sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			int code = sqlite3_column_int(statement, 0);
			char *name = (char *)sqlite3_column_text(statement, 1);
			regionNameString = [[NSString alloc] initWithUTF8String:name];
            
            regionCodeData = [[NSMutableArray alloc] init];
            [regionCodeData addObject:[NSNumber numberWithInt:code]];
            [regionCodeData addObject:regionNameString];
            [regionCodes addObject:regionCodeData];
        }
        
        sqlite3_finalize(statement);
    }
    
    return [regionCodes autorelease];
}

- (NSMutableArray *)getRoutesInfo {
    NSMutableArray *routesInfo = [[NSMutableArray alloc] init];
    NSMutableArray *routeInfoData;
    NSString *numberString, *nameString, *descriptionString;
    
    NSString *query = @"SELECT number, name, description FROM routes_info ORDER BY number";
    
    sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *number = (char *)sqlite3_column_text(statement, 0);
            numberString = [[NSString alloc] initWithUTF8String:number];
            
            char *name = (char *)sqlite3_column_text(statement, 1);
            nameString = [[NSString alloc] initWithUTF8String:name];
            
            char *description = (char *)sqlite3_column_text(statement, 2);
            descriptionString = [[NSString alloc] initWithUTF8String:description];
            
            routeInfoData = [[NSMutableArray alloc] init];
            [routeInfoData addObject:numberString];
            [routeInfoData addObject:nameString];
            [routeInfoData addObject:descriptionString];
            [routesInfo addObject:routeInfoData];
        }
        
        sqlite3_finalize(statement);
    }
    
    return [routesInfo autorelease];
}

@end
