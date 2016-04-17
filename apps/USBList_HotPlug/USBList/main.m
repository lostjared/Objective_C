//
//  main.c
//  USBList


#include <CoreFoundation/CoreFoundation.h>
#include <IOKit/IOKitLib.h>


void addedDevice(void *refCon, io_iterator_t iterator) {
    io_service_t service = 0;
    
    while((service = IOIteratorNext(iterator)) != 0) {
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
}

int main(int argc, const char * argv[])
{
    CFDictionaryRef matching = NULL;
    io_iterator_t iter = 0;
    kern_return_t kr;
    IONotificationPortRef notification_port;
    CFRunLoopSourceRef runloopsrc;
    
    
    matching = IOServiceMatching("IOUSBDevice");
    
    notification_port = IONotificationPortCreate(kIOMasterPortDefault);
    runloopsrc = IONotificationPortGetRunLoopSource(notification_port);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runloopsrc, kCFRunLoopDefaultMode);
    
    kr = IOServiceAddMatchingNotification(notification_port, kIOFirstMatchNotification, matching, addedDevice, NULL, &iter);
    addedDevice(NULL, iter);
    
    CFRunLoopRun();
    
    IONotificationPortDestroy(notification_port);
    IOObjectRelease(iter);
    

    
    return 0;
}

