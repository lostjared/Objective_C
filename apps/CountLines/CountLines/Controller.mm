//
//  Controller.m
//  CountLines
//
//  Created by Jared Bruni on 9/27/18.
//  Copyright © 2018 Jared Bruni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"Controller.h"

@implementation Controller

@synthesize text_output;
@synthesize string_value;
@synthesize progress;
@synthesize text_field;

- (IBAction) scanFiles: (id) sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    [panel setCanCreateDirectories:NO];
    if([panel runModal]) {
        self.string_value = [[panel URL] path];
        value_thread  = [[NSThread alloc] initWithTarget:self selector:@selector(threadProc:) object:nil];
        [progress setMaxValue: 1];
        [progress setMinValue: 0];
        [progress setHidden: NO];
        [progress startAnimation:self];
        [value_thread start];
    }
}

- (void) threadProc: (id) sender {
    __block std::string value;
    value = procLines(text_field, [self.string_value UTF8String]);
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSString *val = [NSString stringWithUTF8String: value.c_str()];
        [self.text_output setString: val];
        [self.progress stopAnimation:self];
        [self.progress setHidden: YES];
    });
}

@end
