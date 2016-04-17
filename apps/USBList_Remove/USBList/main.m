//
//  main.c
//  USBList


#import <CoreFoundation/CoreFoundation.h>
#import <IOKit/IOKitLib.h>
#import <IOKit/IOMessage.h>
typedef struct {
    io_service_t serv;
    io_object_t not;
} driver_data;

IONotificationPortRef notification_port = NULL;

void deviceNotification(void *refCon, io_service_t service, natural_t messageType, void *message) {
    driver_data *my_data = (driver_data*)refCon;
    kern_return_t kr;
    
    if(messageType == kIOMessageServiceIsTerminated) {
        io_name_t name;
        IORegistryEntryGetName(service, name);
        printf("Device was removed: %s\n", name);
        kr = IOObjectRelease(my_data->not);
        IOObjectRelease(my_data->serv);
        free(my_data);
    }
}


void addedDevice(void *refCon, io_iterator_t iterator) {
    io_service_t service = 0;
    
    while((service = IOIteratorNext(iterator)) != 0) {
        driver_data *my_data;
        kern_return_t kr;
        my_data = (driver_data*)malloc(sizeof(driver_data));
        my_data->serv = service;
        kr = IOServiceAddInterestNotification(notification_port, service, kIOGeneralInterest, deviceNotification, my_data, &my_data->not);
    }
}

int main(int argc, const char * argv[])
{
    CFDictionaryRef matching = NULL;
    io_iterator_t iter = 0;
    kern_return_t kr;
    CFRunLoopSourceRef runloopsrc;
    
    printf("Waiting for device to be removed.\n");
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

