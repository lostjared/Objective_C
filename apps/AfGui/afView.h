//
//  afView.h
//  AfGui
//
//  Created by Jared Bruni on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface afView : NSView {

	NSImage *currentImage;
}

- (void) setImage: (NSImage*) i;

@end
