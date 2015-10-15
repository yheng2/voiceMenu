//
//  InputView.h
//  AudioMenu
//
//  Created by Yiwei Heng on 10/4/15.
//  Copyright (c) 2015 Yiwei Heng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface InputView : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>


@property AVAudioRecorder *recorder;
@property AVAudioPlayer *player;

@property (weak, nonatomic) IBOutlet UITextField *inputText;

- (IBAction)okTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *inputLabel;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

- (IBAction)recordTapped:(id)sender;

- (IBAction)stopTapped:(id)sender;

- (IBAction)playTapped:(id)sender;

- (IBAction)confirmTapped:(id)sender;



@property NSManagedObjectContext* context;
@property NSManagedObject* object;




@end
