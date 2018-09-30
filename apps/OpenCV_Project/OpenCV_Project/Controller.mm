
#include "Controller.h"


@implementation Controller

- (IBAction) loadInfo: (id) sender {
    std::string val = cv::getBuildInformation();
    [view1 setString: [NSString stringWithUTF8String:val.c_str()]];
    cv::VideoWriter writer;
}

- (void) awakeFromNib {
    [self loadInfo: self];
}

@end

