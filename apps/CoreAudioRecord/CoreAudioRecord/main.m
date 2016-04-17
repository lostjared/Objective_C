//
//  main.m
//  CoreAudioRecord
//  from the Book "Learning Core Audio"
//  Created by Jared Bruni on 10/6/13.
//  Copyright (c) 2013 Jared Bruni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

const int kNumberRecordBuffers = 3;


typedef struct Recorder {
    AudioFileID recordFile;
    SInt64 recordPacket;
    Boolean running;
} Recorder;

void CopyEncoderCookieToFile(AudioQueueRef queue, AudioFileID theFile);
void Error(OSStatus error, const char *operation);
OSStatus GetDefaultInputDeviceSampleRate(Float64 *outSampleRate);

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

OSStatus GetDefaultInputDeviceSampleRate(Float64 *outSampleRate) {
    OSStatus error;
    AudioDeviceID deviceID = 0;
    AudioObjectPropertyAddress propAddress;
    UInt32 propertySize;
    propAddress.mSelector = kAudioHardwarePropertyDefaultInputDevice;
    propAddress.mScope = kAudioObjectPropertyScopeGlobal;
    propAddress.mElement = 0;
    propertySize = sizeof(AudioDeviceID);
    error = AudioHardwareServiceGetPropertyData(kAudioObjectSystemObject, &propAddress, 0, NULL, &propertySize, &deviceID);
    
    if(error) return error;
    propAddress.mSelector = kAudioDevicePropertyNominalSampleRate;
    propAddress.mScope = kAudioObjectPropertyScopeGlobal;
    propAddress.mElement = 0;
    propertySize = sizeof(Float64);
    error = AudioHardwareServiceGetPropertyData(deviceID, &propAddress, 0, NULL, &propertySize, outSampleRate);
    return error;
}


void CopyEncoderCookieToFile(AudioQueueRef queue, AudioFileID theFile) {

    OSStatus error; UInt32 propertySize;
    error = AudioQueueGetPropertySize(queue, kAudioConverterCompressionMagicCookie,&propertySize);
    if (error == noErr && propertySize > 0)
    {
        Byte *magicCookie = (Byte *)malloc(propertySize);
        Error(AudioQueueGetProperty(queue, kAudioQueueProperty_MagicCookie, magicCookie,&propertySize),"Couldn't get audio queue's magic cookie");
        Error(AudioFileSetProperty(theFile, kAudioFilePropertyMagicCookieData, propertySize,magicCookie), "Couldn't set audio file's magic cookie");
                                                                
        free(magicCookie);
    }
}

int ComputeRecordBufferSize(const AudioStreamBasicDescription *format, AudioQueueRef queue, float seconds) {
    int packets, frames, bytes;
    frames = (int) ceil(seconds * format->mSampleRate);
    if(format->mBytesPerFrame > 0)
        bytes = frames * format->mBytesPerFrame;
    else {
        UInt32 maxPacketSize;
        if(format->mBytesPerPacket > 0)
            maxPacketSize = format->mBytesPerPacket;
        else {
            UInt32 propertySize = sizeof(maxPacketSize);
            Error(AudioQueueGetProperty(queue, kAudioConverterPropertyMaximumOutputPacketSize, &maxPacketSize, &propertySize), "Could not get queue's maximum output packet size");
        }
        if(format->mFramesPerPacket > 0)
            packets = frames / format->mFramesPerPacket;
        else
            packets = frames;
        
        if(packets == 0)
            packets = 1;
        
        bytes = packets * maxPacketSize;
    }

    return bytes;
}


void InputCallback(void *userData, AudioQueueRef inque, AudioQueueBufferRef inbuf, const AudioTimeStamp *startTime,
                   UInt32 numPackets, const AudioStreamPacketDescription *inpacket) {
    Recorder *recorder = (Recorder *)userData;
    if(numPackets > 0) {
        Error(AudioFileWritePackets(recorder->recordFile, FALSE,inbuf->mAudioDataByteSize, inpacket, recorder->recordPacket, &numPackets, inbuf->mAudioData), "AudioFileWrite Packets Failed");
    
        recorder->recordPacket += numPackets;
    }
    
    if(recorder->running) {
        Error(AudioQueueEnqueueBuffer(inque, inbuf, 0, NULL), "AudioQeueEnqueueBuffer Failed");
    }
}

int main(int argc, char * argv[])
{

    @autoreleasepool {
        
        
        NSLog(@"Record audio.\n");
        Recorder recorder = {0};
        AudioStreamBasicDescription recordFormat;
        memset(&recordFormat, 0, sizeof(recordFormat));
        recordFormat.mFormatID = kAudioFormatMPEG4AAC;
        recordFormat.mChannelsPerFrame = 2;
        GetDefaultInputDeviceSampleRate(&recordFormat.mSampleRate);
        UInt32  propSize = sizeof(recordFormat);
        Error(AudioFormatGetProperty(kAudioFormatProperty_FormatInfo, 0, NULL, &propSize, &recordFormat), "Audio Format get property failed");
        AudioQueueRef queue = {0};
        Error(AudioQueueNewInput(&recordFormat, InputCallback, &recorder, NULL, NULL, 0, &queue), "AudioQueueNewInput failed");
        UInt32 size = sizeof(recordFormat);
        Error(AudioQueueGetProperty(queue, kAudioConverterCurrentOutputStreamDescription, &recordFormat, &size), "Could not get queue format");
        
        CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, CFSTR("output.caf"), kCFURLPOSIXPathStyle, false);
        
        Error(AudioFileCreateWithURL(fileURL,kAudioFileCAFType, &recordFormat, kAudioFileFlags_EraseFile, &recorder.recordFile), "AUdioFileCreateWithURL Failed");
        CFRelease(fileURL);
        CopyEncoderCookieToFile(queue, recorder.recordFile);

        int bufferByteSize = ComputeRecordBufferSize(&recordFormat, queue, 0.5);
        for(int i = 0; i < kNumberRecordBuffers; ++i) {
            
            AudioQueueBufferRef buffer;
            Error(AudioQueueAllocateBuffer(queue, bufferByteSize, &buffer), "AudioQueueAllocateBuffer failed.");
            Error(AudioQueueEnqueueBuffer(queue, buffer, 0, NULL), "AUdioQueueEnqueueBuffer failed");
        }

        recorder.running = TRUE;
        Error(AudioQueueStart(queue, NULL), "AudioQueueStart failed.");
        printf("Recording press enter to stop.");
        getchar();
        printf("Recording stopped.\n");
        recorder.running = FALSE;
        Error(AudioQueueStop(queue, TRUE), "AudioQueueStop failed");
        CopyEncoderCookieToFile(queue, recorder.recordFile);
        AudioQueueDispose(queue, TRUE);
        AudioFileClose(recorder.recordFile);
        
    }
    return 0;
}

