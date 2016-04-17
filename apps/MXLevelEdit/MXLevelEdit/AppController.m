//
//  AppController.m
//  MXLevelEdit
//
//  Created by Jared Bruni on 8/25/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//

#import "AppController.h"
#import "AnimationController.h"


@implementation AppController

- (id) init {
	if( (self = [super init]) == nil) return nil;
	current_tool = PENCIL;	
	[window_grid setToolType: current_tool];
	level = [[MXLevel alloc] init];
	return self;
}

- (void) awakeFromNib {
	[window_grid setCurrentKey:@""];
	[window_grid setLayerIndex: BACKGROUND];
	[window_grid setMaxX: 0];
	[window_grid setMaxY: 0];
	MXTileSize ts;
	ts.width = 16;
	ts.height = 16;
	[window_grid setTileSize:ts];
	spriteOffset = 0;
	[sprite_selector_view setSpriteImage: nil];
	[window_grid setMapTitle:@"Untitled"];
	currentFileName = nil;
	[self updateGridWindowTitle];
	[program_version setStringValue:MXLEVELEDIT_VERSION];
	[sprite_states addItemsWithObjectValues: [NSArray arrayWithObjects: @"No State", @"Solid", @"Harmfull", @"Exit", nil]];
	[sprite_states selectItemAtIndex: 0];
	[sprite_selector_x setDelegate:self];
	[sprite_selector_y setDelegate:self];
	[sprite_selector_width setDelegate:self];
	[sprite_selector_height setDelegate:self];
	MXTileSize ms = { 800, 600 };
	[window_grid setMapSize: ms];
}

- (void) dealloc {
	[level releaseLevel];
	[window_grid releaseMap];
	if(currentFileName != nil) [currentFileName release];
	[super dealloc];
}

- (void) controlTextDidChange: (NSNotification*)n {
	[sprite_selector_view setSpriteWidth: (int)[sprite_selector_width integerValue]];
	[sprite_selector_view setSpriteHeight: (int)[sprite_selector_height integerValue]];
	[sprite_selector_view setImagePoint: NSMakePoint( [sprite_selector_x integerValue], [sprite_selector_y integerValue])];
	[sprite_selector_view setNeedsDisplay:YES];
	[addKeyButton setEnabled: YES];
	
}

- (IBAction) changeTool: (id) sender {
	int index = (int)[tool_selector indexOfSelectedItem];
	current_tool = (enum MXToolType)index;
	[window_grid setToolType: index];
}

- (IBAction) changeLayer: (id) sender {
	int index = (int)[layer_selector indexOfSelectedItem];
	[window_grid setLayerIndex:index];
	[self buildSpriteListMenu];
}

- (IBAction) changeSprite: (id) sender {	
	
}

- (IBAction) scrollGridLeft: (id) sender {
	[window_grid scrollGrid: LEFT];
}

- (IBAction) scrollGridRight: (id) sender {
	[window_grid scrollGrid: RIGHT];
}

- (IBAction) scrollGridUp: (id) sender {
	[window_grid scrollGrid: UP];
}

- (IBAction) scrollGridDown: (id) sender {
	[window_grid scrollGrid: DOWN];
}

- (IBAction) scrollGridHome: (id) sender {
	[window_grid scrollGridHome];
}

- (IBAction) showBackgroundSpriteEditor: (id) sender {
	[background_sprite_window orderFront: self];
}

- (IBAction) showAdjustTileSize: (id) sender {
	MXTileSize ts = [window_grid tileSize];
	[tile_width setIntegerValue: ts.width];
	[tile_height setIntegerValue: ts.height];
	[adjust_tile_size orderFront: self];
}

- (IBAction) adjustSize: (id) sender {
	int width = (int)[tile_width integerValue];
	int height = (int)[tile_height integerValue];
	if(width <= 5 || height <= 5 || width > 100 || height > 100) {
		NSRunAlertPanel(@"Error", @"Tile size must be between 6 and 100", @"Ok", nil, nil);
		return;
	}
	MXTileSize ts = {width,height};
	[window_grid setTileSize: ts];
	[window_grid setNeedsDisplay: YES];
}

