//
//  afView.m
//  AfGui
//
//  Created by Jared Bruni on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afView.h"


@implementation afView


- (id) init {
	[super init];
	currentImage = 0;
	return self;
}

- (void) dealloc {
	if(currentImage) [currentImage release];
	[super dealloc];
}

- (void) drawRect:(NSRect) r {

	if(currentImage) {
		NSRect imageRect;
		imageRect.origin = NSZeroPoint;
		imageRect.size = [currentImage size];
		NSRect dr;
		dr.origin.x = 150;
		dr.origin.y = 0;
		dr.size.width = 70;
		dr.size.height = 70;
		[currentImage drawInRect:dr fromRect:imageRect operation:NSCompositeSourceOver fraction: 1.0f];
		
	}
	
}


- (void) setImage: (NSImage*) i {
	[i retain];
	[currentImage release];
	currentImage = i;
	[self setNeedsDisplay: YES];
	
}

@end
