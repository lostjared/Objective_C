/* Objective-C++ source module 

	goal: concept divide application into series of screens encapsulated into a single class
	
	press the up and down arrows to change the instance of the screen object.
	using dynamic binding, the screen exisiting within the window object, can
	be changed by using the member function call setScreen.
	
	
*/

#import<mx.h>
#import<objc/Object.h>

@protocol screen 
- (void) setup;
- (void) render;
- (void) app_free;
- (void) app_init: (mx::mxSurface*)surf;
- (void) event: (SDL_Event*)e;
@end


@interface appScreen : Object<screen> {

@protected
	mx::mxSurface *front;
	
	
}

- (void) app_init:(mx::mxSurface*) surf;
- (void) app_free;
- (void) event: (SDL_Event*)e;
- (void) setup;
- (void) render;

@end


@implementation appScreen;

- (void) app_init: (mx::mxSurface*) surf {

	front = surf;
	[ self setup ];
	
}

- (void) setup {


}

- (void) app_free {

	[ self free ];
	
}

- (void) event: (SDL_Event*) e {


}

- (void) render {

	SDL_FillRect(*front, 0, mx::Color::mapRGB(*front, rand()%255, rand()%255, rand()%255));
	front->Flip();
}


@end


@interface start : appScreen<screen> {

@protected
	mx::Color *color;

}

- (void) app_free;
- (void) setColor: (mx::Color*) col;
- (void) setup;
- (void) render;

@end


@implementation start;

- (void) setup {

	color = new mx::Color(255,255,255);
	
}

- (void) setColor: (mx::Color*) col {

	if(color) delete color;
	color = col;
}

- (void) render {

	SDL_FillRect(*front, 0, mx::Color::mapRGB(*front, *color));
	front->Flip();

}

- (void) app_free {

	delete color;
	[ super app_free ];
}

@end

@interface game : start;

- (void) setup;

@end

@implementation game;

- (void) setup {
	
	color = new mx::Color(0,0,0);

}

@end


class mxWindow : public mx::mxWnd  {


public:

	mxWindow(id<screen> obj) : mxWnd(1024,768,0)
	{
	
		prog = obj;
		[ prog app_init: &front ];
	
	}
	
	~mxWindow() { [ prog app_free ]; }
	
	virtual void eventPassed(SDL_Event &e)
	{
			switch(e.type) {
			case SDL_QUIT: quit(); break;
			case SDL_KEYDOWN: if(e.key.keysym.sym == SDLK_ESCAPE) quit(); 
			
			if(e.key.keysym.sym == SDLK_DOWN) {
			
				game *g = [ [ game alloc ] init ];
				setScreen(g);
			}
			else if(e.key.keysym.sym == SDLK_UP)
			{
				start *s = [ [ start alloc ] init ];
				setScreen(s);
			}
			
			break;
			}
			[ prog event: &e ];
	}
	
	
	virtual void renderScreen() {
		
		[ prog render ];
		
	}
	
	void setScreen(id obj) {
	
		[ prog app_free ];
		prog = obj;
		[ prog app_init: &front ];
	}


protected:
	id<screen> prog;

};




int main(int argc, char **argv)
{
	try {
	
		start *s = [ [ start alloc ] init ];
		mxWindow mxwindow(s);
		return mxwindow.messageLoop();
	}
	
	catch ( mx::mxException<std::string> &e ) {
	
		e.printError(std::cerr);
	} 
	catch ( std::exception &ext )
	{
		std::cerr << ext.what() << "\n";
	}
	catch(...)
	{
		std::cerr << "unknown exception\n";
	}
	
	return EXIT_FAILURE;
}