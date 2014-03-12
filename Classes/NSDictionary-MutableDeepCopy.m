//
//  NSDictionary-MutableDeepCopy.m
//  Sections
//

#import "NSDictionary-MutableDeepCopy.h"


@implementation NSDictionary (MutableDeepCopy)

- (NSMutableDictionary *)mutableDeepCopy {
	NSMutableDictionary *result = [[NSMutableDictionary alloc]
								initWithCapacity:[self count]];
								
	NSArray *keys = [self allKeys];
	NSMutableArray *array;
	
	for (id key in keys) {
		array = [(NSArray *)[self objectForKey:key] mutableCopy];
		[result setValue:array forKey:key];
		[array release];
	}
	
	return result;
}

@end
