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
@synthesize playerList, levelConfigList, applause1Data;
@synthesize tapGestureLevel1, tapGestureLevel2;

- (void)viewDidLoad
{
    [super viewDidLoad];

    playerList = [[NSMutableArray alloc] init]; // I don't know what I am doing!
    levelConfigList = [[NSMutableArray alloc] init]; // I don't know what I am doing!
    
    [self initializeLevelConfigData];
    [self initializeApplauseData];

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

- (IBAction)tapLevel1Catched:(id)sender
{
    [self changeToStartColor];
    [self playLevelSound:0];
}

- (IBAction)tapLevel2Catched:(id)sender
{    
    [self changeToStartColor];
    [self playLevelSound:1];
}

//------PRI
- (void) playLevelSound:(int)level
{
    if (false == [self isMinIntervalReached:level])
    {
        [self playSound:level];
    }
}

//------UTIL
- (BOOL) isMinIntervalReached:(int)level
{
    NSMutableDictionary *config = [levelConfigList objectAtIndex:level];
    double minInterval = [[config objectForKey:@"minInterval"] doubleValue];
    double lastTapTime = [[config objectForKey:@"lastRecognitionTime"] doubleValue];
    double currentTapTime = [[NSDate date] timeIntervalSince1970];
    
    if (currentTapTime - lastTapTime > minInterval) {
        [config setObject: [NSString stringWithFormat:@"%f", currentTapTime] forKey:@"lastRecognitionTime"];
        return false;
    }

    return true;
}

- (void) playSound:(int)level
{    
    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:applause1Data error:&error];
    [player play];
    [playerList addObject: player];
    //NSLog(@"Number of players :  %d", [playerList count]); //BDNF clear old players
}

- (void) changeToStartColor
{
    self.view.backgroundColor = [UIColor blueColor];
}

- (void) changeToTapColor
{
    self.view.backgroundColor = [UIColor redColor];
}

- (void) initializeLevelConfigData
{
    NSMutableDictionary *level1Config = [[NSMutableDictionary alloc] init];
    [level1Config setObject:@"79675240" forKey:@"trackId"];
    [level1Config setObject:@"3" forKey:@"duration"];
    [level1Config setObject:@"1" forKey:@"minInterval"];
    [level1Config setObject:@"0" forKey:@"lastRecognitionTime"];
    [levelConfigList addObject: level1Config];
    
    NSMutableDictionary *level2Config = [[NSMutableDictionary alloc] init];
    [level2Config setObject:@"96004778" forKey:@"trackId"];
    [level2Config setObject:@"4" forKey:@"duration"];
    [level2Config setObject:@"3" forKey:@"minInterval"];
    [level2Config setObject:@"0" forKey:@"lastRecognitionTime"];
    [levelConfigList addObject: level2Config];
    
    //66234588
    //96004778
    //79675240
}

- (void) initializeApplauseData
{
    for (int i = 0; i < [levelConfigList count]; i++)
    {
        [self initializeApplauseData:i];
    }
}

- (void) initializeApplauseData:(int)level
{
    NSMutableDictionary *config = [levelConfigList objectAtIndex:level];
    NSString *stream_url = [NSString stringWithFormat:@"https://api.soundcloud.com/tracks/%@/stream?client_id=%@", [config objectForKey:@"trackId"], @"fa1fd2df5a17a560f8456aed4016160a"];
    
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

@end
