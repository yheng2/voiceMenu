//
//  homeResultPage.m
//  AudioMenu
//
//  Created by Wufei Lai on 10/11/15.
//  Copyright © 2015 Yiwei Heng. All rights reserved.
//

#import "homeResultPage.h"

@interface homeResultPage ()



@end

@implementation homeResultPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *result = [self.response objectForKey:@"result"];
    if (self.choose) {
        
        //NSString *action=[result objectForKey:@"action"];
        NSDictionary *fulfillment=[result objectForKey:@"fulfillment"];
        NSString *speech=[fulfillment objectForKey:@"speech"];
        
        self.textView.text=speech;
    }
    else {
        self.textView.text=[result objectForKey:@"speech"];
    }
    
    
   // self.textView.text=[self.response description];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
