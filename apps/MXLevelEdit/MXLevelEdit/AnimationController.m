//
//  AnimationController.m
//  MXLevelEdit
//
//  Created by Jared Bruni on 8/30/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//

#import "AnimationController.h"

@implementation AnimationController

- (void) awakeFromNib {
	[sprite_edit_x setDelegate: self];
	[sprite_edit_y setDelegate: self];
	[sprite_edit_w setDelegate: self];
	[sprite_edit_h setDelegate: self];
	offset = 0;
	[sprite_list_view setDataSource:self];
	[sprite_delay setStringValue:@"0.1"];
}

- (void) dealloc {
	// release
	[super dealloc];
}

- (void) controlTextDidChange: (NSNotification*)n {
	[sprite_edit_view setNeedsDisplay:YES];
	[create_key_button setEnabled: YES];
}

- (IBAction) addFrame: (id) sender {
	NSString *item = [sprite_key_combo stringValue], *ani = [current_animation stringValue];
	MXAnimation *anix;
	anix = [animations objectForKey: ani];
	if(anix == nil) {
		NSRunAlertPanel(@"You must select a animation", @"To add sprite to", @"Ok", nil, nil);
		return;
	}
	MXSprite *s = [animationFrames objectForKey:item];
	if(s == nil) {
		NSRunAlertPanel(@"You must select a sprite", @"To add to current animation", @"Ok", nil, nil);
		return;
	}
	[anix addFrame:s];
	[anix setTimerPause: [sprite_delay floatValue]];
	[sprite_list_view reloadData];
}

- (IBAction) removeFrame: (id) sender {
	NSInteger index = [sprite_list_view selectedRow];
	MXAnimation *mx = [animations objectForKey: [current_animation stringValue]];
	if(mx == nil) return;
	
	if(index >= 0 && index < [[mx frames] count] ) {
		[[mx frames] removeObjectAtIndex:index];
		[sprite_list_view reloadData];
	}
}

- (IBAction) playAnimation: (id) sender {
	[sprite_preview_view playAnimation];
}

- (IBAction) createSprite: (id) sender {
	NSString *text = [sprite_edit_key stringValue];
	NSString *sprite_key = [NSString stringWithFormat:@"%@%d", text, ++offset];
	NSImage *image = [sprite_edit_view image];
	[animationDict setObject:image forKey: [sprite_edit_view imagePath]];
	MXTileSize ts = { (int)[sprite_edit_w integerValue], (int)[sprite_edit_h integerValue] };
	MXTilePoint point = { (int)[sprite_edit_x integerValue], (int)[sprite_edit_y integerValue] };
	MXSprite *s = [[MXSprite alloc] initSprite:sprite_key fullFileName: [sprite_edit_view imagePath] sizeOfTile: ts pointInImage: point ];
	[animationFrames setObject:s forKey:sprite_key];
	//[sprite_key_combo addItemWithObjectValue:sprite_key];
	[self updateComboBox];
	[create_key_button setEnabled: NO];
}

- (IBAction) selectSprite: (id) sender {
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	NSArray *arr = [NSArray arrayWithObjects: @"png", @"jpg", @"bmp", nil];
	[panel setAllowsMultipleSelection:NO];
	[panel setAllowedFileTypes:arr];

    
	if([panel runModal]) {
        
        NSString *filename = [[panel URL] path];
        
		[sprite_file_path setStringValue: filename];
		[sprite_edit_view setImage: [[NSImage alloc] initWithContentsOfFile:filename]];
		[sprite_edit_view setImagePath: filename];
		[sprite_edit_w setIntegerValue: [[sprite_edit_view image] size].width];
		[sprite_edit_h setIntegerValue: [[sprite_edit_view image] size].height];
		[sprite_edit_x setIntegerValue: 0];
		[sprite_edit_y setIntegerValue: 0];
		[sprite_edit_view setNeedsDisplay:YES];
		[create_key_button setEnabled: YES];
	}
}

- (IBAction) addAnimationKey: (id) sender {
	NSString *text = [current_animation stringValue];
	if([text length] == 0) {
		NSRunAlertPanel(@"Error must provide name", @"You must provide a name for the animation key", @"Ok", nil, nil);
		return;
	}
	[current_animation addItemWithObjectValue:text];
	MXAnimation *ani = [[MXAnimation alloc] init];
	[animations setObject: ani forKey:text];
	[ani release];
	[self updateComboBox];
	[sprite_list_view reloadData];
}

