//
//  grid.h
//  MXLevelEdit
//
//  Created by Jared Bruni on 8/21/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXSprite.h"


@interface grid : NSView {
	NSMutableDictionary *map;
	int x_offset, y_offset;
	int toolType;
	int layerIndex;
	NSString *currentKey;
	MXTileSize tileSize;
	NSString *mapTitle;
	MXTileSize mapSize;
	int layerBackgroundState, layerSpriteState, layerEntityState;
	int maxX, maxY;
}

- (void) setGridItem:(NSString *)item xPos:(int)x yPos:(int)y;
- (NSString *) getGridItem:(int)x yPos:(int)y;
- (BOOL) gridPosByPoint:(NSPoint)p xPos:(int*)x yPos:(int*)y;
- (void) removeGridItem:(int)x yPos:(int)y;
- (void) fillGridByOffset: (NSString *)image;
- (void) scrollGrid:(enum MXDirection)d;
- (void) scrollGridHome;
- (void) createNewMap: (MXTileSize)ts withName:(NSString*)mapName ofSize:(NSSize)sizeofmap;
- (void) releaseMap;
- (NSMutableDictionary *)map;
- (void) setMap:(NSMutableDictionary *)m;

@property (readwrite, assign) int toolType;
@property (readwrite, assign) int layerIndex;
@property (readwrite, retain) NSString *currentKey;
@property (readwrite, assign) MXTileSize tileSize;
@property (readwrite, retain) NSString *mapTitle;
@property (readwrite, assign) MXTileSize mapSize;
@property (readwrite, assign) int layerBackgroundState;
@property (readwrite, assign) int layerSpriteState;
@property (readwrite, assign) int layerEntityState;
@property (readwrite, assign) int maxX;
@property (readwrite, assign) int maxY;
@end
