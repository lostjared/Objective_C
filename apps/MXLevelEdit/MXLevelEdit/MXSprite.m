//
//  MXSprite.m
//  MXLevelEdit
//
//  Created by Jared Bruni on 8/25/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//

#import "MXSprite.h"

NSMutableDictionary *imageDict, *spriteDict, *animationDict, *animationFrames, *animations, *generalSprites, *entityKeys;

@implementation MXSprite
@synthesize tileKey;
@synthesize fileName;
@synthesize debugFileName;
@synthesize tileSize;
@synthesize tilePoint;
@synthesize tileState;

- (id) initSprite: (NSString *)tileKeyz fullFileName:(NSString *) filename sizeOfTile: (MXTileSize) ts pointInImage: (MXTilePoint) point {
	if( (self = [super init]) == nil) return nil;
	[self setTileKey: tileKeyz];
	[self setDebugFileName: filename];
	[self setFileName: filename];
	/* TODO: break filename w/o directory */	
	[self setTileSize: ts];
	[self setTilePoint: point];
	[self setTileState:0];
	return self;
}

- (NSString*) description {
	return [NSString stringWithFormat: @"SpriteKey: %@ fileName: %@ Size: [%d,%d] Point: [%d,%d] State: %d", tileKey, debugFileName, tileSize.width, tileSize.height, tilePoint.x, tilePoint.y, tileState];
}

- (id) copyWithZone:(NSZone*)zone {

	MXSprite *image;
	image = [[MXSprite allocWithZone: zone] initSprite: [self tileKey] fullFileName: [self fileName] sizeOfTile: [self tileSize] pointInImage: [self tilePoint]];
	return image;
}

- (void) encodeWithCoder:(NSCoder *)coder {
	[coder encodeInt: tileSize.width forKey: @"tile.width"];
	[coder encodeInt: tileSize.height forKey: @"tile.height"];
	[coder encodeInt: tilePoint.x forKey:@"point.x"];
	[coder encodeInt: tilePoint.y forKey:@"point.y"];
	[coder encodeInt: tileState forKey:@"tile_state"];
	[coder encodeObject: fileName forKey:@"fileName"];
	[coder encodeObject: tileKey  forKey:@"tileKey"];
}

- (id) initWithCoder:(NSCoder *)coder {
	tileSize.width = [coder decodeIntForKey:@"tile.width"];
	tileSize.height = [coder decodeIntForKey:@"tile.height"];
	tilePoint.x = [coder decodeIntForKey:@"point.x"];
	tilePoint.y = [coder decodeIntForKey:@"point.y"];
	[self setTileState: [coder decodeIntForKey:@"tile_state"]];
	[self setFileName: [coder decodeObjectForKey:@"fileName"]];
	[self setDebugFileName:[coder decodeObjectForKey:@"fileName"]];
	[self setTileKey:[coder decodeObjectForKey:@"tileKey"]];
	return self;
}

- (void) drawAtPoint: (MXTilePoint) p {
	NSRect spriteRect;				
	spriteRect.origin.x = [self tilePoint].x;
	spriteRect.origin.y = [self tilePoint].y;
	spriteRect.size.width = [self tileSize].width;
	spriteRect.size.height = [self tileSize].height;
	NSRect pointRect;
	pointRect.origin.x = p.x;
	pointRect.origin.y = p.y;
	pointRect.size.width = tileSize.width;
	pointRect.size.height = tileSize.height;
	NSImage *img = [imageDict objectForKey: [self fileName]];
	[img drawInRect:pointRect fromRect:spriteRect operation:NSCompositeSourceOver fraction: 1.0f respectFlipped:YES hints:nil];
}

@end