- (void) updateComboBox {
	[sprite_key_combo removeAllItems];
	NSArray *arr = [animationFrames allKeys];
	[sprite_key_combo addItemsWithObjectValues:arr];
	[current_animation removeAllItems];
	[current_animation addItemsWithObjectValues: [animations allKeys]];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {	
	NSString *column = [[aTableColumn headerCell] stringValue];
	if([column isEqualTo:@"Frame"]) return [NSString stringWithFormat:@"%d", (int)rowIndex];
	MXAnimation *t = [animations objectForKey:[current_animation stringValue]];
	if(t == nil) return nil;
	NSArray *arr = [t frames];
	MXSprite *s = [arr objectAtIndex:rowIndex];
	return [s tileKey];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	NSString *text = [current_animation stringValue];
	MXAnimation *mxa = [animations objectForKey:text];
	return [[mxa frames] count];
}

- (IBAction) changeAnimation: (id) sender {
	[sprite_list_view reloadData];
	MXAnimation *mx = [animations objectForKey: [current_animation stringValue]];
	if(mx != nil) {
		[sprite_frame setAnim:mx];
		[sprite_preview_view setMx:mx];
		[sprite_delay setFloatValue: [mx timerPause]];
	}
	
	[sprite_frame setNeedsDisplay:YES];
}

- (IBAction) changeFrame: (id) sender {
	[sprite_frame setFrame_index: (int)[sprite_list_view selectedRow]];
	[sprite_frame setNeedsDisplay:YES];
}

@end

@implementation PreviewView


@synthesize mx;

- (void) awakeFromNib {
	mx = nil;
}

- (BOOL) isFlipped { return YES; }

- (void) drawRect: (NSRect) r {
	[[NSColor blackColor] set];
	[NSBezierPath fillRect: [self bounds]];
	if(mx != nil)
	[mx drawObject];
}

- (void) playAnimation {
	if(mx == nil) return;
	MXTilePoint tp = {0,0};
	[mx setPosition:tp];
	[mx rewindAnimation];
	[self setNeedsDisplay:YES];
	timer = [NSTimer scheduledTimerWithTimeInterval:[mx timerPause] target:self selector:@selector(timerCallback:) userInfo:NULL repeats: YES];
	usleep(100);
}

- (void) timerCallback: (id) sender {
	BOOL ok = [mx nextFrame];
	if(ok == NO) [timer invalidate];
	[self setNeedsDisplay:YES];
}

@end

@implementation SpriteEditView

@synthesize imagePath;
@synthesize image;

- (void) drawRect: (NSRect) r {
	[[NSColor blackColor] set];
	[NSBezierPath fillRect: [self bounds]];
	if(image == nil) return;
	NSRect src, dst;
	src.origin = NSZeroPoint;
	src.size = [image size];
	dst.origin = NSZeroPoint;
	dst.size = [image size];
	[image drawInRect: dst fromRect: src operation: NSCompositeSourceOver fraction: 1.0f];
	NSRect rc;
	rc.origin.x = [sprite_edit_x integerValue];
	rc.origin.y = [sprite_edit_y integerValue];
	rc.size.width = [sprite_edit_w integerValue];
	rc.size.height = [sprite_edit_h integerValue];
	[[NSColor redColor] set];
	NSBezierPath *path = [NSBezierPath bezierPath];
	[path setLineWidth: 3];
	[path appendBezierPathWithRect: rc];
	[path stroke];
}

@end

@implementation FrameView

@synthesize anim;
@synthesize frame_index;

- (void) awakeFromNib {
	anim = nil;
	frame_index = 0;
}

- (BOOL) isFlipped { return YES; }

- (void) drawRect: (NSRect)r {
	[[NSColor blackColor] set];
	[NSBezierPath fillRect: [self bounds]];
	if(anim == nil || [[anim frames] count] == 0) return;
	MXTilePoint point = {0, 0};
	[anim setPosition: point];
	[anim drawFrame: frame_index];
}

@end
