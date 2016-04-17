//
//  MXAnimation.m
//  MXLevelEdit
//
//  Created by Jared Bruni on 8/30/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//

#import "MXAnimation.h"


@implementation MXAnimation

@synthesize timerPause;
@synthesize position;
@synthesize frames;

- (id) init {
	if( (self = [super init]) == nil) return nil;
	frames = [[NSMutableArray alloc] init];
	isPlaying = NO;
	return self;
}

- (id) copyWithZone: (NSZone*)z {
	MXAnimation *m = [[MXAnimation allocWithZone:z] init];
	[m setFrames: [self frames]];
	[m setTimerPause: [self timerPause]];
	[m setPosition: [self position]];
	return m;
}

- (id) initWithCoder:(NSCoder *)coder {
	timerPause = [coder decodeFloatForKey:@"obj_pause"];
	frames = [[coder decodeObjectForKey:@"obj_frames"] retain];
	return self;
}

- (void) encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:frames forKey:@"obj_frames"];
	[coder encodeFloat:timerPause forKey:@"obj_pause"];	
}

- (void) dealloc {
	[frames release];
	[super dealloc];
}

- (void) addFrame: (MXSprite *)sprite {
	[frames addObject: sprite];
	
}
- (void) rewindAnimation {
	current_frame = 0;
	isPlaying = YES;
}

- (BOOL) nextFrame {
	current_frame++;
	if(current_frame > [frames count]) return (isPlaying = NO);
	return YES;
}

- (void) drawObject {
	if(isPlaying == NO) return;
	[self drawFrame: current_frame];
}

- (void) drawFrame: (int) index {
	if(index < 0 || index >= [frames count]) return;
	MXSprite *s = [frames objectAtIndex:index];
	if(s == nil) return;
	NSRect spriteRect;				
	spriteRect.origin.x = [s tilePoint].x;
	spriteRect.origin.y = [s tilePoint].y;
	spriteRect.size.width = [s tileSize].width;
	spriteRect.size.height = [s tileSize].height;
	NSRect pointRect;
	pointRect.origin.x = position.x;
	pointRect.origin.y = position.y;
	pointRect.size = spriteRect.size;	
	NSImage *img = [animationDict objectForKey: [s fileName]];
	[img drawInRect:pointRect fromRect:spriteRect operation:NSCompositeSourceOver fraction: 1.0f respectFlipped:YES hints:nil];
}

- (NSString *)description {
	return [NSString stringWithFormat: @" MXAnimation { frames: %d timer pause: %f }", (unsigned int)[frames count], timerPause];
}

@end
