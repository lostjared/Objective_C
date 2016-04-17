//
//  MXSpriteView.m
//  MXLevelEdit
//
//  Created by Jared Bruni on 8/25/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//

#import "MXSpriteView.h"


@implementation MXSpriteView

@synthesize spriteImage;
@synthesize spriteString;
@synthesize spriteWidth;
@synthesize spriteHeight;

- (BOOL) isFlipped { return NO; } // even though the coordinates of the drawing operation to the view is flipped, the coordinates inside the image are not for some reason

- (void) awakeFromNib {
	[self setSpriteImage: nil];
	imagePoint = NSZeroPoint;
}

- (void) drawRect:(NSRect) rect {
	NSRect bound = [self bounds];
	[[NSColor blackColor] set];
	[NSBezierPath fillRect: bound];
	if(spriteImage != nil) {
		NSRect imageRect;
		imageRect.origin = NSZeroPoint;
		imageRect.size = [spriteImage size];
		NSRect dr;
		dr.origin.x = 0, dr.origin.y = 0;
		dr.size = [spriteImage size];
		[spriteImage drawInRect:dr fromRect:imageRect operation:NSCompositeSourceOver fraction: 1.0f ];// respectFlipped: YES hints: nil];
		NSRect rect;
		rect.origin = imagePoint;
		rect.size.width = spriteWidth;
		rect.size.height = spriteHeight;		
		[[NSColor redColor] set];
		NSBezierPath *path = [NSBezierPath bezierPath];
		[path appendBezierPathWithRect:rect];
		[path setLineWidth: 2.5];
		[path stroke];
		[tx setIntegerValue: (int) imagePoint.x];
		[ty setIntegerValue: (int) imagePoint.y];
	}
}

- (void) mouseDown:(NSEvent *)e {
	[self mouseDragged:e];
}

- (void) mouseDragged:(NSEvent *)e {
	NSPoint p = [self convertPoint: [e locationInWindow] fromView:nil];
	if(p.x >= 0 && p.y >= 0 && p.x < [spriteImage size].width-spriteHeight && p.y < [spriteImage size].height-spriteHeight) {
		imagePoint = p;
		[self setNeedsDisplay:YES];
		[addKey setEnabled: YES];
		
	}
}

- (IBAction) textChangedX: (id) sender {
	int x = (int)[tx integerValue];
	int y = (int)[ty integerValue];
	if(x >= 0 && x < [spriteImage size].width && y >= 0 && y < [spriteImage size].height) {
		imagePoint.x = (float)x;
		imagePoint.y = (float)y;
		spriteWidth = (int)[tw integerValue];
		spriteHeight = (int)[tw integerValue];
		[self setNeedsDisplay:YES];
	}
}

- (MXTilePoint) tilePoint {
	MXTilePoint p = { (int)imagePoint.x, (int)imagePoint.y };
	return p;
}

- (void) setImagePoint:(NSPoint)p {
	imagePoint = p;
}


@end

