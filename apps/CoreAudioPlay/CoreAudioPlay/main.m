//
//  main.m
//  CoreAudioPlay
//
//  Created by Jared Bruni on 10/7/13.
//  from the book "Learning Core Audio ".
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>


typedef struct _Player {
    AudioFileID playbackFile;
    SInt64 packetPosition;
    UInt32 numPacketsToRead;
    AudioStreamPacketDescription *packetDesc;
    Boolean isDone;
} Player;

void Error(OSStatus error, const char *operation) {
    if(error == noErr) return;
    char errorString[20];
    *(UInt32 *)(errorString +1) = CFSwapInt32HostToBig(error);
    if(isprint(errorString[1]) && isprint(errorString[2]) && isprint(errorString[3]) && isprint(errorString[4])) {
        errorString[0] = errorString[5] = '\'';
        errorString[6] = '\0';
    } else {
        sprintf(errorString, "%d", (int) error);
        fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
        exit(-1);
    }
}

void CopyEncoderCookieToQueue(AudioFileID theFile, AudioQueueRef queue) {
    
    UInt32 propertySize;
    OSStatus result = AudioFileGetPropertyInfo(theFile, kAudioFilePropertyMagicCookieData, &propertySize, NULL);
    if(result == noErr && propertySize > 0) {
        Byte *magicCookie = (UInt8 *)malloc(sizeof(UInt8) * propertySize);
        Error(AudioFileGetProperty(theFile, kAudioFilePropertyMagicCookieData, &propertySize, magicCookie), "Get cookie failed\n");
        Error(AudioQueueSetProperty(queue, kAudioQueueProperty_MagicCookie, magicCookie, propertySize), "Set cookie on queue failed");
        free(magicCookie);
    }
}

void CalculateBytesForTime(AudioFileID inAudioFile, AudioStreamBasicDescription inDesc, Float64 inSeconds, UInt32 *outBufferSize, UInt32 *outNumPackets) {
    UInt32 maxPacketSize;
    UInt32 propSize = sizeof(maxPacketSize);
    Error(AudioFileGetProperty(inAudioFile, kAudioFilePropertyPacketSizeUpperBound, &propSize, &maxPacketSize), "Could not get max packet size");
    static const int maxBufferSize = 0x10000, minBufferSize = 0x4000;
    if(inDesc.mFramesPerPacket) {
        Float64 numPacketsForTime = inDesc.mSampleRate / inDesc.mFramesPerPacket * inSeconds;
        *outBufferSize = numPacketsForTime * maxPacketSize;
    }
    else {
        *outBufferSize = (maxBufferSize > maxPacketSize) ? maxBufferSize : maxPacketSize;
    }
    if(*outBufferSize > maxBufferSize && *outBufferSize > maxPacketSize)
        *outBufferSize = maxBufferSize;
    else {
        if(*outBufferSize < minBufferSize)
            *outBufferSize = minBufferSize;
    }
    *outNumPackets = *outBufferSize / maxPacketSize;
}

void OutputCallback(void *data, AudioQueueRef inAQ, AudioQueueBufferRef inCompleteAQBuffer) {
    Player *player = (Player*)data;
    if(player->isDone) return;
    UInt32 numBytes;
    UInt32 nPackets = player->numPacketsToRead;
    Error(AudioFileReadPackets(player->playbackFile, false, &numBytes, player->packetDesc, player->packetPosition, &nPackets, inCompleteAQBuffer->mAudioData), "AUdioFIleReadPackets failed.!\n");
    
    if(nPackets > 0) {
        inCompleteAQBuffer->mAudioDataByteSize = numBytes;
        AudioQueueEnqueueBuffer(inAQ, inCompleteAQBuffer, (player->packetDesc) ? nPackets : 0, player->packetDesc);
        player->packetPosition += nPackets;
    } else {
        Error(AudioQueueStop(inAQ, false),"AudioQueueSTop failed\n");
        player->isDone = true;
    }
}

int main(int argc,char * argv[])
{
    @autoreleasepool {
        if(argc != 2) {
            fprintf(stderr, "Error program takes 1 argument.\n");
            return 1;
        }
        Player player = {0};
        CFStringRef str;
        char *bytes;
        bytes = CFAllocatorAllocate(CFAllocatorGetDefault(), strlen(argv[1]), 0);
        strcpy(bytes, argv[1]);
        str = CFStringCreateWithCStringNoCopy(NULL,bytes,kCFStringEncodingMacRoman,NULL);
        CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, str, kCFURLPOSIXPathStyle,false);
        Error(AudioFileOpenURL(fileURL, kAudioFileReadPermission, 0, &player.playbackFile), "Audio Open Failed");
        CFRelease(fileURL);
        CFRelease(str);
        AudioStreamBasicDescription dataFormat;
        UInt32 propSize = sizeof(dataFormat);
        Error(AudioFileGetProperty(player.playbackFile, kAudioFilePropertyDataFormat, &propSize, &dataFormat), "Could not get data format.\n");
        AudioQueueRef queue;
        Error(AudioQueueNewOutput(&dataFormat, OutputCallback, &player, NULL, NULL, 0, &queue), "New queue failed.\n");
        UInt32 bufferSize;
        CalculateBytesForTime(player.playbackFile, dataFormat, 0.5, &bufferSize,&player.numPacketsToRead);
        bool isFormatVBR = (dataFormat.mBytesPerPacket == 0 || dataFormat.mFramesPerPacket == 0);
        if(isFormatVBR)
            player.packetDesc = (AudioStreamPacketDescription*)malloc(sizeof(AudioStreamPacketDescription) * player.numPacketsToRead);
        else
            player.packetDesc = NULL;
        CopyEncoderCookieToQueue(player.playbackFile, queue);
        
        
        AudioQueueBufferRef buffers[3];
        player.isDone = false;
        player.packetPosition = 0;
        int i;
        for(i = 0; i < 3; ++i) {
            Error(AudioQueueAllocateBuffer(queue, bufferSize, &buffers[i]), "Queue buffer failed.\n");
            OutputCallback(&player, queue, buffers[i]);
            if(player.isDone)
                break;
        }
        
        Error(AudioQueueStart(queue,NULL), "Start queue failed.\n");
        NSLog(@"Playing..\n");
        do {
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.25, false);
        } while(!player.isDone);
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 2, false);
        
        player.isDone = true;
        Error(AudioQueueStop(queue,TRUE), "AudioQueueStop failed");
        AudioQueueDispose(queue, TRUE);
        AudioFileClose(player.playbackFile);
    }
    return 0;
}

