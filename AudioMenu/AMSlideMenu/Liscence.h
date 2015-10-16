//
//  Liscence.h
//  AudioMenu
//
//  Created by Wufei Lai on 10/15/15.
//  Copyright © 2015 Yiwei Heng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Liscence : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)cancel:(id)sender;
- (IBAction)agree:(id)sender;

@end
