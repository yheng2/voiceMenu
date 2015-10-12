//
//  home.h
//  AudioMenu
//
//  Created by Wufei Lai on 10/11/15.
//  Copyright © 2015 Yiwei Heng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ApiAI/UIKit/AIVoiceRequestButton.h>

@interface home : UIViewController
- (IBAction)okButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)startButton:(id)sender;
@property BOOL isStarted;
@property (weak, nonatomic) IBOutlet UIButton *startStatus;



@end
