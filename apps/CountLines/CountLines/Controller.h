//
//  Controller.h
//  CountLines
//
//  Created by Jared Bruni on 9/27/18.
//  Copyright © 2018 Jared Bruni. All rights reserved.
//

#ifndef Controller_h
#define Controller_h

#import<Cocoa/Cocoa.h>
#import"CountLines.hpp"

@interface Controller : NSObject {
    NSThread *value_thread;
}

@property IBOutlet NSTextView *text_output;
@property NSString *string_value;
@property IBOutlet NSProgressIndicator *progress;
- (IBAction) scanFiles: (id) sender;
- (void) threadProc: (id) sender;

@end

#endif /* Controller_h */
