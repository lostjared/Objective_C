/*
 
 nested AutoreleasePool's , just playing around with the concepts...
 - jared
 
*/

#import <Foundation/Foundation.h>

int main (int argc, const char * argv[]) {
    
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSMutableArray *array = [NSMutableArray array];
	
	while(1) {
	
		NSAutoreleasePool *temp = [[NSAutoreleasePool alloc] init];
		printf("Enter Name: ");
		char data[255];
		fgets(data, 255, stdin);
		NSString *str = [ NSString stringWithUTF8String:data ];
		[ array addObject: str ];
		if([ str compare: @"quit\n"] == NSOrderedSame) break;
		[temp drain];
	}
	
	for(NSString *local in array) 
		NSLog(@"%@", local);
	
	
	[pool drain];
    return 0;
}
