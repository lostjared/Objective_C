//
//  grid.m
//  MXLevelEdit
//
//  Created by Jared Bruni on 8/21/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//

#import "grid.h"


@implementation grid

@synthesize toolType;
@synthesize currentKey;
@synthesize layerIndex;
@synthesize tileSize;
@synthesize mapTitle;
@synthesize mapSize;
@synthesize layerBackgroundState;
@synthesize layerSpriteState;
@synthesize layerEntityState;
@synthesize maxX;
@synthesize maxY;

- (void) awakeFromNib {
	x_offset = 0;
	y_offset = 0;
	map = [[NSMutableDictionary alloc] init];
	[self setLayerIndex: BACKGROUND];
	layerBackgroundState = NSOnState;
	layerSpriteState = NSOnState;
	layerEntityState = NSOnState;
}

- (id) init {
	self = [super init];
	if(self == nil) return nil;
	return self;
}

- (void) dealloc  {
	[map release];
	[super dealloc];
}

- (void) createNewMap: (MXTileSize)ts withName:(NSString*)mapName ofSize:(NSSize)sizeofmap {
	[self releaseMap];
	map = [[NSMutableDictionary alloc] init];
	spriteDict = [[NSMutableDictionary alloc] init];
	imageDict = [[NSMutableDictionary alloc] init];
	animationDict = [[NSMutableDictionary alloc] init];
	animationFrames = [[NSMutableDictionary alloc] init];
	animations = [[NSMutableDictionary alloc] init];
	generalSprites = [[NSMutableDictionary alloc] init];
	entityKeys = [[NSMutableDictionary alloc] init];
	[self setCurrentKey: @""];
	[self setTileSize: ts];
	[self setMapTitle: mapName];
	NSRect pos = [[self window] frame];
	pos.size = sizeofmap;
	[[self window] setFrame: pos display:YES];
	pos.origin.x = 0, pos.origin.y = 0;
	[self setFrame: pos];
	[self setNeedsDisplay: YES];
	maxX = maxY = 0;
}

- (NSMutableDictionary *)map {
	return map;
}

- (void) setMap:(NSMutableDictionary*)m {
	map = m;
}

- (void) releaseMap {
	[map release];
	[spriteDict release];
	[imageDict release];
	[animationDict release];
	[animationFrames release];
	[animations release];
	[generalSprites release];
	[entityKeys release];
}

- (BOOL) isFlipped {
	return YES;
}

- (BOOL) acceptsFirstResponder {
	return YES; // accepts key events
}

- (void) drawRect: (NSRect)rec {
	NSRect r = [self bounds];
	[[NSColor whiteColor] set];
	[NSBezierPath fillRect: r];
	NSPoint p;
	p.x = 0;
	p.y = 0;
	NSBezierPath *path = [NSBezierPath bezierPath];
	[[NSColor blackColor] set];
	for(float x = 0; x < r.size.width/tileSize.width; x++) {
		for(float y = 0; y < r.size.height/tileSize.height; y++) {
			NSString *str = [NSString stringWithFormat: @"%d:%d", ((int)x+x_offset), ((int)y+y_offset)];
			NSString *index = [map objectForKey: str];
			if(index == nil || [index length] == 0 || layerBackgroundState == NSOffState) {
				p.x = (x*tileSize.width);
				p.y = (y*tileSize.height);
				p.x += 1;
				[path moveToPoint: p];
				p.x += (tileSize.width-1);
				[path lineToPoint: p];
				p.y += (tileSize.height-1);
				[path lineToPoint: p];
				p.x -= (tileSize.width-1);
				[path lineToPoint: p];
				p.y -= (tileSize.height-1);
				[path lineToPoint: p];
			} else {
				
				
				MXSprite *s = [spriteDict objectForKey:index];
				if(s == nil || [index length] == 0) return;
				MXTilePoint ts = {x*tileSize.width, y*tileSize.height};
				[s drawAtPoint:ts];
			}
		}
	}
	[path fill];
	for(float x = 0;  x < r.size.width/tileSize.width; x++) {
	
		for(float y = 0; y < r.size.height/tileSize.height; y++) {
		
			NSString *str = [NSString stringWithFormat: @"i%d:%d", ((int)x+x_offset), ((int)y+y_offset)];
			NSString *index = [map objectForKey:str];
			if(str == nil || [index length] == 0) continue;
			MXSprite *sprite = [generalSprites objectForKey:index];
			if(sprite == nil || layerBackgroundState == NSOffState) continue;
			MXTilePoint p = { x*tileSize.width, y*tileSize.height };
			[sprite drawAtPoint:p];
		}
		
	}
	
}

