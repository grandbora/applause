//
//  ApplauseViewController.m
//  Applause
//
//  Created by Bora Tunca on 6/8/13.
//  Copyright (c) 2013 Bora Tunca. All rights reserved.
//

#import "SCUI.h"
#import "ApplauseViewController.h"

@interface ApplauseViewController ()
@end

@implementation ApplauseViewController
@synthesize playerList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    playerList = [[NSMutableArray alloc] init]; // I don't know what I am doing!
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches
            withEvent:(UIEvent *)event
{
    [self changeToTapColor];
    [self playSound];
}

- (void) touchesEnded:(NSSet *)touches
            withEvent:(UIEvent *)event
{
    [self changeToStartColor];
}

- (void) playSound
{
    
    
    
    
    NSString *stream_url = @"https://api.soundcloud.com/tracks/96007156/stream?client_id=fa1fd2df5a17a560f8456aed4016160a"; //remove hardcore
    
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:stream_url]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                 NSError *playerError;
                 
                 AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
                 [player play];
                 
                 [playerList addObject: player];
                 
//                 player2 = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
//                 [player2 playAtTime:player.deviceCurrentTime + 0.2];
                 
             }];

}

- (void) changeToStartColor
{
    self.view.backgroundColor = [UIColor blueColor];
}

- (void) changeToTapColor
{
    self.view.backgroundColor = [UIColor redColor];
}

@end
