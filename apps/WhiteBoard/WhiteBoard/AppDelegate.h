//
//  AppDelegate.h
//  WhiteBoard
//
//  Created by Jared Bruni on 9/9/14.
//  Copyright (c) 2014 Jared Bruni. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSTextField *ip_listen, *ip_connect, *port_listen, *port_connect;
}

- (IBAction) runListenProgram: (id) sender;
- (IBAction) runConnectProgram: (id) sender;


@property (assign) IBOutlet NSWindow *window;

@end
