//
//  MainVC.m
//  AudioMenu
//
//  Created by Yiwei Heng on 10/4/15.
//  Copyright (c) 2015 Yiwei Heng. All rights reserved.
//

#import "MainVC.h"
#import "UIViewController+AMSlideMenu.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self disableSlidePanGestureForRightMenu];
}

-(int)isFirstTime{
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
    if([theDefaults integerForKey:@"hasRun"] == 0) {
        [theDefaults setInteger:1 forKey:@"hasRun"];
        [theDefaults synchronize];
        return 0;
    }
    return 1;
    
}

-(void)viewDidAppear:(BOOL)animated{
    int result;
    result=[self isFirstTime];
    NSLog(@"licence: %d",result);
    if (result==0) {
        [self performSegueWithIdentifier:@"licenceSegue" sender:self];
    }
}

- (NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath{
    
    NSString* identifier;
    switch (indexPath.row){
            case 0:
                identifier = @"firstSegue";
            break;
            case 1:
                identifier = @"secondSegue";
            break;
            case 2:
                identifier = @"thirdSegue";
            break;
    }
    return identifier;
    
    
}


- (void) configureLeftMenuButton:(UIButton *)button{
    
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0,0};
    frame.size = (CGSize){40,40};
    button.frame = frame;
    
    [button setImage:[UIImage imageNamed:@"icon-menu"] forState:UIControlStateNormal];
    
}




- (NSString *)segueIdentifierForIndexPathInRightMenu:(NSIndexPath *)indexPath{
    
    NSString* identifier;
    switch (indexPath.row){
        case 0:
            identifier = @"rightSegue";
            break;
        
    }
    return identifier;
    
    
}


- (CGFloat) leftMenuWidth
{
    
    return 100;
}

- (CGFloat) rightMenuWidth
{
    return 100;
}


- (BOOL)deepnessForLeftMenu
{
    return YES;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
