//
//  AppController.h
//  MXLevelEdit
//
//  Created by Jared Bruni on 8/25/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "grid.h"
#import "MXSpriteView.h"
#import "MXSpriteListView.h"
#import "MXLevel.h"


#define MXLEVELEDIT_VERSION @"Version: Beta 2.01"

@class AnimationController;

@interface AppController : NSObject<NSTextFieldDelegate> {
	enum MXToolType current_tool;
	IBOutlet NSWindow *toolbox_window;
	IBOutlet NSWindow *grid_window_handle;
	IBOutlet NSPopUpButton *tool_selector;
	IBOutlet grid *window_grid;
	IBOutlet NSPopUpButton *layer_selector;
	IBOutlet NSPopUpButton *sprite_selector;
	IBOutlet NSWindow *background_sprite_window;
	IBOutlet NSWindow *adjust_tile_size;
	IBOutlet NSTextField *tile_width;
	IBOutlet NSTextField *tile_height;
	IBOutlet MXSpriteView *sprite_selector_view;
	IBOutlet NSTextField *sprite_selector_string;
	IBOutlet NSTextField *sprite_selector_width;
	IBOutlet NSTextField *sprite_selector_height;
	IBOutlet NSTextField *sprite_selector_x;
	IBOutlet NSTextField *sprite_selector_y, *sprite_selector_name;
	IBOutlet NSButton *addKeyButton;
	IBOutlet MXSpriteListViewController *sprite_list_view;
	IBOutlet NSWindow *sprite_list_view_window;
	IBOutlet NSWindow *create_new_map;
	IBOutlet NSWindow *pref_dialog;
	IBOutlet NSButton *pref_dialog_smooth;
	IBOutlet NSTextField *create_map_title, *create_map_width, *create_map_height;
	IBOutlet NSWindow *level_prop_window, *program_about;
	IBOutlet NSTextField *level_prop_name, *program_version;
	IBOutlet NSWindow *ani_editor;
	IBOutlet NSComboBox *sprite_states;
	IBOutlet AnimationController *ani_ctrl;
	IBOutlet NSWindow *code_editor;
	IBOutlet NSButton *bgsprite;
	IBOutlet NSMenuItem *layerBackground, *layerSprite, *layerEntity;
	IBOutlet NSPopUpButton *map_size;
	IBOutlet NSWindow *entity_window;
	IBOutlet NSComboBox *entity_id;
	IBOutlet NSWindow *export_map;
	IBOutlet NSPopUpButton *export_map_choice;
	int spriteOffset;
	NSString *currentFileName;
	MXLevel *level;
}

- (IBAction) changeTool: (id) sender;
- (IBAction) changeLayer: (id) sender;
- (IBAction) changeSprite: (id) sender;
- (IBAction) scrollGridLeft: (id) sender;
- (IBAction) scrollGridRight: (id) sender;
- (IBAction) scrollGridUp: (id) sender;
- (IBAction) scrollGridDown: (id) sender;
- (IBAction) scrollGridHome: (id) sender;
- (IBAction) showBackgroundSpriteEditor: (id) sender;
- (IBAction) showAdjustTileSize: (id) sender;
- (IBAction) adjustSize: (id) sender;
- (IBAction) selectSprite: (id) sender;
- (IBAction) createTileKey: (id) sender;
- (IBAction) showBackgroundSpriteList: (id) sender;
- (void) buildSpriteListMenu;
- (void) spriteChanged: (id) sender;
- (IBAction) createNewMap: (id) sender;
- (IBAction) showCreateNewMap: (id) sender;
- (IBAction) showLevelMap: (id) sender;
- (IBAction) showPrefs: (id) sender;
- (void) saveMap:(NSString *)fileName;
- (void) readMap:(NSString *)fileName;
- (IBAction) openMapModal: (id) sender;
- (IBAction) saveAsModal: (id) sender;
- (IBAction) saveMapAction: (id) sender;
- (void) updateGridWindowTitle;
- (IBAction) showLevelProp: (id) sender;
- (IBAction) saveLevelProp: (id) sender;
- (IBAction) showAbout: (id) sender;
- (IBAction) dismissAbout: (id) sender;
- (IBAction) showToolbox: (id) sender;
- (IBAction) showAniEditor: (id) sender;
- (IBAction) showCode: (id) sender;
- (IBAction) toggleSize: (id) sender;
- (IBAction) toggleLayerBackground: (id) sender;
- (IBAction) toggleLayerSprite: (id) sender;
- (IBAction) toggleLayerEntity: (id) sender;
- (IBAction) showEntityEditor: (id) sender;
- (IBAction) createID: (id) sender;
- (IBAction) exportMap: (id) sender;
- (IBAction) export_: (id) sender;

@end

