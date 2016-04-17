//
//  AppController.m
//  AfGui
//
//  Created by Jared Bruni on 7/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "af.h"
#import "blend.h"

@implementation AppController


- (id) init {

	[super init];

	views = [[NSMutableArray alloc] init];
	NSViewController *fvc;
	fvc = [[af alloc] init];
	[views addObject: fvc];
	[fvc release];
	fvc = [[blending alloc] init];
	[views addObject: fvc];
	[fvc release];
	
	return self;
	
}

- (void) awakeFromNib {
	
	/*
	NSMenu *menu = [pop menu];
	int i,cnt;
	
	cnt = [views count];
	for(i = 0; i < cnt; i++) {
		
		NSViewController *vc = [views objectAtIndex: i];
		NSMenuItem *mi = [[NSMenuItem alloc] initWithTitle:[vc title] action:@selector(changeViewController:) keyEquivalent:@""];
		[mi setTag: i];
		[mi setEnabled:YES];
		[menu addItem: mi];
		[mi release];
		
	}*/
	
	[self changeViewController: self];
	
	
}

- (void) dealloc {
	[views release];
	[super dealloc];
}

- (IBAction) runFilter: (id) sender {

	

}


- (IBAction) changeViewController: (id) sender {
	
	int i = [pop indexOfSelectedItem];
	NSWindow *w = [box window];
	BOOL end = [w makeFirstResponder:w];
	if(!end) {
		NSLog(@"error");
		return;
	}
	NSViewController *vc;	
	if(i >= 0 && i < [views count]) {
		vc = [views objectAtIndex: i];
		[box setContentView: [vc view]];
	}
}


@end
