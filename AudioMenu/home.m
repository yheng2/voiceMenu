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

- (void)changeStateToListening
{
//    UIImageView *micNormalImageView = [UIImage imageNamed:@"mic_talk_358x358.png"];
//    [self.recordImage setImage:micNormalImageView];
    [self.startStatus setImage:[UIImage imageNamed:@"mic_talk_358x358.png"] forState:0];
    
    [self.startStatus setTitle:@"Stop" forState:UIControlStateNormal];
    //self.startStatus.titleLabel.text = @"Start";
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
@end
