//
//  MXLevel.m
//  MXLevelEdit
//
//  Created by Jared Bruni on 9/5/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//

#import "MXLevel.h"


@implementation MXLevel


- (id) init {

	if ((self = [super init]) == nil) return nil;
	[self createLevel];	
	return self;
}

- (void) dealloc {
	[self releaseLevel];
	[super dealloc];
}

- (void) releaseLevel {
	[spriteDict release];
	[imageDict release];
	[animationDict release];
	[animationFrames release];
	[animations release];
	[generalSprites release];
	[entityKeys release];
}

- (void) createLevel {
	imageDict = [[NSMutableDictionary alloc] init];
	spriteDict = [[NSMutableDictionary alloc] init];
	animationDict = [[NSMutableDictionary alloc] init];
	animationFrames = [[NSMutableDictionary alloc] init];
	animations = [[NSMutableDictionary alloc] init];		
	generalSprites = [[NSMutableDictionary alloc] init];
	entityKeys = [[NSMutableDictionary alloc] init];
}

/* code for reading a level, seperate from the grid, this will be used in runtime */
- (void) readLevel: (NSString *)filename {	
	NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:filename];
	if(file == nil) {
		NSLog(@"readLevel: Error file not found.");
		return;
	}
	NSData *data = [file readDataToEndOfFile];	
	NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData: data];
	spriteDict = [[arch decodeObjectForKey:@"sprites"] retain];
	imageDict = [[arch decodeObjectForKey:@"images"] retain];
	level_map = [[arch decodeObjectForKey:@"level_map"] retain];
	level_title = [[arch decodeObjectForKey:@"title"] retain];
	animationDict = [[arch decodeObjectForKey:@"anid"] retain];
	animationFrames = [[arch decodeObjectForKey:@"frames"] retain];
	animations = [[arch decodeObjectForKey:@"animations"] retain];
	generalSprites = [[arch decodeObjectForKey:@"gensprite"]retain];
	float read_width, read_height;
	read_width = [arch decodeFloatForKey:@"map_width"];
	read_height = [arch decodeFloatForKey:@"map_height"];
	entityKeys = [arch decodeObjectForKey:@"entity"];
	[arch release];
}

@end

