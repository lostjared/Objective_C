//
//  MXSprite.h
//  MXLevelEdit
//
//  Created by Jared Bruni on 8/25/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum MXToolType { PENCIL, SQUARE, ERASER, FILL };
enum MXLayer { BACKGROUND, BGSPRITE, ENTITY };
enum MXDirection { UP, DOWN, LEFT, RIGHT };

typedef struct _MXTileSize {
	int width;
	int height;	
} MXTileSize;
typedef struct _MXTilePoint {
	int x,y;
} MXTilePoint;

typedef struct _MXTile {
	MXTilePoint point;
	MXTileSize  size;
}MXTile;

@interface MXSprite : NSObject<NSCoding, NSCopying> {
	NSString *tileKey;
	NSString *fileName;
	NSString *debugFileName;
	MXTileSize tileSize;
	MXTilePoint tilePoint;
	int tileState;
	int gfx_height;
}

- (id) initSprite: (NSString *)tileKey fullFileName:(NSString *) filename sizeOfTile: (MXTileSize) ts pointInImage: (MXTilePoint) point;
- (void) drawAtPoint: (MXTilePoint) p;

@property (readwrite, retain) NSString *tileKey;
@property (readwrite, retain) NSString *fileName;
@property (readwrite, retain) NSString *debugFileName;
@property (readwrite, assign) MXTileSize tileSize;
@property (readwrite, assign) MXTilePoint tilePoint;
@property (readwrite, assign) int tileState;

@end

extern NSMutableDictionary *imageDict, *spriteDict, *animationDict, *animationFrames, *animations, *generalSprites, *entityKeys;