- (IBAction) selectSprite: (id) sender {
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	[panel setAllowsMultipleSelection:NO];	
	NSArray *typeArray = [NSArray arrayWithObjects: @"png", @"jpg", @"bmp", nil];
	[panel setAllowedFileTypes: typeArray];
	[panel runModal];
	NSString *fileName = [[panel URL] path];
	if(fileName != nil) {
		NSImage *image = [[NSImage alloc] initWithContentsOfFile: fileName];
		[sprite_selector_view setSpriteImage: image];
		[sprite_selector_view setSpriteString: fileName];
		[image release];
		MXTileSize ts = [window_grid tileSize];
		[sprite_selector_view setSpriteWidth: ts.width];
		[sprite_selector_view setSpriteHeight: ts.height];
		[sprite_selector_width setIntegerValue: ts.width];
		[sprite_selector_height setIntegerValue: ts.height];
		[sprite_selector_x setIntegerValue: 0];
		[sprite_selector_y setIntegerValue: 0];
		NSString *str = [NSString stringWithFormat:@"Current Image: %@", fileName];
		[sprite_selector_string setStringValue: str];
		[sprite_selector_view setImagePoint: NSMakePoint(0, 0)];
		[addKeyButton setEnabled:YES];
		[sprite_selector_view setNeedsDisplay: YES];				
	}
}

- (IBAction) createTileKey: (id) sender {
	if([sprite_selector_view spriteImage] == nil) return;
	MXTileSize ts = { [sprite_selector_view spriteWidth], [sprite_selector_view spriteHeight] };
	MXTilePoint point = [sprite_selector_view tilePoint];
	NSString *debugFileName = [sprite_selector_view spriteString];
	++spriteOffset;
	NSString *s = [NSString stringWithFormat:@"Sprite_%@_%d", [sprite_selector_name stringValue], spriteOffset];	
	MXSprite *sprite = [[MXSprite alloc] initSprite:s  fullFileName: debugFileName sizeOfTile: ts pointInImage: point];
	[sprite setTileState: (int)[sprite_states indexOfSelectedItem]];
	[imageDict setObject: [sprite_selector_view spriteImage] forKey: debugFileName];
	if([bgsprite state] == NSOnState ) [spriteDict setObject: sprite forKey:s];
	else if([bgsprite state] == NSOffState) [generalSprites setObject: sprite forKey:s];
	[sprite release];
	[sprite_list_view reloadView];
	[addKeyButton setEnabled: NO];
	[self buildSpriteListMenu];
}

- (IBAction) toggleSize: (id) sender {
	if([bgsprite state] == NSOffState) {
		[sprite_selector_width setEnabled:YES];
		[sprite_selector_height setEnabled:YES];
		[sprite_selector_width setIntegerValue: [[sprite_selector_view spriteImage] size].width];
		[sprite_selector_height setIntegerValue:[[sprite_selector_view spriteImage] size].height];
		[sprite_selector_view setSpriteWidth: [[sprite_selector_view spriteImage] size].width];
		[sprite_selector_view setSpriteHeight: [[sprite_selector_view spriteImage] size].height];
	}
	else if([bgsprite state] == NSOnState){
		[sprite_selector_width setEnabled:NO];
		[sprite_selector_height setEnabled:NO];
		[sprite_selector_width setIntegerValue: 16];
		[sprite_selector_height setIntegerValue: 16];
	}
	[addKeyButton setEnabled:YES];
	[sprite_selector_view setNeedsDisplay:YES];
}

- (IBAction) showBackgroundSpriteList: (id) sender {
	[sprite_list_view_window orderFront: self];
}