- (void) setGridItem:(NSString *)item xPos:(int)x yPos:(int)y {
	NSString *posType;
	
	if(x > maxX) maxX = x;
	if(y > maxY) maxY = y;
	
	switch(layerIndex) {
		case 0:
			posType = @"";
			if(layerBackgroundState == NSOffState) {
				NSRunAlertPanel(@"Background Layer is turn off, to turn it on Project menu under Layer be sure Background is checked", @"", @"Ok", nil, nil);
				return;
			}
			break;
		case 1:
			posType = @"i";
			if(layerSpriteState == NSOffState)
			{
				NSRunAlertPanel(@"Background Sprites Layer is turned off, to turn it on in the Project menu under Layer be sure Background Sprites is checkedr", @"", @"Ok", nil, nil);
				return;
			}
			break;
		case 2:
			posType = @"e";
			if(layerEntityState == NSOffState) {
				NSRunAlertPanel(@"Entity Layer is turned off, to turn it on go to Project menu, and be sure the Entity Layer is checked", @"", @"Ok", nil, nil);
				return;
			}
			break;
	}
	NSString *pos = [NSString stringWithFormat: @"%@%d:%d", posType,x, y];
	[map setObject: item forKey: pos];
}

- (NSString *) getGridItem:(int)x yPos:(int)y {
	NSString *pos = [NSString stringWithFormat: @"%d:%d", x, y];
	return [map objectForKey: pos];	
}


- (void) removeGridItem:(int)x yPos:(int)y {
	NSString *pos = [NSString stringWithFormat:@"%d:%d", x, y];
	[map removeObjectForKey:pos];
}

- (void) fillGridByOffset: (NSString *)image {
	for(float x = 0; x < 800/tileSize.width; x++) {
		for(float y = 0; y < 600/tileSize.height; y++) {
			int xpos = (int)x+x_offset;
			int ypos = (int)y+y_offset;
			[self setGridItem:image xPos:xpos yPos:ypos];
		}		
	}
}

- (void) scrollGrid:(enum MXDirection)d {
	switch(d) {
		case UP:
			if(y_offset > 0) y_offset--;
			break;
		case DOWN:
			y_offset++;
			break;
		case LEFT:
			if(x_offset > 0) x_offset--;
			break;
		case RIGHT:
			x_offset++;
			break;
	}
	[self setNeedsDisplay:YES];
}

- (void) scrollGridHome {
	x_offset = 0;
	y_offset = 0;
	[self setNeedsDisplay:YES];
}

- (void) mouseDown:(NSEvent *)e {
	
	if(toolType == FILL) {
		NSPoint p = [self convertPoint: [e locationInWindow] fromView: nil];
		if(p.x < 0 || p.y < 0 || p.x > 800 || p.y > 600 || [currentKey length] == 0) return;
		int xpos = 0, ypos = 0;
		if([self gridPosByPoint:p xPos:&xpos yPos:&ypos] == YES) {
			xpos += x_offset;
			ypos += y_offset;
			if(toolType == 3) {
				[self fillGridByOffset:currentKey];
				[self setNeedsDisplay:YES];
				return;
			}
		}
	} 
	else [self mouseDragged: e];
}

- (void) mouseUp:(NSEvent *)e {}

- (void) mouseDragged:(NSEvent *)e {
	NSPoint p = [self convertPoint: [e locationInWindow] fromView: nil];
	if(p.x < 0 || p.y < 0 || p.x > 800 || p.y > 600 || [currentKey length] == 0) return;
	int xpos = 0, ypos = 0;	
	if([self gridPosByPoint:p xPos:&xpos yPos:&ypos] == YES) {
		xpos += x_offset;
		ypos += y_offset;
		switch(toolType) {
			case PENCIL:
				[self setGridItem:currentKey xPos:(int)xpos yPos:(int)ypos];
				break;
			case SQUARE:
				[self setGridItem:currentKey xPos:(int)xpos yPos:(int)ypos];
				[self setGridItem:currentKey xPos:(int)xpos+1 yPos:(int)ypos];
				[self setGridItem:currentKey xPos:(int)xpos+1 yPos:(int)ypos+1];
				[self setGridItem:currentKey xPos:(int)xpos yPos:(int)ypos+1];
				break;
			case ERASER:
				[self removeGridItem:(int)xpos yPos:(int)ypos];
				break;
		}
		[self setNeedsDisplay:YES];		
		return;
	}
}

- (BOOL) gridPosByPoint:(NSPoint)p xPos:(int*)xpos yPos:(int*)ypos {
	NSRect bounds = [self bounds];
	for(float x = 0; x < bounds.size.width/tileSize.width; x++) {	
		for(float y = 0; y < bounds.size.height/tileSize.height; y++) {
			float pos_x = x*tileSize.width;
			float pos_y = y*tileSize.height;
			if(p.x >= pos_x && p.y >= pos_y && p.x <= pos_x+tileSize.width && p.y <= pos_y+tileSize.height ) {
				*xpos = (int)x;
				*ypos = (int)y;
				return YES;
			}
		}
	}
	return NO;
}

@end

