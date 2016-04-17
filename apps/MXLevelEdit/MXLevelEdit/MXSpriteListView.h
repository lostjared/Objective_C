//
//  MXSpriteListView.h
//  MXLevelEdit
//
//  Created by Jared Bruni on 8/25/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "MXSprite.h"

@interface MXSpriteListView : NSView {
	NSString *imageKey;
}

@property (readwrite, retain) NSString *imageKey;

@end

@interface MXSpriteListViewController : NSObject {
	
	IBOutlet MXSpriteListView *sprite_view;
	IBOutlet NSTableView *table_view;

}

- (void) reloadView;
- (IBAction) selChanged: (id) sender;

@end

