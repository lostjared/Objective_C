/* Random Pixels Demo in Objective-C
	done to play around with Objective-C
	-Jared Bruni
*/




#import<objc/Object.h>
#import<SDL.h>



@interface Pixels : Object {
@public
	unsigned char *buffer;
	SDL_Surface *surface;
}

- (void) render;

@end


@implementation Pixels

- (void) render {
	unsigned int i,z;
	
	SDL_LockSurface(surface);
	
	
	buffer = (unsigned char*)  surface->pixels;
	int bpp = surface->format->BytesPerPixel;
	

	while( i++ < (surface->w*surface->h)*4) {
		*buffer = rand()%0xff;
		buffer++;
	}
	
	SDL_UnlockSurface(surface);
	SDL_Flip(surface);
	
}

@end



@interface App : Object {
@public
	SDL_Surface *render;
	id render_object;
	SEL render_function;
}

- (id) initSDL;
- (void) release;
- (void) update;
- (void) setRenderObject: (id) obj sel:(SEL)select;

@end


@implementation  App;


- (id) initSDL {

	
	SDL_Init(SDL_INIT_VIDEO);
	
	render = SDL_SetVideoMode(640,480,0,0);
	if(!render) {
	
		fprintf(stderr, "Error %s", SDL_GetError());
		return nil;
	}
}

-  (void) release {
	
	SDL_Quit();
	
}

- (void) update {

	static SDL_Event e;
	BOOL active = YES;
	
	while(active == YES) {
		
		while(SDL_PollEvent(&e)) {
		
			switch(e.type) {
				case SDL_QUIT:
					active = NO;
					break;
			}
			
			
		}
		// render
		[ render_object perform: render_function ];
	}
}

- (void) setRenderObject: (id) obj sel:(SEL)select {

	render_object = obj;
	render_function =  select;
	
}

@end


int main(int argc, char **argv) {

	Pixels *pix = [ [ Pixels alloc ] init ];
	
	App *app = [ [ App alloc ] init ];
	
	[ app setRenderObject: pix  sel:@selector(render) ];
	
	[ app initSDL ];
	
	pix->surface = app->render;
	
	[ app update ];

	[ app release ];
	
	[ app free ];

	[ pix free ];
	
	return 0;
}
