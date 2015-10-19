//
//  home.h
//  AudioMenu
//
//  Created by Wufei Lai on 10/11/15.
//  Copyright © 2015 Yiwei Heng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ApiAI/UIKit/AIVoiceRequestButton.h>
#import <AVFoundation/AVFoundation.h>

@interface home : UIViewController<UITextFieldDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate>
- (IBAction)okButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)startButton:(id)sender;

@property BOOL isStarted;

@property (weak, nonatomic) IBOutlet UIButton *startStatus;

@property (weak, nonatomic) IBOutlet UISwitch *swichChoose;

//- (IBAction)play:(id)sender;

@property AVAudioPlayer *player;
@property AVAudioRecorder *recorder;
@property NSURL *inputFileURL;

@end
