//
//  main.c
//  USBList


#include <CoreFoundation/CoreFoundation.h>
#include <IOKit/IOKitLib.h>

int main(int argc, const char * argv[])
{
    CFDictionaryRef matching = NULL;
    io_iterator_t iter = 0;
    io_service_t service = 0;
    kern_return_t kr;
    
    matching = IOServiceMatching("IOUSBDevice");
    
    kr = IOServiceGetMatchingServices(kIOMasterPortDefault, matching, &iter);
    if(kr != KERN_SUCCESS)
        return -1;
    
    while((service = IOIteratorNext(iter)) != 0) {
        CFStringRef clsname;
        io_name_t name;
        
        clsname = IOObjectCopyClass(service);
        if(CFEqual(clsname, CFSTR("IOUSBDevice")) == true) {
            IORegistryEntryGetName(service, name);
            printf("Found a device: %s\n", name);
        }
        
        CFRelease(clsname);
        IOObjectRelease(service);
    }
    
    IOObjectRelease(iter);
    
    return 0;
}

