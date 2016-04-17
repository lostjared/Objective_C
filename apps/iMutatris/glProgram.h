//
//  glProgram.h
//  iMutatris
//
//  Created by Jared Bruni on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>


@interface glProgram : NSObject {
	int major,minor,sl_major,sl_minor;
	GLuint vert,frag,prog;
	NSMutableArray *sources;
}

- (void) getGLVersion;
- (void) beginSetupShaders;
- (void) endSetupShaders;
- (void) addSource: (GLuint)shader source: (NSString *)str;
- (BOOL) compile;
- (NSString *)loadSource: (NSString *)source;


@property (readwrite)  GLuint frag;
@property (readwrite)  GLuint vert;
@property (readwrite)  GLuint prog;

@end
