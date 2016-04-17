//
//  main.m
//  CoreAudioConverter
//  Adapted From the Book "Learning Core Audio" Chapter 6
//  Created by Jared Bruni on 10/18/13.//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

typedef struct AudioConverterSettings {
    AudioStreamBasicDescription outputFormat;
    ExtAudioFileRef inputFile;
    AudioFileID outputFile;
    
} AudioConverterSettings;

void Error(OSStatus error, const char *operation);
void Convert(AudioConverterSettings *cs);

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if(argc != 2) {
            fprintf(stderr, "Error requires one argument.\n");
            return 1;
        }
        
        AudioConverterSettings audio_set = { 0 };
        CFStringRef str;
        char *bytes;
        bytes = CFAllocatorAllocate(CFAllocatorGetDefault(), strlen(argv[1]), 0);
        strcpy(bytes, argv[1]);
        str = CFStringCreateWithCStringNoCopy(NULL,bytes,kCFStringEncodingMacRoman,NULL);
        CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, str, kCFURLPOSIXPathStyle,false);
        Error(ExtAudioFileOpenURL(fileURL, &audio_set.inputFile), "Could not open input file");
        CFRelease(fileURL);
        CFRelease(str);
        
        audio_set.outputFormat.mSampleRate = 44100.0;
        audio_set.outputFormat.mFormatID = kAudioFormatLinearPCM;
        audio_set.outputFormat.mFormatFlags = kAudioFormatFlagIsBigEndian | kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
        audio_set.outputFormat.mBytesPerPacket = 4;
        audio_set.outputFormat.mFramesPerPacket = 1;
        audio_set.outputFormat.mBytesPerFrame = 4;
        audio_set.outputFormat.mChannelsPerFrame = 2;
        audio_set.outputFormat.mBitsPerChannel = 16;
        
        CFURLRef outputFileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, CFSTR("output.aif"), kCFURLPOSIXPathStyle, false);
        
        Error(AudioFileCreateWithURL(outputFileURL, kAudioFileAIFFType, &audio_set.outputFormat, kAudioFileFlags_EraseFile, &audio_set.outputFile), "File create failed.");
        
        CFRelease(outputFileURL);
        
        Error(ExtAudioFileSetProperty(audio_set.inputFile, kExtAudioFileProperty_ClientDataFormat, sizeof(AudioStreamBasicDescription), &audio_set.outputFormat), "COuld set client data format.");
        
        fprintf(stdout, "Converting ...\n");
        Convert(&audio_set);
        
        ExtAudioFileDispose(audio_set.inputFile);
        AudioFileClose(audio_set.outputFile);
        
    }
    return 0;
}

void Convert(AudioConverterSettings *cs) {
    UInt32 outputBufferSize = 32 * 1024;
    UInt32 sizePerPacket = cs->outputFormat.mBytesPerPacket;
    UInt32 packetsPerBuffer = outputBufferSize/ sizePerPacket;
    UInt8 *outputBuffer = (UInt8 *)malloc( sizeof(UInt8) * outputBufferSize);
    UInt32 outputFilePacketPosition = 0;
    
    while(1) {
        AudioBufferList convertedData;
        convertedData.mNumberBuffers = 1;
        convertedData.mBuffers[0].mNumberChannels = cs->outputFormat.mChannelsPerFrame;
        convertedData.mBuffers[0].mDataByteSize = outputBufferSize;
        convertedData.mBuffers[0].mData = outputBuffer;
        UInt32 frameCount = packetsPerBuffer;
        Error(ExtAudioFileRead(cs->inputFile, &frameCount, &convertedData), "COuld read from input file");
        if(frameCount == 0) {
            printf("Done reading from file.\n");
            return;
        }
        Error(AudioFileWritePackets(cs->outputFile, FALSE, frameCount, NULL, outputFilePacketPosition / cs->outputFormat.mBytesPerPacket, &frameCount, convertedData.mBuffers[0].mData), "Could not write packets!");
        
        outputFilePacketPosition += (frameCount * cs->outputFormat.mBytesPerPacket);
    }
}

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
