//
//  MXLevel.h
//  MXLevelEdit
//
//  Created by Jared Bruni on 9/5/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MXAnimation.h"


@interface MXLevel : NSObject {
	NSMutableDictionary *level_map;
	NSString *level_title;
	float width, height;
}

- (void) createLevel;
- (void) releaseLevel;
- (void) readLevel: (NSString *)filename;


@end
