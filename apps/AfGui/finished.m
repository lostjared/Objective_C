//
//  finsihed.m
//  AfGui
//
//  Created by Jared Bruni on 7/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "finished.h"


@implementation finished



@end

@implementation finished_view 


- (id) init {
	[super init];
	image = nil;
	return self;
}

- (void) dealloc {
	if(image) [image release];
	[super dealloc];
}

- (void) setImage: (NSImage*) i {
	if(i) [i retain];
	if(image) [image release];
	image = i;
}

- (void) drawRect: (NSRect) r {
	if(image) {
		NSRect imageRect;
		imageRect.origin = NSZeroPoint;
		imageRect.size = [image size];
		NSRect dr;
		dr.origin.x = 50;
		dr.origin.y = 70;
		dr.size.width = 280;
		dr.size.height = 250;
		[image drawInRect:dr fromRect:imageRect operation:NSCompositeSourceOver fraction: 1.0f];
	}
}

@end

@implementation finished_controller 

- (finished_view*) viewObject {
	return fin_view;
}


- (IBAction) openImageFile: (id) sender {
	NSString *str = [NSString stringWithFormat: @"open %@", path];
	system([str UTF8String]);
	
}

- (IBAction) dismiss: (id) sender {
	[NSApp endSheet: win];
	[win orderOut: sender];
}

- (void) setImagePath: (NSString *) str {
	path = [str retain];
}

@end