//
//  glView.m
//  iMutatris
//
//  Created by Jared Bruni on 4/24/11.
//

#import "glView.h"
#import<OpenGL/glu.h>
#include<GLUT/glut.h>


GLfloat vertices[] = { -1.0f, -1.0f, 1.0f, // front face
	1.0f, 1.0f, 1.0f,
	-1.0f, 1.0f, 1.0f,
	
	-1.0f, -1.0f, 1.0f,
	1.0f, -1.0f, 1.0f,
	1.0f, 1.0f, 1.0f,
	
	-1.0f, -1.0f, -1.0f, // left side
	-1.0f, -1.0f, 1.0f,
	-1.0f, 1.0f, -1.0f,
	
	-1.0f, 1.0f, -1.0f,
	-1.0f, -1.0f, 1.0f,
	-1.0f, 1.0f, 1.0f,
	
	-1.0f, 1.0f, -1.0f, // top
	-1.0f, 1.0f, 1.0f,
	1.0f, 1.0f, 1.0f,
	
	1.0f, 1.0f, 1.0f,
	1.0f, 1.0f, -1.0f,
	-1.0f, 1.0f, -1.0f,
	
	-1.0f, -1.0f, -1.0f, // bottom
	-1.0f, -1.0f, 1.0f,
	1.0f, -1.0f, 1.0f,
	
	1.0f, -1.0f, 1.0f,
	1.0f, -1.0f, -1.0f,
	-1.0f, -1.0f, -1.0f,
	
	1.0f, -1.0f, -1.0f, // right
	1.0f, -1.0f, 1.0f,
	1.0f, 1.0f, -1.0f,
	
	1.0f, 1.0f, -1.0f,
	1.0f, -1.0f, 1.0f,
	1.0f, 1.0f, 1.0f,
	
	-1.0f, -1.0f, -1.0f, // back face
	1.0f, 1.0f, -1.0f,
	-1.0f, 1.0f, -1.0f,
	
	-1.0f, -1.0f, -1.0f,
	1.0f, -1.0f, -1.0f,
	1.0f, 1.0f, -1.0f,
	
};



@implementation glView


- (void)awakeFromNib {
	[self setNeedsDisplay: YES];
}

- (void) dealloc {
	[program release];
	[super dealloc];
}

- (void) prepare {
	NSOpenGLContext *con = [self openGLContext];
	[con makeCurrentContext];
	const unsigned char *version = glGetString(GL_VERSION);
	NSLog(@"GL version: %s\n", version);
	NSRect scr = [self convertRectToBase: [self bounds]];
	glClearColor(0, 0, 0, 0);
	glClearDepth(1.0f);
	glShadeModel(GL_SMOOTH);
	glEnable(GL_DEPTH_TEST);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective(45.0f, (scr.size.width/scr.size.height), 0.1f, 100.0f);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);	
	program_timer = [NSTimer scheduledTimerWithTimeInterval: 0 target: self selector: @selector(updateTimer:) userInfo: nil repeats: YES];
	program = [[glProgram alloc] init];
	[program getGLVersion];
	[program beginSetupShaders];
	
	NSString *frag_path = [[NSBundle mainBundle] pathForResource:@"fragment.frag" ofType:@""];
	NSString *vert_path = [[NSBundle mainBundle] pathForResource:@"vertex.vert" ofType:@""];
	NSString *vstr = [program loadSource:vert_path];
	NSString *fstr = [program loadSource:frag_path];
	
	if(vstr == nil) {
		NSLog(@"Error could load vertex code");
		return;
	}
	
	if(fstr == nil) {
		NSLog(@"Error could not load Fragment code");
		return;
	}
	[program addSource: [program vert] source:vstr];
	[program addSource: [program frag] source:fstr];

	glPointSize(1.0f);

	if([program compile] == YES) {
		[program endSetupShaders];
	}
}

- (void) updateTimer: (NSTimer *)timer {
	[self setNeedsDisplay: YES];
}

- (BOOL) acceptsFirstResponder { 
	return YES; 
}
- (void) keyDown:(NSEvent *)event {
	if([event modifierFlags] & NSNumericPadKeyMask) {
		NSString *keys = [event charactersIgnoringModifiers];
		unichar keyChar = 0;
		if([keys length] == 0) return;
		if([keys length] != 1) return;
		
		keyChar = [keys characterAtIndex:0];
		switch(keyChar) {
			case NSLeftArrowFunctionKey:
				break;
			case NSRightArrowFunctionKey:
				break;
			case NSUpArrowFunctionKey:
				break;
			case NSDownArrowFunctionKey:
				break;
		}
	}
}			 
- (void) reshape {
	NSRect baseRect = [self convertRectToBase: [self bounds]];
	glViewport(0, 0, baseRect.size.width, baseRect.size.height);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective(45.0f, (baseRect.size.width/baseRect.size.height), 0.1f, 100);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
}

- (void) drawRect:(NSRect) r {
	glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glLoadIdentity();
	static float Rotation = 1.0f;
	glTranslatef(0, 0, -10);
	glRotatef(Rotation, 1, 1, 1);
	Rotation += 5.0f;
	glColor3f(1.0f, 0.0f, 0.0f);
	GLfloat modelviewMatrix[16];
	GLfloat projectionMatrix[16];
	glGetFloatv(GL_MODELVIEW_MATRIX, modelviewMatrix);
	glGetFloatv(GL_PROJECTION_MATRIX, projectionMatrix);
	glUniformMatrix4fv(glGetUniformLocation([program prog], "modelview_matrix"), 1, GL_FALSE, modelviewMatrix);
	glUniformMatrix4fv(glGetUniformLocation([program prog], "projection_matrix"),1, GL_FALSE,projectionMatrix);
	glEnableClientState(GL_VERTEX_ARRAY);
	glVertexPointer(3, GL_FLOAT, 0, vertices);
	glVertexAttribPointer((GLint)glGetAttribLocation([program prog], "a_Vertex"), 3, GL_FLOAT, GL_FALSE, 0, vertices);
	glEnableVertexAttribArray(0);
	glDrawArrays(GL_TRIANGLES, 0, 36);
	glDisableVertexAttribArray(0);
	glDisableClientState(GL_VERTEX_ARRAY);
	[[self openGLContext] flushBuffer];
}

- (id) initWithCoder:(NSCoder *)c {
	self = [super initWithCoder:c];
	[self prepare];
	return self;
}

@end
