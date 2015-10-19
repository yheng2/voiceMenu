//
//  compareVoice.h
//  AudioMenu
//
//  Created by Wufei Lai on 10/16/15.
//  Copyright © 2015 Yiwei Heng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface compareVoice : NSObject

+ (double)compareVoiceFirstAudioURL:(NSURL *)audioURL1 secondAudio:(NSURL *)audioURL2;

@end
