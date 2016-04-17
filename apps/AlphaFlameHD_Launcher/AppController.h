//
//  AppController.h
//  AlphaFlameHD_Launcher
//
//  Created by Jared Bruni on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject<NSTableViewDataSource> {

	NSString *outputPath;
	IBOutlet NSButton *bt_scr, *bt_slow;
	IBOutlet NSTableView *tview;
	IBOutlet NSTextField *output_path;
	IBOutlet NSButton *run1080;
    IBOutlet NSTextField *field1;
    IBOutlet NSButton *chk_button1;
	NSMutableArray *files;
	NSString *output_p;
    NSData *d;
    int status;
    IBOutlet NSProgressIndicator *progress;
	
}

- (IBAction) addImage: (id) sender;
- (IBAction) removeImage: (id) sender;
- (IBAction) setPath: (id) sender;
- (IBAction) runProgram: (id) sender;
- (IBAction) set_Enabled: (id) sender;

@end
