#import<mx.h>
#import<iostream>
#import<objc/Object.h>

class window : public mx::mxWnd {

public:

	window() : mxWnd(640,480,0) {
	
	
	}
	
	virtual void eventPassed(SDL_Event &e)
	{
	
			switch(e.type) {
			case SDL_QUIT:
			quit();
			break;
			case SDL_KEYDOWN: if(e.key.keysym.sym == SDLK_ESCAPE) quit();
			break;
			}
	}
	
	virtual void renderScreen()
	{

		SDL_FillRect(front, 0, mx::Color::mapRGB(front, rand()%255, rand()%255, rand()%255));
		front.Flip();
		
	}


};


@interface Wrapper : Object {

	window *win;

}

- (id) init_window: (char*)title;
- (int) loop;
- (void) clean;

@end


@implementation Wrapper;


- (id) init_window: (const char*)title {

	win = new window();
	win->setTitle(title);
	return self;

}

- (int) loop {

	return win->messageLoop();

}

- (void) clean {


	delete win;
	[ self free ];

}

@end



int main(int argc, char **argv) {

	Wrapper *wrap = [ [ [ Wrapper alloc ] init ] init_window: "Hello World in Objective-C++ "];

	int rt_code = [ wrap loop ];
	
	[ wrap clean ];

	return rt_code;
}