- (void) buildSpriteListMenu {
	NSMenu *menu = [[NSMenu alloc] init];
	
	if([window_grid layerIndex] == 0) {
		if([spriteDict count] != 0) {
			for(NSString *str in [spriteDict allKeys]) {
				NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:str  action: @selector(spriteChanged:) keyEquivalent: @""];
				[item setEnabled: YES];
				[item setTarget: self];
				[menu addItem: item];
				[item release];
			}
			
			[sprite_selector setMenu: menu];
		} else [sprite_selector removeAllItems];
		
	}
	else if([window_grid layerIndex] == 1) {
		
		if([generalSprites count] != 0) {
		
			for(NSString *str in [generalSprites allKeys]) {
				NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:str  action: @selector(spriteChanged:) keyEquivalent: @""];
				[item setEnabled: YES];
				[item setTarget: self];
				[menu addItem: item];
				[item release];
			}
			
			[sprite_selector setMenu: menu];
		} else [sprite_selector removeAllItems];
	} 
	else if([window_grid layerIndex] == 2) {
		if([entityKeys count] != 0) {
			for(NSString *str in [entityKeys allKeys]) {
				
				NSLog(@"HERE\n");
				
				NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:str  action: @selector(spriteChanged:) keyEquivalent: @""];
				[item setEnabled: YES];
				[item setTarget: self];
				[menu addItem: item];
				[item release];
			}
		}
		[sprite_selector setMenu: menu];
		
	}
	[menu release];
	[self spriteChanged: self];
}

- (void) spriteChanged: (id) sender {
	if([sprite_selector selectedItem] != nil)
	[window_grid setCurrentKey:[[sprite_selector selectedItem] title]];
}

- (IBAction) showCreateNewMap: (id) sender {
	[create_map_width setIntegerValue: 16];
	[create_map_height setIntegerValue: 16];
	[create_map_title setStringValue:@"Untitled"];
	if(currentFileName != nil) {
		if(NSRunAlertPanel(@"Are you sure you want to create a new map?", @"Any unsaved changes will be discarded", @"Yes Create new map", @"No", nil) == NSAlertAlternateReturn) 
			return;
	}	
	[create_new_map orderFront: self];
}

-(IBAction) createNewMap: (id) sender {
	MXTileSize s = { (int)[create_map_width integerValue], (int)[create_map_height integerValue] };
	if(s.width <= 5 || s.height <= 5 || s.width >= 100 || s.height >= 100) {
		NSRunAlertPanel(@"Invalid Tile size", @"Tile Size must be in the range of 6 and 100", @"Ok", nil, nil);
		return;
	}
	NSString *title = [create_map_title stringValue];
	if([title length] <= 0 || [title length] >= 100) {
		NSRunAlertPanel(@"Invalid map title", @"title must be between 1 and 100 characters", @"Ok", nil, nil);
		return;
	}
	// 1280x1080 (1080p) added
	NSSize size[] = { {320, 240}, {640,480}, {800, 600}, {1280, 720}, {1920, 1080} };
	[window_grid createNewMap: s withName: title ofSize: size[ [map_size indexOfSelectedItem] ]];
	[self updateGridWindowTitle];
	[create_new_map orderOut: self];
}

- (IBAction) showLevelMap: (id) sender {
	[grid_window_handle orderFront: self];
}

- (IBAction) showPrefs: (id) sender {
	[pref_dialog orderFront:self];
}

