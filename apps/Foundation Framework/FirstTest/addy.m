#import<Foundation/Foundation.h>
#import<stdlib.h>


@interface AddyEntry : NSObject {

	NSString *user_name, *home_page, *email_addy;
	
}

- (void) setEntry: (NSString*) name Page: (NSString*) page Email: (NSString*) email;
- (NSString*) name;
- (NSString*) url;
- (NSString*) email;
- (void) print;
- (void) dealloc;


@end


@implementation AddyEntry;

- (void) setEntry: (NSString*) name Page: (NSString*) page Email: (NSString*) email {

	user_name = [ [ NSString alloc ] initWithString: name ];
	home_page = [ [ NSString alloc ] initWithString: page ];
	email_addy = [ [ NSString alloc ] initWithString: email ];
}


- (NSString*) name { return user_name; }
- (NSString*) url  { return home_page; }
- (NSString*) email { return email_addy; }

- (void) dealloc {

	printf(" releasing address entry\n");

	[ user_name release ];
	[ home_page release ];
	[ email_addy release ];
	[ super dealloc ];
}

- (void) print {

	printf("\nUser Name: %s\n Home Page: %s\n Email: %s\n", [ user_name UTF8String ], [ home_page UTF8String ], [ email_addy UTF8String ]);
		
}

@end

@interface Book : NSObject {

	NSMutableArray *addyz;
}

- (id) init;
- (void) dealloc;
- (void) addEntry: (AddyEntry*) e;
- (void) print;


@end

@implementation Book; 

- (id) init {

 
	self = [ super init ];
	
	if (!self) return nil;
	
	addyz = [ [NSMutableArray alloc] init ];
	return self;

}

- (void) dealloc {

	
	register int i;
	int count = [ addyz count ];
	
	[ addyz release ];
	[ super dealloc ];
}

- (void) addEntry: (AddyEntry*) e {

	[ e autorelease ];
	[ addyz addObject: e ];

}

- (void) print {

	int counter;
	register int i;
	
	
	AddyEntry *e;
	counter = [ addyz count ];
	
	for(i = 0; i < counter; i++) {
		e = [ addyz objectAtIndex: i ];
		[ e print ];
	}

}

@end

static void program_loop(Book *b);

int main(int argc, const char *argv[]) {

	NSAutoreleasePool *the_pool = [ [ NSAutoreleasePool alloc ] init ];
	
	Book *book = [ [ Book alloc ] init ];
	
	program_loop(book);

	[ book release ];

	[ the_pool release ];

	return EXIT_SUCCESS;
}


static void program_loop(Book *b) {


	printf("Enter choice: 1 to add, 2 to print, 3 to quit\n");
	char choice[25];
	scanf("%s", &choice);
		
	if(choice[0] == '3') return;

	if(choice[0] == '2')  [ b print ];
	if(choice[0] == '1') {
	
	
		printf("Enter name, url, and email: ");
		char user_name[100], url[100], email[100];
		scanf("%s %s %s", user_name, url, email);
	
		AddyEntry *e = [ [ AddyEntry alloc ] init ];
		
		NSString *un = [ NSString stringWithCString: user_name ];
		NSString *ur = [ NSString stringWithCString: url ];
		NSString *em = [ NSString stringWithCString: email ];
		
		
		[ e setEntry: un Page: ur Email: em ];
		[ b addEntry: e ];
	}

	program_loop(b);

}