#import<stdio.h>
#import<objc/Object.h>
#import"SDL.h"

@interface SDLapp : Object {

	SDL_Surface *front;
	SDL_Event e;
	int active;
}

- (id) init;
- (int) setwindow: (int)w H:(int)h Title:(char*)str;
- (int) loop;
- (void) render;
- (void) eventProc: (SDL_Event *)e;
- (void) clean;
@end


@implementation SDLapp;

- (id) init;
{

	if(! [super init ] )
		return nil;
		
	front = 0;
	active = 0;

	SDL_Init(SDL_INIT_VIDEO);
	return self;

}

- (void) clean 
{

	SDL_Quit();
	[ self free ];
	
}

- (int) setwindow: (int)w H:(int)h Title:(char*)str
{

	front = SDL_SetVideoMode(w,h,0,0);
	if(!front) {
		
		return 0;
	
	}
	
	SDL_WM_SetCaption(str, 0);
	active = 1;
	return active;
	
}

- (int) loop
{

	while(active == 1)
	{
	
		while(SDL_PollEvent(&e))
		{
		
			[ self eventProc: &e ];
	
		}
	

		[ self render ];
	
	}

	return EXIT_SUCCESS;

}

- (void ) render
{


	SDL_FillRect(front, 0, SDL_MapRGB(front->format, rand()%255, rand()%255, rand()%255));
	SDL_Flip(front);

}

- (void) eventProc: (SDL_Event*)ev
{

	switch(ev->type) {
	
	case SDL_QUIT:
		active = 0;
	break;
	
	}


}



@end



int main(int argc, char **argv)
{

	SDLapp *app = [ [ SDLapp alloc ] init ];
	
	if(app == nil) fprintf(stderr, "Error on init\n");
	
	[ app setwindow:640 H:480 Title: "Hello World" ];
	
	int rt_code = [ app loop ];
	
	[ app clean ];

	return rt_code;
}