- (void) saveMap: (NSString *) fileName {
	NSKeyedArchiver *keyed_archiver;
	NSMutableData *archiveData = [[NSMutableData alloc] init];
	keyed_archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData: archiveData];
	[keyed_archiver setOutputFormat:NSPropertyListXMLFormat_v1_0];
	[keyed_archiver encodeObject:[window_grid map] forKey:@"level_map"];
	[keyed_archiver encodeObject:spriteDict forKey:@"sprites"];
	[keyed_archiver encodeObject:imageDict forKey:@"images"];
	[keyed_archiver encodeObject:[window_grid mapTitle] forKey:@"title"];
	[keyed_archiver encodeObject: animationDict forKey:@"anid"];
	[keyed_archiver encodeObject: animationFrames forKey:@"frames"];
	[keyed_archiver encodeObject: animations forKey:@"animations"];
	[keyed_archiver encodeObject: generalSprites forKey: @"gensprite"];
	[keyed_archiver encodeObject: entityKeys forKey:@"entity"];
	NSRect r = [[window_grid window] frame];	
	[keyed_archiver encodeFloat: r.size.width forKey:@"map_width"];
	[keyed_archiver encodeFloat: r.size.height forKey:@"map_height"];
	[keyed_archiver encodeInt: [window_grid maxX] forKey:@"maxX"];
	[keyed_archiver encodeInt: [window_grid maxY] forKey:@"maxY"];
	[keyed_archiver finishEncoding];
	NSFileManager *file_manager = [NSFileManager defaultManager];
	[file_manager createFileAtPath:fileName contents:archiveData attributes:nil];
	[keyed_archiver release];
	[archiveData release];
}

- (void) readMap:(NSString *)fileName {
	NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:fileName];
	if(file == nil) {
		NSLog(@"Error file not found.");
		return;
	}
	NSData *data = [file readDataToEndOfFile];	
	NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData: data];
	[window_grid releaseMap];
	spriteDict = [[arch decodeObjectForKey:@"sprites"] retain];
	imageDict = [[arch decodeObjectForKey:@"images"] retain];
	[window_grid setMap: [[arch decodeObjectForKey:@"level_map"] retain]];
	[window_grid setMapTitle: [arch decodeObjectForKey:@"title"]];
	animationDict = [[arch decodeObjectForKey:@"anid"] retain];
	animationFrames = [[arch decodeObjectForKey:@"frames"] retain];
	animations = [[arch decodeObjectForKey:@"animations"] retain];
	generalSprites = [[arch decodeObjectForKey:@"gensprite"] retain];
	float read_width, read_height;
	read_width = [arch decodeFloatForKey:@"map_width"];
	read_height = [arch decodeFloatForKey:@"map_height"];
	[window_grid setMaxX: [arch decodeIntForKey:@"maxX"]];
	[window_grid setMaxY: [arch decodeIntForKey:@"maxY"]];
	[arch release];
	[window_grid setNeedsDisplay:YES];
	[self buildSpriteListMenu];
	[sprite_list_view reloadView];
	[ani_ctrl updateComboBox];
	NSRect pos = [[window_grid window] frame];
	pos.size.width = read_width, pos.size.height = read_height;
	
	NSLog(@"%f %f", pos.size.width, pos.size.height);
	
	[[window_grid window] setFrame: pos display: YES];
}

- (IBAction) openMapModal: (id) sender {
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	NSArray *arr = [NSArray arrayWithObject:@"mxmap"];
	[panel setAllowsMultipleSelection: NO];
	[panel setAllowedFileTypes:arr];	
	[panel runModal];
	NSString *fileName = [[panel URL] path];
	if(fileName == nil) return;
	[self readMap:fileName];
	currentFileName = [fileName retain];
	[self updateGridWindowTitle];
}

- (IBAction) saveAsModal: (id) sender {
	NSSavePanel *panel = [NSSavePanel savePanel];
	NSArray *arr = [NSArray arrayWithObject:@"mxmap"];
	[panel setAllowedFileTypes:arr];
	[panel setAllowsOtherFileTypes:NO];
	[panel runModal];
	if([[panel URL] path] != nil) {
		currentFileName = [[[panel URL] path] retain];
		[self updateGridWindowTitle];
		[self saveMapAction: sender];
	}
}

- (IBAction) saveMapAction: (id) sender {
	if(currentFileName == nil) {
		[self saveAsModal: sender];
		return;
	}
	[self saveMap: currentFileName];
}

- (void) updateGridWindowTitle {
	NSString *title = [NSString stringWithFormat:@" Level Editor [ %@ ] - %@", [window_grid mapTitle] != nil ? [window_grid mapTitle] : @"Untitled", currentFileName != nil ? currentFileName : @"Untitled.mxmap" ];
	[grid_window_handle setTitle:title];
}

