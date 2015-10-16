//
//  InputView.m
//  AudioMenu
//
//  Created by Yiwei Heng on 10/4/15.
//  Copyright (c) 2015 Yiwei Heng. All rights reserved.
//

#import "InputView.h"
#import "Voice+CoreDataProperties.h"

@interface InputView ()

@property int i;

@end

@implementation InputView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    self.context=[appDelegate managedObjectContext];
    
    
    
    
    //Disable Stop/Play button when application launch
    [self.stopButton setEnabled:NO];
    [self.playButton setEnabled:NO];
    [self.confirmButton setEnabled:NO];
    
    
    

    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)onBackgroungHit:(id)sender {
    
    
    [self.inputText resignFirstResponder];
}

- (IBAction)recordTapped:(id)sender {
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Voice" inManagedObjectContext:self.context];
    request.entity=entity;
    NSArray *array=[self.context executeFetchRequest:request error:nil];
    //NSLog(@"%d",array.count);
    self.i=1;
    for (int x=0; x<array.count; x++) {
        int y=[[array[x] valueForKey:@"nameNumber"] intValue];
        if (self.i==y) {
            self.i+=1;
        }
    }
    NSLog(@"name number is %d",self.i);
    
    
    
    // Set the audio file
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0],[NSString stringWithFormat:@"voice%d.m4a",self.i],nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];

    
    
    // Stop the audio player before recording
    if (self.player.playing) {
        [self.player stop];
    }
    
    if (!self.recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [self.recorder record];
        [self.recordButton setTitle:@"Pause" forState:UIControlStateNormal];
        
    } else {
        
        // Pause recording
        [self.recorder pause];
        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    
    [self.stopButton setEnabled:YES];
    [self.playButton setEnabled:NO];
    
    
    
}

- (IBAction)stopTapped:(id)sender {
    
    
    [self.recorder stop];
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    [self.playButton setEnabled:YES];
    [self.confirmButton setEnabled:YES];

    
    
}

- (IBAction)playTapped:(id)sender {
    
    if (!self.recorder.recording){
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
        [self.player setDelegate:self];
        [self.player play];
    }
    
}

- (IBAction)confirmTapped:(id)sender {

    
    Voice *voi=[NSEntityDescription insertNewObjectForEntityForName:@"Voice" inManagedObjectContext:self.context];
    voi.text=self.inputLabel.text;
    voi.nameNumber=[NSString stringWithFormat:@"%d",self.i];
    NSError *error;
    [self.context save:&error];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
- (IBAction)okTapped:(id)sender {
    self.inputLabel.text=self.inputText.text;
    self.inputText.text=@"";
    
}
@end
