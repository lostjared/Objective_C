//
//  AppController.m
//  Transer-Tool
//
//  Created by Jared Bruni on 9/16/13.
//  Copyright (c) 2013 Jared Bruni. All rights reserved.
//

/* todo: add a password */
#import "AppController.h"
#include"transfer.hpp"
#import<pthread.h>
#include<thread>
#include<iostream>
#include<sstream>
#include<string>
#include<regex>

AppController *controller;
pthread_t main_thread, connect_thread;
bool stop_server = false;
bool server_on = false;
std::string argv[6];
unsigned int kbsent = 0;
std::mutex kb_mut;


void *program_function(void *ptr) {
    std::string* s = (std::string *)ptr;
    program_main(4, s);
    return 0;
}

void *connect_function(void *ptr) {
    std::string *s = (std::string *)ptr;
    program_main(6, s);
    return 0;
}


@implementation AppController

@synthesize connection_log;
@synthesize text_view;
@synthesize progress_bar;
@synthesize transfer_win;
@synthesize transfer_show;
@synthesize connect_button;
@synthesize transfer_filename;
@synthesize listen_passwod;
@synthesize transfer_close;
@synthesize update_timer;
@synthesize transfered_kb;
- (id) init {
    self = [super init];
    controller = self;
    return self;
}


- (IBAction) listenFor: (id) sender {
    [listen_win orderFront: self];
}
- (IBAction) connectTo: (id) sender {
    [connect_win orderFront: self];
}

- (IBAction) show_transfer: (id) sender {
    [transfer_show setEnabled: NO];
    [transfer_win orderFront:self];
    [transfer_win makeKeyWindow];
    [connect_button setEnabled:NO];
}


- (IBAction) selectChoice: (id) sender {
    NSInteger item = [select_action indexOfSelectedItem];
    if(item != -1) {
        switch(item) {
            case 0:
                [self connectTo: nil];
                break;
            case 1:
                [self listenFor: nil];
                break;
        }
    }
}

- (IBAction) connectToIp: (id) sender {
    NSString *ipaddress = [connect_ip stringValue];
    NSInteger port = [connect_port integerValue];
    NSString *filename = [connect_file stringValue];
    NSString  *password = [connect_password stringValue];
    NSString  *dir_path = [connect_dir stringValue];
    if([ipaddress length] <= 0) {
        NSRunAlertPanel(@"Enter a IP address", @"Ok", @"Ok", nil, nil, nil);
        return;
    }
    std::regex r("(\\d{1,3}(\\.\\d{1,3}){3})");
    std::string ip = [ipaddress UTF8String];
    std::string ip_trim;
    for(int i = 0; i < ip.length(); ++i) {
        if(!isspace(ip[i])) {
            ip_trim += ip[i];
        }
    }
    bool isvalid = std::regex_match(ip_trim, r);
    if(!isvalid) {
        NSRunAlertPanel(@"Invalid ip address", @"Enter a valid ip address", @"Ok", nil,nil,nil);
        return;
    }
    if(port <= 0 || port > 65535) {
        NSRunAlertPanel(@"Enter a valid port", @"Ok", @"Ok", nil, nil, nil);
        return;
    }
    
    if([filename length] <= 0) {
        NSRunAlertPanel(@"Enter a valid filename to retrieve", @"Ok", @"Ok", nil ,nil, nil);
        return;
    }
    
    if([password length] <= 0) {
        NSRunAlertPanel(@"Enter the servers password", @"Ok", @"Ok", nil,nil,nil);
        return;
    }
    
    if([dir_path length] <= 0) {
        NSRunAlertPanel(@"Enter directory path.", @"Ok", @"Ok", nil, nil, nil);
        return;
    }
    
    NSLog(@"Password %@\n Connect to: %@ : %d get file %@", password, ipaddress, (int)port, filename);
    argv[0] = "program";
    argv[1] = [ipaddress UTF8String];
    argv[2] = [[connect_port stringValue] UTF8String];
    argv[3] = [filename UTF8String];
    argv[4] = [[connect_dir stringValue] UTF8String];
    argv[5] = [[connect_password stringValue] UTF8String];
    pthread_create(&connect_thread, NULL, connect_function, (void*)argv);
    update_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    
}

- (void) setCurKb: (int) k {
    kbps = k;
}

- (void) updateTimer: (id) sender {
    
    unsigned int cur_kb = kbps;
    if(cur_kb != 0) {
        NSString *str = [NSString stringWithFormat: @"%d kbps", cur_kb];
        [transfered_kb setStringValue: str];
    }
    kbsent = 0;
}

- (IBAction) listenAtPort: (id) sender {
    if(server_on == true) {
        if(NSRunAlertPanel(@"Are you sure you want to quit?", @"Sure?", @"No", @"Yes", nil) == NSAlertAlternateReturn)
            exit(0);
        return;
    }
    NSInteger port = [listen_port integerValue];
    NSString *file_path = [listen_remote_filename stringValue];
    
    if(port <= 0 || port > 65535) {
        NSRunAlertPanel(@"Please enter a valid port number", @"Ok", @"Ok", nil, nil, nil);
        return;
    }
    
    if([file_path length] <= 0) {
        NSRunAlertPanel(@"Please enter a valid directory", @"Ok", @"Ok", nil, nil, nil);
        return;
    }
    
    if([[listen_password stringValue] length] < 2) {
        NSRunAlertPanel(@"Password not long enough\n", @"Ok", @"Ok", nil, nil, nil);
        
    }
    
    [text_view setString:@"Starting..."];
    NSString *t = [NSString stringWithFormat:@"Listening at port %d, serving path %@", (int) port, file_path];
    ListenOutput([t UTF8String]);
    server_on = true;
    argv[0] = "program";
    argv[1] = [[listen_port stringValue] UTF8String];
    argv[2] = [file_path UTF8String];
    argv[3] = [[listen_password stringValue] UTF8String];
    pthread_create(&main_thread, NULL, program_function, (void*)argv);
    [listen_port setEnabled: NO];
    [listen_select setEnabled: NO];
    [listen_button setTitle:@"Quit"];
    server_on = true;
}


- (IBAction) selectPath: (id) sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    if([panel runModal]) {
        NSString *dir_path = [[[panel URLs] objectAtIndex: 0] path];
        [listen_remote_filename setStringValue: dir_path];
    }
}


- (IBAction) connectSelectPath: (id) sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    if([panel runModal]) {
        NSString *dir_path = [[[panel URLs] objectAtIndex: 0] path];
        [connect_dir setStringValue: dir_path];
    }
}

- (IBAction) show_in_finder: (id) sender {
    NSURL *fileURL = [NSURL fileURLWithPath: [transfer_filename stringValue]];
    NSArray *arr = [NSArray arrayWithObject:fileURL];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:arr];
}

- (IBAction) closeTransfer:(id)sender {
    [transfer_win orderOut: self];
}

@end

void ListenOutput(const char *logoutput) {
    NSTextView *sv = [controller text_view];
    NSString *value = [[sv textStorage] string];
    NSString *newValue = [[NSString alloc] initWithFormat: @"%@\n%s", value, logoutput];
    [sv setString: newValue];
    [sv scrollRangeToVisible:NSMakeRange([[sv string] length], 0)];
    [newValue release];
}



