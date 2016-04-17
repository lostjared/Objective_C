/*
 
 Demo , just playing around with the concepts...
 - jared
 
*/

#import <Foundation/Foundation.h>

@interface db_Object : NSObject {
	
	NSString *user;
	NSString *number;
}

-  (void) setData: (NSString*) user number: (NSString*) num;
-  (void) dealloc;
-  (NSString*) userID;
-  (NSString*) numbID;

@end

@implementation db_Object

- (void) setData: (NSString*) user_id number: (NSString*) num {
	
	[ user release ];
	[ number release ];

	user = [ [ NSString alloc ] initWithString: user_id ];
	number = [ [ NSString alloc ] initWithString: num ];
}

- (NSString*) userID {
	return user;
}

- (NSString*) numbID {
	return number;
}

- (void) dealloc {
	
	[ user release ];
	[ number release ];
	[ super dealloc ];
}

@end

@interface num_Object : NSObject {
	NSMutableArray *collection;	
}
- (id) initDB;
- (void) addNumber: (NSString*) user_id phone: (NSString*) number;
- (void) print;
- (void) printByName: (NSString*) user_Name;
- (void) dealloc;

@end


@implementation num_Object


- (id) initDB {

	collection = [ [ NSMutableArray alloc ]  initWithCapacity: 5  ];
	[ super init ];
	return self;
}

- (void) addNumber: (NSString*) user_id phone: (NSString*) number {

	db_Object *db = [[ db_Object alloc ] init ];
	[ db setData: user_id number: number ];
	[ collection addObject: db ];
}

- (void) print {
	int i;
	for( i = 0; i < [ collection count ]; ++i ) 
		NSLog (@"%@ : %@", [ [ collection objectAtIndex: i ] userID ], [ [ collection objectAtIndex: i ] numbID ]);
}

- (void) printByName: (NSString*) user_Name {
	int i;
	for(i = 0; i < [ collection count]; i++ ) {
	
		if ([ [ [ collection objectAtIndex: i ] userID] compare: user_Name ] == NSOrderedSame) {
			NSLog (@"%@ : %@", [ [ collection objectAtIndex: i ] userID ], [ [ collection objectAtIndex: i ] numbID ]);
			return;
		}
	}
}

- (void) dealloc {
	for(db_Object *db  in collection) {
		[ db  release ];		
	}
	[ collection release ];
	[ super dealloc ];
}



@end

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	num_Object *num = [ [ num_Object alloc ] initDB ];
	[ num addNumber: @"Jared" phone: @"555-5555" ];
	[ num addNumber: @"My Girl." phone: @"555-5555" ];
	[ num print ];
	[ num printByName: @"Jared" ];
	[ num release ];
	[pool drain];
    return 0;
}
