//
//  glProgram.m
//  iMutatris
//
//  Created by Jared Bruni on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "glProgram.h"


@implementation glProgram

@synthesize vert;
@synthesize frag;
@synthesize prog;


- (NSString *)loadSource: (NSString *)source {
	FILE *fptr = fopen([source UTF8String], "rb");
	if(!fptr) return nil;
	fseek(fptr, 0, SEEK_END);
	unsigned int len = ftell(fptr);
	rewind(fptr);
	if(len == 0) return nil;
	char *buf = (char*)malloc(len+1);
	fread(buf, 1, len, fptr);	
	fclose(fptr);
	buf[len] = 0;
	NSString *str = [NSString stringWithUTF8String:buf];
	free(buf);
	return str;
}

- (void) getGLVersion {

	const char *str = (const char*)glGetString(GL_VERSION);
	major = minor = 0;
	sscanf(str, "%d.%d", &major, &minor);
	NSLog(@"OpenGL Version: %d.%d", major, minor);
	if(major >= 2) {
		const char *glSL_version = (const char*) glGetString(GL_SHADING_LANGUAGE_VERSION);
		sscanf(glSL_version, "%d.%d", &sl_major, &sl_minor);
		NSLog(@"GLSL Version: %d.%d", sl_major, sl_minor);
	} else {
		NSRunAlertPanel(@"Error", @"OpenGL Version too lod", @"Ok", nil, nil);
	}
}

- (void) beginSetupShaders {
	vert = glCreateShader(GL_VERTEX_SHADER);
	frag = glCreateShader(GL_FRAGMENT_SHADER);
	prog = glCreateProgram();	
}

- (BOOL) compile {

	int len = 0;
	glCompileShader(vert);
	GLint result;
	glGetShaderiv(vert, GL_COMPILE_STATUS, &result);
	if(result == GL_TRUE) {
		glAttachShader(prog, vert);
	} else {
		GLchar *str = (GLchar*)malloc(5096);
		glGetShaderInfoLog(vert, 5096, &len, str);
		printf("vertex shader: %s\n", str);
		free(str);
		exit(0); // abort
	}
	glCompileShader(frag);
	glGetShaderiv(frag, GL_COMPILE_STATUS, &result);
	if(result == GL_TRUE)
		glAttachShader(prog, frag);
	else {
		GLchar *str = (GLchar*)malloc(5096);
		glGetShaderInfoLog(frag, 5096, &len, str);
		printf("fragment: %s\n", str);
		free(str);
		exit(0); // abort
	}
	
	glBindAttribLocation(prog, 0, "a_Vertex");
	glLinkProgram(prog);
	glGetProgramiv(prog, GL_LINK_STATUS,&result);
	if(result == GL_TRUE) {
		return YES;
	}
	GLchar *str = (GLchar*)malloc(5096);
	glGetProgramInfoLog(prog, 5096, &len, str);
	printf("Program %s\n", str);
	return NO;
}

- (void) endSetupShaders {
	glUseProgram(prog);
}

- (void) addSource: (GLuint)shader source:(NSString *)str {
	const char *s = [str UTF8String];
	glShaderSource(shader, 1, &s, NULL);
}


@end
