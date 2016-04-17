//
//  AppController.h
//  Transer-Tool
//
//  Created by Jared Bruni on 9/16/13.
//  Copyright (c) 2013 Jared Bruni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject {
    IBOutlet NSWindow *listen_win;
    IBOutlet NSWindow *connect_win;
    IBOutlet NSWindow *transfer_win;
    IBOutlet NSPopUpButton *select_action;
    IBOutlet NSTextField *listen_port;
    IBOutlet NSTextField *listen_remote_filename;
    IBOutlet NSTextField *connect_ip, *connect_port, *connect_file;
    IBOutlet NSButton *connect_button;
    IBOutlet NSTextField *your_ip;
    IBOutlet NSButton *listen_button, *listen_select;
    IBOutlet NSProgressIndicator *progress_bar;
    IBOutlet NSScrollView *connection_log;
    IBOutlet NSTextView *text_view;
    IBOutlet NSTextField *connect_password;
    IBOutlet NSTextField *transfer_filename;
    IBOutlet NSButton *transfer_show;
    IBOutlet NSTextField *connect_dir;
    IBOutlet NSTextField *listen_password;
    IBOutlet NSButton *transfer_close;
    IBOutlet NSTextField *transfered_kb;
    NSTimer *update_timer;

    int kbps;
}

@property (assign) NSScrollView *connection_log;
@property (assign) NSTextView *text_view;
@property (assign) NSProgressIndicator *progress_bar;
@property (assign) NSWindow *transfer_win;
@property (assign) NSButton *transfer_show;
@property (assign) NSButton *connect_button;
@property (assign) NSTextField *transfer_filename;
@property (assign) NSTextField *listen_passwod;
@property (assign) NSButton *transfer_close;
@property (assign) NSTimer *update_timer;
@property (assign) NSTextField *transfered_kb;

- (IBAction) listenFor: (id) sender;
- (IBAction) connectTo: (id) sender;
- (IBAction) selectChoice: (id) sender;
- (IBAction) connectToIp: (id) sender;
- (IBAction) listenAtPort: (id) sender;
- (IBAction) selectPath: (id) sender;
- (IBAction) show_transfer: (id) sender;
- (IBAction) show_in_finder: (id) sender;
- (IBAction) connectSelectPath: (id) sender;
- (IBAction) closeTransfer:(id)sender;
- (void) updateTimer: (id) sender;
- (void) setCurKb: (int) kbps;
@end

extern AppController *controller;
extern void ListenOutput(const char *logoutput);
//extern int program_main(int argc, const char **argv);
extern bool stop_server;
extern unsigned int kbsent;