- (IBAction) showLevelProp: (id) sender {
	[level_prop_name setStringValue: [window_grid mapTitle]];
	[level_prop_window orderFront: self];
}

- (IBAction) saveLevelProp: (id) sender {
	[window_grid setMapTitle: [level_prop_name stringValue]];
	[self updateGridWindowTitle];
	[level_prop_window orderOut: self];
}

- (IBAction) showAbout: (id) sender {
	[program_about orderFront: self];
}

- (IBAction) dismissAbout: (id) sender {
	[program_about orderOut: self];
}
 
- (IBAction) showToolbox: (id) sender {
	[toolbox_window orderFront: self];
}

- (IBAction) showAniEditor: (id) sender {
	[ani_ctrl updateComboBox];
	[ani_editor orderFront: self];
}

- (IBAction) showCode: (id) sender {
	[code_editor orderFront:self];
}

- (IBAction) toggleLayerBackground: (id) sender {
	int state = (int)[layerBackground state];
	if(state == NSOnState) state = NSOffState;
	else state = NSOnState;
	[layerBackground setState:state];
	[window_grid setLayerBackgroundState:state];
	[window_grid setNeedsDisplay:YES];
}
- (IBAction) toggleLayerSprite: (id) sender {
	int state = (int)[layerSprite state];
	if(state == NSOnState) state = NSOffState;
	else state = NSOnState;
	[layerSprite setState: state];
	[window_grid setLayerSpriteState:state];
	[window_grid setNeedsDisplay:YES];
}
- (IBAction) toggleLayerEntity: (id) sender {
	int state = (int)[layerEntity state];
	if(state == NSOnState) state = NSOffState;
	else state = NSOnState;
	[layerEntity setState:state];
	[window_grid setLayerEntityState:state];
	[window_grid setNeedsDisplay:YES];
}

- (IBAction) showEntityEditor: (id) sender {
	[entity_window orderFront: self];
}

- (IBAction) createID: (id) sender {
	NSString *current = [entity_id stringValue];
	if([current length] == 0) {
		NSRunAlertPanel(@"Error nothing entered", @"", @"Ok", nil, nil);
		return;
	}
	NSArray *arr = [entity_id objectValues];
	for(id x in arr) {
		if([x isEqualToString: current]) {
			NSRunAlertPanel(@"Key already exisits", @"", @"Ok", nil, nil);
			return;
		}
		
	}
	[entity_id addItemWithObjectValue:current];
	[entityKeys setObject:current forKey:current];
	[self buildSpriteListMenu];
}

- (IBAction) exportMap: (id) sender {
	[export_map orderFront:self];
}

