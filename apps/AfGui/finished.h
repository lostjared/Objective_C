//
//  finsihed.h
//  AfGui
//
//  Created by Jared Bruni on 7/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface finished : NSWindow {
	
}

@end


@interface finished_view : NSView {
	NSImage *image;
	
}
- (void) setImage: (NSImage *)i;
@end


@interface finished_controller : NSObject {
	IBOutlet finished_view *fin_view;
	IBOutlet finished *win;
	NSString *path;
}

- (IBAction) openImageFile: (id) sender;
- (IBAction) dismiss: (id) sender;
- (finished_view*) viewObject;
- (void) setImagePath: (NSString *) str;

@end