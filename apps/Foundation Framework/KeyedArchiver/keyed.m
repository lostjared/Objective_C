/*
 
NSKeyedArchiver - demo using concepts
 
 - jared
 
*/

#import <Foundation/NSObject.h>
#import <Foundation/NSKeyedArchiver.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSString.h>
#import <Foundation/NSArray.h>


@interface db_Object : NSObject<NSCoding, NSCopying> {
	
	NSString *user;
	NSString *number;
}

-  (void) setData: (NSString*) user number: (NSString*) num;
-  (void) dealloc;
-  (NSString*) userID;
-  (NSString*) numbID;
-  (db_Object*) copyWithZone: (NSZone*)zone;

@end

@implementation db_Object

- (db_Object*) copyWithZone: (NSZone*) zone {
	
	db_Object *ndb = [ [ db_Object allocWithZone: zone ] init ];
	[ ndb setData: [ self userID ]   number: [ self   numbID ] ];
	return  ndb;
}

- (void) encodeWithCoder: (NSCoder*) encoder {
	
	[ encoder encodeObject: user forKey: @"db_User" ];
	[ encoder encodeObject: number forKey: @"db_Number" ];
}

- (id) initWithCoder: (NSCoder*) decoder {
	
	user = [ [ decoder decodeObjectForKey:  @"db_User" ] retain ];
	number = [ [ decoder decodeObjectForKey: @"db_Number" ] retain ];
	return self;
}


- (void) setData: (NSString*) user_id number: (NSString*) num {
	
	[ user release ];
	[ number release ];
	
	user = [  NSString stringWithString: user_id ];
	number = [  NSString stringWithString: num ];
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

@interface num_Object : NSObject<NSCoding, NSCopying> {
	NSMutableArray *collection;	
}

@property(copy,nonatomic) NSMutableArray  *collection;

- (id) initDB;
- (void) addNumber: (NSString*) user_id phone: (NSString*) number;
- (void) print;
- (void) printByName: (NSString*) user_Name;
- (void) dealloc;
- (num_Object*) copyWithZone:(NSZone*) zone;

@end


@implementation num_Object

@synthesize collection;


- (num_Object*) copyWithZone:(NSZone*)zone {

	num_Object *z = [ [ num_Object allocWithZone: zone ] init ];
	z.collection = [ self copy ];
	return z;
}

- (void) encodeWithCoder: (NSCoder*) encoder {
	[ encoder encodeObject: collection forKey: @"Collection" ];
}

- (id) initWithCoder: (NSCoder*)decoder {
	collection = [ [ decoder decodeObjectForKey: @"Collection" ] retain ];
	return self;
}

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
	
	[ NSKeyedArchiver archiveRootObject: num toFile: @"numbook.dat"];
	
	num_Object *num2 = [ NSKeyedUnarchiver unarchiveObjectWithFile: @"numbook.dat" ];
	
	[ num2 print ];
	
	[ num release ];
	[pool drain];
    return 0;
}

