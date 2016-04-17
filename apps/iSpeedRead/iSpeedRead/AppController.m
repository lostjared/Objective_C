//
//  AppController.m
//  iSpeedRead
//
//  Created by Jared Bruni on 3/8/14.
//  Copyright (c) 2014 Jared Bruni. All rights reserved.
//

#import "AppController.h"

@implementation AppController


- (IBAction) startDisplay: (id) sender {
    NSString *text = [start_button title];
    if([text compare:@"Start"] == NSOrderedSame) {
        index = 0;
        [start_button setTitle:@"Stop"];
        [display_win setLevel: NSStatusWindowLevel];
        [display_win orderFront: self];
        NSInteger speed = [t_slider integerValue];
        float wpm = 60.0f/speed;
        NSString *value = [[t_view textStorage] string];
        words = [value componentsSeparatedByString:@" "];
        program_timer = [NSTimer scheduledTimerWithTimeInterval:wpm target:self selector:@selector(programTimer:) userInfo:nil repeats:YES];
        [t_display setStringValue: @"Ready ..."];
    }
    else {
        [display_win orderOut: self];
        [start_button setTitle:@"Start"];
        [program_timer invalidate];
        index = 0;
    }
}

- (IBAction) setWords: (id) sender {
    NSInteger xwords = [t_slider integerValue];
    NSString *t = [NSString stringWithFormat:@"%d Words Per Minute", (unsigned int)xwords];
    [t_word setStringValue:t];
}

- (IBAction) programTimer: (id) sender {
    
    if(index+1 > [words count]) {
        [t_display setStringValue:@"Done! "];
        NSString *t = [NSString stringWithFormat:@"You read %d Words", (unsigned int)index];
        [t_wordnum setStringValue: t];
        [program_timer invalidate];
        [start_button setTitle: @"Start"];
        index = 0;
        return;
    } else {
        NSString *current = [words objectAtIndex: index];
        [t_display setStringValue: current];
        NSString *text = [NSString stringWithFormat:@"Word Number: %d", (unsigned int)index+1];
        [t_wordnum setStringValue: text];
        ++index;
    }

}

@end
