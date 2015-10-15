//
//  libraryController.m
//  AudioMenu
//
//  Created by Wufei Lai on 10/14/15.
//  Copyright © 2015 Yiwei Heng. All rights reserved.
//

#import "libraryController.h"
#import "Voice+CoreDataProperties.h"

@interface libraryController ()


@end

@implementation libraryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    self.context=[appDelegate managedObjectContext];
    
    NSFetchRequest *requst=[[NSFetchRequest alloc]init];
    [requst setReturnsObjectsAsFaults:NO];
    requst.entity=[NSEntityDescription entityForName:@"Voice" inManagedObjectContext:self.context];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"text" ascending:YES];

    requst.sortDescriptors=[NSArray arrayWithObject:sort];
    self.array=[NSMutableArray arrayWithArray:[self.context executeFetchRequest:requst error:nil]];
    self.cellCount=0;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.array.count==0) {
        return 1;
    }
    else {
        return self.array.count;
    }
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str=@"List Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    
    if (self.array.count!=0) {
        cell.textLabel.text=[self.array[self.cellCount] valueForKey:@"text"];
        
    }
        
    
    self.cellCount+=1;
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSManagedObject *obj=[self.array objectAtIndex:indexPath.row];
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [self.context deleteObject:obj];
        NSError *err;
        if (![self.context save:&err]) {
            NSLog(@"Can't Delete! %@ %@", err, [err localizedDescription]);
            return;
        }
        
        [self.array removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle==UITableViewCellEditingStyleInsert){
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSArray *output=[self.array objectAtIndex:indexPath.row];
    NSLog(@"%@",output);
    int i=[[output valueForKey:@"nameNumber"] intValue];
    NSString *str=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"voice%d.m4a",i]];
    NSURL *voiceURL=[NSURL fileURLWithPath:str];
    NSLog(@"%@",voiceURL);
    
    self.player=[[AVAudioPlayer alloc] initWithContentsOfURL:voiceURL error:nil];
    //[self.player setDelegate:self];
    [self.player play];
}

- (IBAction)onBackgroungHit:(id)sender {
    
    
    [self.searchText resignFirstResponder];
}

- (IBAction)searchButton:(id)sender {
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];
    NSEntityDescription *dic=[NSEntityDescription entityForName:@"Voice" inManagedObjectContext:self.context];
    request.entity=dic;
    request.predicate=[NSPredicate predicateWithFormat:@"text contains %@",self.searchText.text];
    self.array=[NSMutableArray arrayWithArray:[self.context executeFetchRequest:request error:nil]];
    self.cellCount=0;
    
    //[self viewDidLoad];
    [self.resultTable reloadData];

}
@end
