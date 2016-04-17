//
//  glView.h
//  iMutatris
//
//  Created by Jared Bruni on 4/24/11.
//

#import <Cocoa/Cocoa.h>
#import "glProgram.h"

@interface glView : NSOpenGLView {
	NSTimer *program_timer;
	glProgram *program;
}


@end
