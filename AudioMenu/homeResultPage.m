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
    self.textView.text=[self.response description];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
