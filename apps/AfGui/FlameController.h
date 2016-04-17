//
//  FlameController.h
//  AfGui
//
//  Created by Jared Bruni on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "afView.h"
#import "finished.h"


@interface FlameController : NSObject {
	NSMutableArray *file_v;
	IBOutlet NSTableView *vi;
	IBOutlet NSButton *chk;
	IBOutlet NSSliderCell *slide;
	IBOutlet NSTextFieldCell *label;
	IBOutlet afView *v;
	IBOutlet finished *fin;
	IBOutlet finished_view *fin_v;
	IBOutlet finished_controller *fin_obj;
}

- (IBAction) addFiles: (id) sender;
- (IBAction) rmvFile: (id) sender;
- (IBAction) slidePos: (id) sender;
- (IBAction) runFilter: (id) sender;

@end
