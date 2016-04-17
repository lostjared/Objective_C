//
//  AppController.h
//  iSpeedRead
//
//  Created by Jared Bruni on 3/8/14.
//  Copyright (c) 2014 Jared Bruni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject {

    IBOutlet NSTextView *t_view;
    IBOutlet NSSlider *t_slider;
    IBOutlet NSTextField *t_word, *t_display, *t_wordnum;
    IBOutlet NSWindow *display_win;
    IBOutlet NSButton *start_button;
    NSTimer *program_timer;
    NSArray *words;
    NSInteger index;
}

- (IBAction) startDisplay: (id) sender;
- (IBAction) setWords: (id) sender;
- (IBAction) programTimer: (id) sender;

@end
