//
//  MXAnimation.h
//  MXLevelEdit
//
//  Created by Jared Bruni on 8/30/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MXSprite.h"



@interface MXAnimation : NSObject<NSCoding, NSCopying> {
	NSMutableArray *frames;
	NSTimer *timer;
	int current_frame;
	BOOL isPlaying;
	MXTilePoint position;
	float timerPause;
}

- (void) addFrame: (MXSprite *)sprite;
- (void) rewindAnimation;
- (void) drawFrame: (int) index;
- (BOOL) nextFrame;
- (void) drawObject;

@property (readwrite, assign) float timerPause;
@property (readwrite, assign) MXTilePoint position;
@property (readwrite, retain) NSMutableArray *frames;

@end

