//
//  af.m
//  AfGui
//
//  Created by Jared Bruni on 7/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "af.h"


@implementation af

- (id) init {
	if(![super initWithNibName:@"af" bundle:nil]) {
		NSLog(@"could not load nib af");
		return nil;
	}
	[self setTitle:@"af"];
	return self;	
}



@end
