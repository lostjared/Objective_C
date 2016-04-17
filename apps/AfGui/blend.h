//
//  blend.h
//  AfGui
//
//  Created by Jared Bruni on 7/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface blending : NSViewController {

}

@end


@interface blendController : NSObject {

	IBOutlet NSTextField *input;

}

- (IBAction) execCommand: (id) sender;

@end