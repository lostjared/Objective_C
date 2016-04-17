//
//  AnimationController.h
//  MXLevelEdit
//
//  Created by Jared Bruni on 8/30/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "MXAnimation.h"

@interface PreviewView : NSView {
	MXAnimation *mx;
	NSTimer *timer;
}

- (void) playAnimation;

@property (readwrite, retain) MXAnimation *mx;

@end

@interface SpriteEditView : NSView {
	
	IBOutlet NSTextField *sprite_edit_x, *sprite_edit_y, *sprite_edit_w, *sprite_edit_h, *sprite_edit_key;
	NSImage *image;
	NSString *imagePath;
}

@property (readwrite, retain) NSImage *image;
@property (readwrite, retain) NSString *imagePath;

@end

@interface FrameView : NSView {
	MXAnimation *anim;
	int frame_index;
}

@property (readwrite, retain) MXAnimation *anim;
@property (readwrite, assign) int frame_index;
@end

@interface AnimationController : NSObject<NSTextFieldDelegate, NSTableViewDataSource> {

	IBOutlet NSTableView *sprite_list_view;
	IBOutlet NSTextField *sprite_delay;
	IBOutlet FrameView *sprite_frame;
	IBOutlet SpriteEditView *sprite_edit_view;
	IBOutlet PreviewView *sprite_preview_view;
	IBOutlet NSTextField *sprite_edit_x, *sprite_edit_y, *sprite_edit_w, *sprite_edit_h, *sprite_edit_key;
	IBOutlet NSComboBox *sprite_key_combo, *current_animation;
	IBOutlet NSTextField *sprite_file_path;
	IBOutlet NSButton *create_key_button;
	int offset;
}

- (IBAction) addFrame: (id) sender;
- (IBAction) removeFrame: (id) sender;
- (IBAction) playAnimation: (id) sender;
- (IBAction) createSprite: (id) sender;
- (IBAction) selectSprite: (id) sender;
- (IBAction) addAnimationKey: (id) sender;
- (IBAction) changeAnimation: (id) sender;
- (void) updateComboBox;
- (IBAction) changeFrame: (id) sender;

@end
