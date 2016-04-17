//
//  MXLevelEditAppDelegate.h
//  MXLevelEdit
//
//  Created by Jared Bruni on 8/21/10.
//  Copyright 2010 Jared Bruni. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppController.h"



@interface MXLevelEditAppDelegate : NSObject <NSApplicationDelegate>  {
    NSWindow *window;
	IBOutlet AppController *app_controler;
}

@property (assign) IBOutlet NSWindow *window;

@end
