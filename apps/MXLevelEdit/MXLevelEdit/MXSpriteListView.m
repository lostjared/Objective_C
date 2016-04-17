//
//  MXSpriteListView.m
//  MXLevelEdit
//
//  Created by Jared Bruni on 8/25/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//

#import "MXSpriteListView.h"


@implementation MXSpriteListView

@synthesize imageKey;

- (BOOL) isFlipped { return YES; }

- (void) drawRect: (NSRect) rect {
	if(imageKey != nil) {
		NSRect r = [self bounds];
		NSRect dr;
		NSImage *img;
		MXSprite *s = [spriteDict objectForKey: imageKey];
		img = [imageDict objectForKey: [s fileName]];
		MXTilePoint p = [s tilePoint];
		MXTileSize ts = [s tileSize];
		dr.origin.x = p.x;
		dr.origin.y = p.y;
		dr.size.width = ts.width;
		dr.size.height = ts.height;
		[img drawInRect:r fromRect:dr operation:NSCompositeSourceOver fraction: 1.0f respectFlipped:YES hints:nil];
	}
}

@end

@implementation MXSpriteListViewController


- (void) awakeFromNib {

	
	
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {	
	NSString *column = [[aTableColumn headerCell] stringValue];
	NSArray *arr = [spriteDict allKeys];
	MXSprite *sprite = [spriteDict objectForKey: [arr objectAtIndex: rowIndex]];
	if([column isEqualTo: @"Key"])
		return [arr objectAtIndex: rowIndex];
	else if([column isEqualTo: @"State"]) 
		return [NSString stringWithFormat:@"%d", [sprite tileState]];
	else
		return [[spriteDict objectForKey: [arr objectAtIndex: rowIndex]] fileName];
	return nil;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [spriteDict count];
	
}

- (void) reloadView {
	[table_view reloadData];
}

- (IBAction) selChanged: (id) sender {
	int row = (int)[table_view selectedRow];
	[sprite_view setImageKey: [[spriteDict allKeys] objectAtIndex:row]];
	[sprite_view setNeedsDisplay:YES];
}

@end

