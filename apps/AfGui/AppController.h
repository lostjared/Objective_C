//
//  AppController.h
//  AfGui
//
//  Created by Jared Bruni on 7/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {

	NSMutableArray *views;
	IBOutlet NSBox *box;
	IBOutlet NSPopUpButton *pop;
}

- (IBAction) runFilter: (id) sender;
- (IBAction) changeViewController: (id) sender;

@end