- (IBAction) export_:(id) sender {
	NSLog(@"%@", [window_grid map]);
	
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	[panel setCanChooseFiles:NO];
	[panel setCanChooseDirectories:YES];
	[panel setAllowsMultipleSelection:NO];
	if([panel runModal]) {
		NSString *dir_str = [panel directory];
		NSFileManager *file_man = [NSFileManager defaultManager];
		NSString *map_fullpath = [NSString stringWithFormat:@"%@/mxmap", dir_str];
		NSString *img_fullpath = [NSString stringWithFormat:@"%@/mxmap/img", dir_str];
		NSString *fptr_str = [NSString stringWithFormat:@"%@/mxmap/tiles.txt", dir_str];
		[file_man createDirectoryAtPath:map_fullpath withIntermediateDirectories:NO attributes:nil error:nil];
		[file_man createDirectoryAtPath:img_fullpath withIntermediateDirectories:NO attributes:nil error:nil];
		/* Copy over images */
		for(NSString *fullpath in imageDict) {
			NSError *err = 0;
			NSString *toPath = [NSString stringWithFormat:@"%@/%@", img_fullpath, [fullpath lastPathComponent]];
			[file_man copyItemAtPath:fullpath toPath:toPath error:&err];
			if(err != nil) NSLog(@"%@", [err localizedDescription]);
		}
		for(NSString *fullpath in animationDict) {
			NSError *err = 0;
			NSString *toPath = [NSString stringWithFormat:@"%@/%@", img_fullpath, [fullpath lastPathComponent]];
			[file_man copyItemAtPath:fullpath toPath:toPath error:&err];
			if(err != nil) NSLog(@"%@", [err localizedDescription]);
		}
		for(NSString *fullpath in generalSprites) {
			NSError *err = 0;
			NSString *toPath = [NSString stringWithFormat:@"%@/%@", img_fullpath, [fullpath lastPathComponent]];
			[file_man copyItemAtPath:fullpath toPath:toPath error:&err];
			if(err != nil) NSLog(@"%@", [err localizedDescription]);
		}
		FILE *fptr = fopen([fptr_str UTF8String], "w");
		for(NSString *s in spriteDict) {
			MXSprite *sprite = [spriteDict objectForKey:s];
			NSPoint ptr_;
			ptr_.x = [sprite tilePoint].x;
			NSImage *img = [imageDict objectForKey: [sprite fileName]];
			if(img != nil) {
				NSSize sizebuf = [img size];
				int h = [sprite tileSize].height;
				int total_height=sizebuf.height;
				ptr_.y=total_height-[sprite tilePoint].y;
				ptr_.y-=h;
				
			} else {
				NSLog(@"Error could'nt find image");
			}
			fprintf(fptr, "\"%s\":\"%s\" = {\n", [[[sprite debugFileName] lastPathComponent] UTF8String], [[sprite tileKey] UTF8String]);
			fprintf(fptr, "\t%d:%d:%d:%d:%d", (int)ptr_.x, (int)ptr_.y, [sprite tileSize].width, [sprite tileSize].height,[sprite tileState]);
			fprintf(fptr, "\n}\n");
		}
		for(NSString *s in generalSprites) {
			NSPoint ptr_;
			MXSprite *sprite = [generalSprites objectForKey: s];
			ptr_.x = [sprite tilePoint].x;
			NSImage *img = [imageDict objectForKey: [sprite fileName]];
			if(img != nil) {
				NSSize sizebuf = [img size];
				int h = [sprite tileSize].height;
				int total_height=sizebuf.height;
				ptr_.y=total_height-[sprite tilePoint].y;
				ptr_.y-=h;
				ptr_.x=[sprite tilePoint].x;
			} else {
				NSLog(@"Error could'nt find image");
			}
			fprintf(fptr, "\"%s\":\"%s\" = {\n", [[[sprite debugFileName] lastPathComponent] UTF8String], [[sprite tileKey] UTF8String]);
			fprintf(fptr, "\t%d:%d:%d:%d:%d", (int)ptr_.x, (int)ptr_.y, [sprite tileSize].width, [sprite tileSize].height, [sprite tileState]);
			fprintf(fptr, "\n}\n");
		}
		fprintf(fptr, "\n\n%s<%d, %d, %d, %d, %d, %d> {\n",[[window_grid mapTitle] UTF8String], [window_grid mapSize].width, [window_grid mapSize].height, [window_grid maxX],[window_grid maxY],[window_grid tileSize].width, [window_grid tileSize].height);
		/* find offset */
		int i = 0;
		
		for(i = 0; i < [window_grid maxX]; ++i) {
			for(int z = 0; z < [window_grid maxY]; ++z) {
				NSString *item = [window_grid getGridItem:i yPos:z];
				if(item != nil) {
					fprintf(fptr, "{b,%d,%d:%s},",i,z,[item UTF8String]);
				}
				NSString *str = [NSString stringWithFormat: @"i%d:%d", ((int)i), ((int)z)];
				NSString *index = [[window_grid  map] objectForKey:str];
				
				if(index != nil)
					fprintf(fptr,"{o,%d,%d:%s},", i, z, [index UTF8String]);
				
				if(index == nil) {
					continue;
				}
			}
		}
		
		fprintf(fptr, "\n0 }\n");
		fclose(fptr);
	}
	
}

@end

