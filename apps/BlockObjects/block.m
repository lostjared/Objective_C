#import<Cocoa/Cocoa.h>


typedef void (^BlockNum)();
void PassToFunction(BlockNum num);

@interface O : NSObject {
    NSString *value;
}

- (id) init;
- (void) dealloc;
- (void) setV: (NSString *)s;
- (void) proc: (BlockNum) num;
@end

@implementation O

- (void) setV: (NSString *)s {
    value = [s retain];
}

- (void) proc: (BlockNum) num {
    num();
}

- (id) init {
    self = [super init];
    return self;
}

- (void) dealloc {
    [value release];
    [super dealloc];
}

@end

int main(int argc, char **argv) {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    void (^BlockOne)(NSString *) = ^(NSString *s) {
        NSLog(@"Value: %@", s);
    };
    
    BlockNum num = ^ {
        static int called=0;
        NSLog(@"called : %d",++called);
    };
    
    BlockOne(@"Hello World");
    PassToFunction(num);
    
    O *o = [[[O alloc] init] autorelease];
    [o setV:@"hello world"];
    [o proc:num];
    [pool drain];
    return 0;
}

void PassToFunction(BlockNum num) {
    int i;
    for(i = 0; i < 10; ++i) num();
}