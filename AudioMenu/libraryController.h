//
//  libraryController.h
//  AudioMenu
//
//  Created by Wufei Lai on 10/14/15.
//  Copyright © 2015 Yiwei Heng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface libraryController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *searchText;
- (IBAction)searchButton:(id)sender;


@property (weak, nonatomic) IBOutlet UITableView *resultTable;


@property NSManagedObjectContext *context;
@property NSMutableArray *array;
@property int cellCount;

@property AVAudioPlayer *player;
@end
