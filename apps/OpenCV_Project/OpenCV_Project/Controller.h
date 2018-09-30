
#import<Foundation/Foundation.h>
#import<Cocoa/Cocoa.h>
#undef check
#ifdef __APPLE__
#include<opencv2/videoio.hpp>
#include<opencv2/imgproc.hpp>
#include<opencv2/highgui.hpp>
#endif



@interface Controller : NSObject {
    IBOutlet NSButton *button1;
    IBOutlet NSTextView *view1;
}

- (IBAction) loadInfo: (id) sender;

@end

