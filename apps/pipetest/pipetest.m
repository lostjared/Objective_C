
#import<sys/types.h>
#import<unistd.h>
#import<stdio.h>
#import<stdlib.H>
#import<objc/Object.h>


@interface Pipe : Object {

	int p[2];
}


- (void) createPipe;
- (void) close: (int) index;
- (int) duplicate: (int) index fd: (int) pos;

@end



@implementation Pipe;


- (void) createPipe {
	pipe(p);
}

- (void) close: (int) index {
	close ( p[index] );
}

- (int)  duplicate: (int) index fd: (int) pos
{
	return dup2(p[index], pos);
}

- (int) atIndex: (int) pos {
	return p[ pos ];
}

@end

int main(int argc, char **argv) {


	Pipe *p = [ [ Pipe alloc ] init ];
	
	
	printf("pipe test\n");
	
	[ p createPipe ];
	
	
	if( fork() ) {
	
		[ p duplicate: 0 fd: STDIN_FILENO ];
		[ p close: 1 ];
		
	}
	else {
	
		[ p duplicate: 1 fd: STDOUT_FILENO ];
		[ p close: 0 ];
		
		execl("/bin/bash", "");
		_exit(0);
		
	}
	
	FILE *fptr = fdopen([ p atIndex: 0 ], "r");
	char buffer[1024];
	
	
	while( !feof(fptr) ) {
	
		fgets(buffer, 1024, fptr);
		printf("%s", buffer);
		fflush(fptr);
		
	}

	[ p free ];
	
	fclose(fptr);

	return 0;
}
