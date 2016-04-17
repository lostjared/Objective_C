//
//  AppDelegate.m
//  WhiteBoard
//
//  Created by Jared Bruni on 9/9/14.
//  Copyright (c) 2014 Jared Bruni. All rights reserved.
//

#import "AppDelegate.h"

NSTask *task1, *task2;

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction) runListenProgram: (id) sender {
    task1 = [[NSTask alloc] init];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *aft = [bundle pathForResource:@"whiteboard" ofType:nil];
    NSString *listen_port = [port_listen stringValue];
    NSArray *args = [NSArray arrayWithObjects:listen_port,nil];
    [task1 setLaunchPath:aft];
    [task1 setArguments:args];
    NSPipe *op = [[NSPipe alloc] init];
    [task1 setStandardOutput:op];
    [task1 launch];
    
}
- (IBAction) runConnectProgram: (id) sender {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *aft = [bundle pathForResource:@"whiteboard" ofType:nil];
    task2 = [[NSTask alloc] init];
    NSString *listen_port = [port_connect stringValue];
    NSString *ip_address = [ip_connect stringValue];
    NSArray *args = [NSArray arrayWithObjects:ip_address, listen_port,nil];
    [task2 setLaunchPath:aft];
    [task2 setArguments:args];
    NSPipe *op = [[NSPipe alloc] init];
    [task2 setStandardOutput:op];
    [task2 launch];
}

@end
