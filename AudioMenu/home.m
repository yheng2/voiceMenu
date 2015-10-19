//
//  home.m
//  AudioMenu
//
//  Created by Wufei Lai on 10/11/15.
//  Copyright © 2015 Yiwei Heng. All rights reserved.
//

#import "home.h"
#import "homeResultPage.h"
#import <ApiAI/ApiAI.h>
#import <ApiAI/AITextRequest.h>
#import <ApiAI/AIVoiceRequest.h>
#import <ApiAI/AIDefaultConfiguration.h>

#import <MBProgressHUD/MBProgressHUD.h>



#import "AppDelegate.h"
#import "Voice+CoreDataProperties.h"

#import "compareVoice.h"

@interface home ()

@property(nonatomic, strong) ApiAI *openAPI;
@property(nonatomic, strong) AIVoiceRequest *currentVoiceRequest;

@end

@implementation home

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    
    
    self.openAPI = [ApiAI sharedApiAI];
    
    // Define API.AI configuration here.
    id <AIConfiguration> configuration = [[AIDefaultConfiguration alloc] init];
    
    configuration.clientAccessToken = @"566321b64e374fe3acfe740e2285c3ee";
    configuration.subscriptionKey = @"082c1903-8fe3-44d7-a4b7-aa3a17d86a46 ";
    
    self.openAPI.configuration = configuration;
    
    [self changeStateToStop];
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0],@"test.m4a",nil];
    
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    self.inputFileURL = outputFileURL;
    
    NSLog(@"%@", self.inputFileURL);
    
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
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)okButton:(id)sender {
    
    //[_textField resignFirstResponder];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ApiAI *apiai = [ApiAI sharedApiAI];
    
    
    //NSLog(@"textfield is %@", self.textField.text);
    
    AITextRequest *request = [apiai textRequest];
    request.query = @[self.textField.text?:@""];

    
    __weak typeof(self) selfWeak = self;
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        
        
        __strong typeof(selfWeak) selfStrong = selfWeak;
        
        
        NSLog(@"success");
        
        [MBProgressHUD hideHUDForView:selfStrong.view animated:YES];
        
        //NSLog(@"%@", [response description]);
        //_textView.text = [response description];
        
        homeResultPage *nextController=[self.storyboard instantiateViewControllerWithIdentifier:@"homeResult"];
        nextController.response=response;
        nextController.choose=1;
        [self.navigationController pushViewController:nextController animated:YES];
        
        //[self.textView setText:[response description]];
        
        
    } failure:^(AIRequest *request, NSError *error) {
        
        __strong typeof(selfWeak) selfStrong = selfWeak;
        
        NSLog(@"fail");
        [MBProgressHUD hideHUDForView:selfStrong.view animated:YES];
        
    }];
    
    [apiai enqueue:request];
    //[sender resignFirstResponder];
    NSLog(@"test");
}

- (IBAction)onBackgroungHit:(id)sender {
    

    [self.textField resignFirstResponder];
}


