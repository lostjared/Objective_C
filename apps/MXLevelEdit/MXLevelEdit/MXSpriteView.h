//
//  MXSpriteView.h
//  MXLevelEdit
//
//  Created by Jared Bruni on 8/25/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"MXSprite.h"

@interface MXSpriteView : NSView {
	NSPoint imagePoint;
	IBOutlet NSTextField *tx, *ty, *tw, *th;
	IBOutlet NSButton *addKey;
	NSImage *spriteImage;
	NSString *spriteString;
	int spriteWidth, spriteHeight;
}

@property (readwrite, retain) NSImage *spriteImage;
@property (readwrite, retain) NSString *spriteString;
@property (readwrite, assign) int spriteWidth;
@property (readwrite, assign) int spriteHeight;
- (void) setImagePoint: (NSPoint) p;
- (IBAction) textChangedX: (id) sender;
- (MXTilePoint) tilePoint;

@end
