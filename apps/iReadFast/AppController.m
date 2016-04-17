//
//  AppController.m
//  iReadFast
//
//  Created by Jared Bruni on 8/10/10.
//  Copyright 2010 LostSideDead All rights reserved.
//

#import "AppController.h"
#import<string.h>

@implementation AppController

- (id) init {
	self = [super init];
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (IBAction) runReader: (id) sender {
	NSString *str = [source_data stringValue];
	if([str length] == 0) {
		NSRunAlertPanel(@"Nothing there", @"You need to put some text", @"Ok", nil, nil);
		return;
	}
	int speed = [slide integerValue];
	float inter = 0.0f;
	// this is most likely unnessicary
	float val[] = { 1.0f, 1.0f, 0.9f, 0.8f, 0.7f, 0.6f, 0.5f, 0.4f, 0.3f, 0.2f, 0.1f, 0 };
	inter = val[speed];
	
	arr = [[str componentsSeparatedByString:@" "] retain];
	
	word_index = 0;
	[win makeKeyAndOrderFront: self];
	[self updateWord];
	timer = [NSTimer scheduledTimerWithTimeInterval:inter target:self selector:@selector(timerExec) userInfo:NULL repeats:YES];
}

- (void) updateWord {
	NSString *str = [[ NSString alloc] initWithFormat: @"%d/%d", (word_index+1), [arr count], nil];
	[num_words setStringValue: str];
	[str release];
	[reading setStringValue: [arr objectAtIndex: word_index]];
}

- (void) timerExec {
	if(word_index < [arr count]) {
		[self updateWord];
		word_index++;
	} else {
		[timer invalidate];
		[arr release];
		[win close];
	}	
	
}

- (IBAction) stopTimer: (id) sender {
	[timer invalidate];
	[arr release];
	[win close];
}

@end


