#import<stdio.h>
#import<stdlib.h>
#import<objc/Object.h>

@interface numeric : Object {
	
	int number;

}

- (int) number;

- (void) print;
- (void) setNumber: (int) num;

@end

@implementation numeric;

- (int) number 
{ return number; }
- (void) print 
{ printf("%d", number); }
- (void) setNumber: (int) num
{
	number = num;
}

@end


@interface hexnumeric : Object {
	
	int number;

}

- (int) number;

- (void) print;
- (void) setNumber: (int) num;

@end

@implementation hexnumeric;

- (int) number 
{ return number; }
- (void) print 
{ printf("%#X", number); }
- (void) setNumber: (int) num
{
	number = num;
}

@end


int main(int argc, char **argv) {


	numeric *num1 = [ [ numeric alloc ] init ];
	hexnumeric *num2 = [ [ hexnumeric alloc ] init ];
	
	id value;
	value = num1;
	
	printf(" base 10: ");
	
	[ value setNumber: 25 ];
	[ value print ];
	
	value = num2;
	
	printf("\n base 16: ");
	
	[ value setNumber: 255 ];
	[ value print ];
	
	printf("\n");
	
	[ num1 free ];
	[ num2 free ];
	
	return 0;
}

