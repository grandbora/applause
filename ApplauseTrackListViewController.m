//
//  ApplauseTrackListViewController.m
//  Applause
//
//  Created by Bora Tunca on 6/9/13.
//  Copyright (c) 2013 Bora Tunca. All rights reserved.
//

#import "SCUI.h"
#import "ApplauseTrackListViewController.h"

@interface ApplauseTrackListViewController ()

@end

@implementation ApplauseTrackListViewController
@synthesize tracks, player;
@synthesize tapTimer, tapCount, tappedRow;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tracks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    cell.textLabel.text = [track objectForKey:@"title"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tapCount == 1 && tapTimer != nil && tappedRow == indexPath.row){//double tap
        [tapTimer invalidate];
        [self setTapTimer:nil];
        
        [player stop];
        
        NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[track objectForKey:@"id"] forKey:@"trackId"];
        [defaults synchronize];
        NSLog(@"DATA SAVED:  %@", [track objectForKey:@"id"]);

        [self performSegueWithIdentifier:@"backwardSegue" sender:self];
    }
    else if(tapCount == 0){ // This is the first tap. If there is no tap till tapTimer is fired, it is a single tap
        tapCount = tapCount + 1;
        tappedRow = indexPath.row;
        [self setTapTimer:[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(tapTimerFired:) userInfo:nil repeats:NO]];
    }
    else if(tappedRow != indexPath.row){ //tap on new row
        
        [self playSample:indexPath.row];
        
        tapCount = 0;
        if(tapTimer != nil){
            [tapTimer invalidate];
            [self setTapTimer:nil];
        }
    }
}

- (void)tapTimerFired:(NSTimer *)aTimer //timer fired, there was a single tap on indexPath.row = tappedRow
{
    [self playSample:tappedRow];
    
    if(tapTimer != nil){
        tapCount = 0;
        tappedRow = -1;
    }
}

- (void)playSample:(int)row
{
    [player stop];
    
    NSDictionary *track = [self.tracks objectAtIndex:row];
    NSString *streamURL = [NSString stringWithFormat:@"%@?client_id=%@", [track objectForKey:@"stream_url"], @"fa1fd2df5a17a560f8456aed4016160a"];
    
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:streamURL]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                 NSError *playerError;
                 player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
                 [player play];
             }];
}


@end
