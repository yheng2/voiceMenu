//
//  compareVoice.m
//  AudioMenu
//
//  Created by Wufei Lai on 10/16/15.
//  Copyright © 2015 Yiwei Heng. All rights reserved.
//

#import "compareVoice.h"
#import <AVFoundation/AVFoundation.h>
#include <Accelerate/Accelerate.h>

@implementation compareVoice


static compareVoice *shiftModel;
+ (id) s {
    if (shiftModel == nil)
        shiftModel = [[self alloc] init];
    return shiftModel;
    
}

+ (double)compareVoiceFirstAudioURL:(NSURL *)audioURL1 secondAudio:(NSURL *)audioURL2{

    if (audioURL1 == nil || audioURL2 == nil) {
        
        NSLog(@"%@", @"One of the audio files is nil");
        return DBL_MIN;
        
    }
    
    //    Record *longerRecord = myRecord.rDuration.floatValue > newRecord.rDuration.floatValue ? myRecord : newRecord;
    //
    //    //[self changeSampleRate:[H getURLFromString:longerRecord.rFileName]];
    //
    //    Record *shorterRecord = myRecord.rDuration.floatValue <= newRecord.rDuration.floatValue ? myRecord : newRecord;
    //
    
    //load first audio
    NSError *er = nil;
    AVAudioFile *myAudioFile1 = [[AVAudioFile alloc] initForReading:audioURL1 error:&er];
    if (er) {
        NSLog(@"%@", er.localizedDescription);
        return DBL_MIN;
    }
    
    
    
    
    
    //load second audio
    er = nil;
    AVAudioFile *myAudioFile2 = [[AVAudioFile alloc] initForReading:audioURL2 error:&er];
    if (er) {
        NSLog(@"%@", er.localizedDescription);
        return DBL_MIN;
    }
    
    
    
    //we compare longer audio against the shorter audio
    if (myAudioFile2.length / myAudioFile2.processingFormat.sampleRate > myAudioFile1.length / myAudioFile1.processingFormat.sampleRate) {
        
        AVAudioFile *t = myAudioFile1;
        myAudioFile1 = myAudioFile2;
        myAudioFile2 = t;
        
    }
    
    
    AVAudioFormat *myAudioFormat1 = myAudioFile1.processingFormat;
    UInt32 myAudioFrameCount1 = (UInt32)myAudioFile1.length - 1;
    
    AVAudioPCMBuffer *myAudioBuffer1 = [[AVAudioPCMBuffer alloc] initWithPCMFormat:myAudioFormat1 frameCapacity:myAudioFrameCount1];
    
    
    
    AVAudioFormat *myAudioFormat2 = myAudioFile2.processingFormat;
    UInt32 myAudioFrameCount2 = (UInt32)myAudioFile2.length - 1;
    AVAudioPCMBuffer *myAudioBuffer2 = [[AVAudioPCMBuffer alloc] initWithPCMFormat:myAudioFormat2 frameCapacity:myAudioFrameCount2];
    
    
    
    //check the sampleRate of two audioFormat
    
    if (myAudioFormat1.sampleRate != myAudioFormat2.sampleRate) {
        
        NSLog(@"%@", @"Sample rate needs to be equal");
        return DBL_MIN;
    }
    int workingFrequency =0;
    workingFrequency = myAudioFormat1.sampleRate;
    
    ///////////////
    
    //er = nil;
    [myAudioFile1 readIntoBuffer:myAudioBuffer1 error:&er];
    if (er) {
        NSLog(@"%@", er.localizedDescription);
        return DBL_MIN;
    }
    
//    float *audioSample1;
//    audioSample1=(float*)malloc(myAudioFrameCount1*sizeof(float));
//    audioSample1=myAudioBuffer1.floatChannelData[0];
    
    
    
    float *audioSample1 = myAudioBuffer1.floatChannelData[0];
    NSLog(@"%.20f",audioSample1[20000]);
    
    int bufferSize1 = myAudioBuffer1.frameLength;
    
    //NSLog(@"audioSample1[50000] is %.20f", audioSample1[50000]);
    
    //er = nil;
    [myAudioFile2 readIntoBuffer:myAudioBuffer2 error:&er];
    if (er) {
        NSLog(@"%@", er.localizedDescription);
        return DBL_MIN;
    }
    
    
    
    float *audioSample2 = myAudioBuffer2.floatChannelData[0];
    int bufferSize2 = myAudioBuffer2.frameLength;
    //////////////////////
    
#define CUT_DOWN 50
    
    int buffer1PaddingCount = 0;
    while (audioSample1[buffer1PaddingCount] == 0 && buffer1PaddingCount < bufferSize1){
        ++buffer1PaddingCount;
    }
    
    //NSLog(@"buffer1PaddingCount is %d", buffer1PaddingCount);
    
    
    
    int bufferSize1WithoutPadding = 0;
    bufferSize1WithoutPadding = (bufferSize1 - buffer1PaddingCount) / CUT_DOWN;
    
    
    
    
    int buffer2PaddingCount = 0;
    while (audioSample2[buffer2PaddingCount] == 0 && buffer2PaddingCount < bufferSize2){
        
        ++buffer2PaddingCount;
    }
    
    NSLog(@"%.20f",audioSample1[20000]);
    
    
    //NSLog(@"buffer2PaddingCount is %d", buffer2PaddingCount);
    
    
    int bufferSize2WithoutPadding = 0;
    bufferSize2WithoutPadding = (bufferSize2 - buffer2PaddingCount) / CUT_DOWN;
    
    NSLog(@"%.20f",audioSample1[20000]);
    
    //myAudioBuffer1 = nil;
    //myAudioBuffer2 = nil;
    
    NSLog(@"%.20f",audioSample1[20000]);
    
    float *signal, *filter, *result;
    uint32_t signalLength, filterLength, resultLength1;
    uint32_t i;
    
    NSLog(@"%.20f",audioSample1[20000]);
    //signal = nil;
    //result = nil;
    
    signalLength = 0;
    filterLength = 0;
    resultLength1 = 0;
    
    NSLog(@"%.20f",audioSample1[20000]);
    
    signalLength = bufferSize1WithoutPadding + bufferSize2WithoutPadding * 2 +1;
    filterLength = bufferSize2WithoutPadding;
    resultLength1 = bufferSize1WithoutPadding + bufferSize2WithoutPadding;
    signal = (float*) malloc(signalLength * sizeof(float));
    filter = (float*) malloc(filterLength * sizeof(float));
    result = (float*) malloc(resultLength1 * sizeof(float));
    
    NSLog(@"%.20f",audioSample1[20000]);
    
    //memset(signal, 0, bufferSize2WithoutPadding);
    //memset(filter, 0, filterLength * sizeof(float));
    //memset(result, 0, resultLength1 * sizeof(float));
    
    double total1, total2, mean1, mean2, deviation1,deviation2, sd1, sd2, corr;
    
    total1 = 0.0;
    total2 = 0.0;
    mean1 = 0.0;
    mean2 =0.0;
    deviation1 = 0.0;
    deviation2 = 0.0;
    sd1 = 0.0;
    sd2 = 0.0;
    corr = 0.0;
    
    if (bufferSize1WithoutPadding == bufferSize2WithoutPadding) {
        NSLog(@"bufferSize1 = bufferSize2");
    }
    
    NSLog(@"%.20f",audioSample1[20000]);
    
    for (i=0; i < bufferSize1WithoutPadding; i++) {
//        int j=i+bufferSize2WithoutPadding;
//        int k=i * CUT_DOWN + buffer1PaddingCount;
        
        float sample=audioSample1[i * CUT_DOWN + buffer1PaddingCount];
        signal[i+bufferSize2WithoutPadding]=sample;
        
//        signal[j] = audioSample1[k];
        //signal[j] = 0.1;
        
        
        //NSLog(@"signal%d is %.20f",i, signal[i]);
        
        total1 = total1 + fabs(signal[i + bufferSize2WithoutPadding]);
        
        
    }
    //NSLog(@"signal[1000] = %.20f", signal[1000]);
    
    
    //NSLog(@"total1 is %.20f", total1);
    mean1 = total1 / bufferSize1WithoutPadding;
    //NSLog(@"mean1 is %.20f", mean1);
    
    
    for (i=0; i < bufferSize1WithoutPadding; i++) {
        
        deviation1 = deviation1 + (signal[i + bufferSize2WithoutPadding] - mean1) * (signal[i + bufferSize2WithoutPadding] - mean1);
        
    }
    sd1 = sqrt(deviation1 / bufferSize1WithoutPadding );
    
    //NSLog(@"sd1 is %.20f", sd1);
    
    
    
    for (i=0; i < bufferSize2WithoutPadding; i++) {
        
        
        filter[i] = audioSample2[i * CUT_DOWN + buffer2PaddingCount ];
         //filter[i] = 0.1;
        
        //NSLog(@"filter%d is %.20f",i, filter[i]);
        total2 = total2 + fabs(filter[i]);
        
        
    }
    
    //NSLog(@"filter[1000] = %.20f", filter[1000]);
    
    //NSLog(@"total2 is %.20f", total2);
    mean2 = total2 / bufferSize2WithoutPadding;
    //NSLog(@"mean2 is %.20f", mean2);
    
    for (i=0; i < bufferSize2WithoutPadding; i++) {
        
        deviation2 = deviation2 + (filter[i] - mean2) * (filter[i] - mean2);
        
    }
    sd2 = sqrt( deviation2 / bufferSize2WithoutPadding );
    
    //NSLog(@"sd2 is %.20f", sd2);
    
    
    //NSLog(@"resultLength is %d; filterLength is %d", resultLength1, filterLength);
    
    vDSP_conv(signal, 1, filter, 1, result, 1, resultLength1, filterLength);
    
    
    float max = FLT_MIN;
    int maxIndex = 0;
    for (int i = 0; i < resultLength1; i++) {
        
        if (fabs(result[i]) > max) {
            max = result[i];
            maxIndex = i;
        }
    }
    
    
    
    
    signal = nil;
    filter = nil;
    result = nil;
    resultLength1 = 0;
    
    
    if(signal == nil){
        
        // NSLog(@"free success");
        
    }
    
    corr = (max - bufferSize2WithoutPadding * mean1 * mean2 )/( bufferSize2WithoutPadding * sd1 * sd2);
    NSLog(@"!!!!!correlation is %.20f", corr);
    
    
    //double timeShift = (float)(maxIndex - bufferSize2WithoutPadding + buffer2PaddingCount / CUT_DOWN) / (workingFrequency / CUT_DOWN);
    
    
    //NSLog(@"The biggest match is %@ at the position: %@", @(max),@(maxIndex) );
    //NSLog(@"Time shift is: %@ seconds", @(timeShift));
    
    max = 0.0;
    
    
    return corr;


}

@end