- (IBAction)startButton:(id)sender {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.swichChoose.on) {
        if(! self.isStarted)
        {
            
            [self changeStateToListening];
            
            ApiAI *apiai = [ApiAI sharedApiAI];
            
            AIVoiceRequest *request = [apiai voiceRequest];
            
            __weak typeof(self) selfWeak = self;
            
            [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
                __strong typeof(selfWeak) selfStrong = selfWeak;
                
                NSLog(@"success");
                
                [MBProgressHUD hideHUDForView:selfStrong.view animated:YES];
                //_textView.text = [response description];
                homeResultPage *nextController=[self.storyboard instantiateViewControllerWithIdentifier:@"homeResult"];
                nextController.response=response;
                nextController.choose=0;
                [self.navigationController pushViewController:nextController animated:YES];
                
                
                [selfStrong changeStateToStop];
                
                NSLog(@"success");
                
                [self changeStateToStop];
            } failure:^(AIRequest *request, NSError *error) {
                __strong typeof(selfWeak) selfStrong = selfWeak;
                
                [MBProgressHUD hideHUDForView:selfStrong.view animated:YES];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[error localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
                
                [selfStrong changeStateToStop];
            }];
            
            self.currentVoiceRequest = request;
            [apiai enqueue:request];
            
            self.isStarted = YES;
            
        }
        else{
            
            [self changeStateToStop];
            
            [_currentVoiceRequest commitVoice];
            
            
            self.isStarted = NO;
        }
    }
   else
   
    {
        //if (! self.isStarted) {
            // Set the audio file
        
//-----------------------modified by Yiwei start -----------------------------------------//
        int mark=-1;
            
        if (!self.recorder.recording) {
//            AVAudioSession *session = [AVAudioSession sharedInstance];
//            [session setActive:YES error:nil];
            
            // Start recording
            [self.recorder record];
            [self.startStatus setImage:[UIImage imageNamed:@"mic_talk_358x358.png"] forState:0];

            
        }
        else {
            
            // Pause recording
            [self.recorder stop];
            [self.startStatus setImage:[UIImage imageNamed:@"mic_normal_358x358.png"] forState:0];
        //}

          
            
            AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
            
            
            
            //fetch data from core data
            
            NSManagedObjectContext *context=[appDelegate managedObjectContext];
            NSFetchRequest *request=[[NSFetchRequest alloc] init];
            [request setReturnsObjectsAsFaults:NO];
            request.entity=[NSEntityDescription entityForName:@"Voice" inManagedObjectContext:context];
            NSArray *array=[context executeFetchRequest:request error:nil];
           
            
            double maxClose=0.0;
            double relative=0.0;
            int i;
            
            
            
            //compare relative in the library
            for (i=1; i<array.count+1; i++) {
                NSString *nameN=[array[i-1] valueForKey:@"nameNumber"];
                NSString *fileName=[NSString stringWithFormat:@"voice%@.m4a",nameN];
                NSURL *audioURL1=self.inputFileURL;
                
                NSArray *pathComponents2=[NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0],fileName, nil];
                NSURL *outputFileURL2=[NSURL fileURLWithPathComponents:pathComponents2];
                NSURL *audioURL2=outputFileURL2;
                
                NSLog(@"running time: %d", i);
                
                int d;

                //get the correct relative
                for(d=0; d<20;d++){
                    relative=[compareVoice compareVoiceFirstAudioURL:audioURL1 secondAudio:audioURL2];
                    if (relative<1 && relative > -1) {
                         NSLog(@"relative is %.20f", relative);
                        break;
                    }
                    
                }
                
                
                //get the index of which has the closest relationship
                if (relative>maxClose) {
                    maxClose=relative;
                    mark=i-1;
                }
                
            }
            NSLog(@"maxClose is %.20f", maxClose);
           
            NSLog(@"mark is %d", mark);
        
        NSString* textOutput;
        
            
            
            
        //no match
        if (mark == -1) {
                NSLog(@"No match");
        }
            
        //match ----- get the text
        else{
            textOutput=[[array objectAtIndex:mark]valueForKey:@"text"];
                NSLog(@"textoutput is %@", textOutput);
        }
 
        
            
        //NSString* textOutput;
//------------------------------modified by Yiwei end --------------------------------//

        //////////////////---------***************&&&&&&&&&&&&&&
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        ApiAI *apiai = [ApiAI sharedApiAI];
        
        
        AITextRequest *request2 = [apiai textRequest];
        request2.query = @[textOutput?:@""];
        
        NSLog(@"%@", request2.query);
        
        __weak typeof(self) selfWeak = self;
        
        [request2 setCompletionBlockSuccess:^(AIRequest *request, id response) {
            
            
            __strong typeof(selfWeak) selfStrong = selfWeak;
            
            
            NSLog(@"success");
            
            [MBProgressHUD hideHUDForView:selfStrong.view animated:YES];
            
            //NSLog(@"%@", [response description]);
            //_textView.text = [response description];
            
            homeResultPage *nextController=[self.storyboard instantiateViewControllerWithIdentifier:@"homeResult"];
            nextController.response=response;
            nextController.choose=1;
            [self.navigationController pushViewController:nextController animated:YES];
            
            //[self.textView setText:[response description]];
            
            
        } failure:^(AIRequest *request, NSError *error) {
            
            __strong typeof(selfWeak) selfStrong = selfWeak;
            
            NSLog(@"fail");
            [MBProgressHUD hideHUDForView:selfStrong.view animated:YES];
            
        }];
        
        [apiai enqueue:request2];
        //[sender resignFirstResponder];
        NSLog(@"test");

        
    
        }
    }
    
}

- (void)changeStateToListening
{

    [self.startStatus setImage:[UIImage imageNamed:@"mic_talk_358x358.png"] forState:0];
    
    [self.startStatus setTitle:@"Stop" forState:UIControlStateNormal];
        [_startStatus setEnabled:YES];

}

- (void)changeStateToStop
{
    

    [self.startStatus setImage:[UIImage imageNamed:@"mic_normal_358x358.png"] forState:0];
    
    
    [self.startStatus setTitle:@"start" forState:UIControlStateNormal];
    
    [_startStatus setEnabled:YES];

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_currentVoiceRequest cancel];
}
//- (IBAction)play:(id)sender {
//    if (!self.recorder.recording){
//        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
//        [self.player setDelegate:self];
//        [self.player play];
//    }
//    
//}
@end
