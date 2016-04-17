//
//  AppController.h
//  iReadFast
//
//  Created by Jared Bruni on 8/10/10.
//  Copyright 2010 LostSideDead All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppController : NSObject {
	IBOutlet NSTextField *source_data;
	IBOutlet NSSlider *slide;
	IBOutlet NSTextField *label;
	IBOutlet NSTextField *reading;
	IBOutlet NSTextField *num_words;
	IBOutlet NSWindow *win;
	NSArray *arr;
	int word_index;
	NSTimer *timer;
}

- (IBAction) runReader: (id) sender;
- (void) updateWord;
- (void) timerExec;
- (IBAction) stopTimer: (id) sender;

@end
