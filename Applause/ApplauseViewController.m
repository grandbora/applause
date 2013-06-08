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
@synthesize playerList, applause1Data,lastTapTime;
@synthesize tapGestureLevel1, tapGestureLevel2;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeApplauseData];
    
    playerList = [[NSMutableArray alloc] init]; // I don't know what I am doing!
    [tapGestureLevel1 requireGestureRecognizerToFail:tapGestureLevel2];


    //write ready GO
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
}

- (void) touchesEnded:(NSSet *)touches
            withEvent:(UIEvent *)event
{
    [self changeToStartColor];
}

- (IBAction)tapLevel1Catched:(id)sender {
    
    [self changeToStartColor];
    
    if (false == [self isTapIntervalReached])
    {
        [self playSoundLevel1];
    }
}

- (IBAction)tapLevel2Catched:(id)sender {
    
    [self changeToStartColor];
    
    if (false == [self isTapIntervalReached])
    {
        [self playSoundLevel2];
    }
}

//------PRI

- (BOOL) isTapIntervalReached
{
    double currentTapTime = [[NSDate date] timeIntervalSince1970];
    double interval = currentTapTime - lastTapTime;
    
    if (interval > 0.3) {
        lastTapTime = currentTapTime;
        return false;
    }

//    NSLog(@"interval :  %f", interval);
    return true;
}

- (void) playSound
{    
    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:applause1Data error:&error];
    [player play];
    [playerList addObject: player];
    //NSLog(@"Number of players :  %d", [playerList count]);
    //BDNF clear old players
}

- (void) initializeApplauseData
{
    //66234588
    //96004778
    //79675240
    NSString *stream_url = @"https://api.soundcloud.com/tracks/79675240/stream?client_id=fa1fd2df5a17a560f8456aed4016160a"; //remove hardcore
    
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:stream_url]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                 applause1Data = data;
                 NSLog(@"Applause Data LOADED");
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
