//
//  blend.m
//  AfGui
//
//  Created by Jared Bruni on 7/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "blend.h"


@implementation blending

- (id) init {
	if(![super initWithNibName:@"blend" bundle:nil]) {
		NSLog(@"failed to load blend.nib");
		return nil;
	}
	[self setTitle:@"blend"];
	return self;
}

@end


@implementation blendController

- (IBAction) execCommand: (id) sender {
	NSString *text = [input stringValue];
	NSString *afPath = [[NSBundle mainBundle] pathForResource:@"aftool" ofType: nil];
	NSString *execString = [NSString stringWithFormat:@"%@ %@", afPath, text];
	if(system([execString UTF8String]) == 0) {
		NSRunAlertPanel(@"Success", execString, @"Ok", nil, nil);
	} else {
		NSRunAlertPanel(@"Failure", @"Check your syntax / image path's are correct", @"Ok", nil, nil);
	}
}


@end

