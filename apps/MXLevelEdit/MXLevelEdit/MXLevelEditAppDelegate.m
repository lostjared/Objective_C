//
//  MXLevelEditAppDelegate.m
//  MXLevelEdit
//
//  Created by Jared Bruni on 8/21/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//

#import "MXLevelEditAppDelegate.h"

@implementation MXLevelEditAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (BOOL) application: (NSApplication *)sender openFile: (NSString *)filename {
	[app_controler readMap:filename];
	return YES;
}

@end
