//
//  ApplauseViewController.m
//  Applause
//
//  Created by Bora Tunca on 6/8/13.
//  Copyright (c) 2013 Bora Tunca. All rights reserved.
//

#import "SCUI.h"
#import "ApplauseTrackListViewController.h"
#import "ApplauseViewController.h"

@interface ApplauseViewController ()
@end

@implementation ApplauseViewController
@synthesize tapGestureLevel1, tapGestureLevel2, tapGestureLevel3, infoBar;
@synthesize playerList, levelConfigList, applauseDataList, loadedApplauseCount, settingsResponse;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self changeToStartColor];
    
    playerList = [[NSMutableArray alloc] init]; // I don't know what I am doing!
    levelConfigList = [[NSMutableArray alloc] init]; // I don't know what I am doing!
    applauseDataList = [[NSMutableArray alloc] init];// I still don't know what I am doing!
    
    [self initializeLevelConfigData];
    [self initializeApplauseData];

    [tapGestureLevel1 requireGestureRecognizerToFail:tapGestureLevel2];
    [tapGestureLevel1 requireGestureRecognizerToFail:tapGestureLevel3];
    [tapGestureLevel2 requireGestureRecognizerToFail:tapGestureLevel3];
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
    [self showLevelInfo:0];
    [self playLevelSound:0];
}

- (IBAction)tapLevel2Catched:(id)sender
{    
    [self changeToStartColor];
    [self showLevelInfo:1];
    [self playLevelSound:0];
    [self playLevelSound:1];
}


- (IBAction)tapLevel3Catched:(id)sender
{
    [self changeToStartColor];
    [self showLevelInfo:2];
    [self playLevelSound:0];
    [self playLevelSound:1];    
    [self playLevelSound:2];
}

//------PRI
- (void) playLevelSound:(int)level
{
    if (false == [self isMinIntervalReached:level])
    {
        [self playSound:level];
    }
}

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
    NSData *applauseData = [applauseDataList objectAtIndex:level];
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:applauseData error:&error];
    [player play];
    [playerList addObject: player];
    NSLog(@"Applause played LEVEL:  %d", level);
    //NSLog(@"Number of players :  %d", [playerList count]); todo://BDNF clear old players
    
    NSMutableDictionary *config = [levelConfigList objectAtIndex:level];
    double duration = [[config objectForKey:@"duration"] doubleValue];
    [NSTimer scheduledTimerWithTimeInterval:duration target:player selector:@selector(stop) userInfo:nil repeats:NO];
}

//------UTIL
- (void) changeToStartColor
{
    self.view.backgroundColor = [[UIColor alloc] initWithRed:120/255.f green:240/255.f blue:240/255.f alpha:1];
}

- (void) changeToTapColor
{
    self.view.backgroundColor = [UIColor redColor];
}

- (void) addDotToInfo
{
    infoBar.text = [infoBar.text stringByAppendingString:@" ."];
}

- (void) showGoInfo
{
    infoBar.text = @"GO !";
}

- (void) showLevelInfo:(int)level
{
    switch (level) {
        case 0:
            infoBar.text = @"* BEGINNER *";
            break;
        case 1:
            infoBar.text = @"** WILD **";
            break;
        case 2:
            infoBar.text = @"*** ULTIMATE ***";
            break;
    }
}

//------INIT
- (void) initializeLevelConfigData
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *trackId = @"5966774";
    if (nil != [defaults objectForKey:@"trackId"])
    {
        trackId = [defaults objectForKey:@"trackId"];
        NSLog(@"DATA LOADED:  %@", trackId);
    }
    
    NSMutableDictionary *level1Config = [[NSMutableDictionary alloc] init];
    [level1Config setObject:trackId forKey:@"trackId"];
    [level1Config setObject:@"3" forKey:@"duration"];
    [level1Config setObject:@"0.4" forKey:@"minInterval"];
    [level1Config setObject:@"0" forKey:@"lastRecognitionTime"];
    [levelConfigList addObject:level1Config];
    [applauseDataList addObject:[NSData data]];

    NSMutableDictionary *level2Config = [[NSMutableDictionary alloc] init];
    [level2Config setObject:@"54424258" forKey:@"trackId"];
    [level2Config setObject:@"5" forKey:@"duration"];
    [level2Config setObject:@"1.3" forKey:@"minInterval"];
    [level2Config setObject:@"0" forKey:@"lastRecognitionTime"];
    [levelConfigList addObject:level2Config];
    [applauseDataList addObject:[NSData data]];

    NSMutableDictionary *level3Config = [[NSMutableDictionary alloc] init];
    [level3Config setObject:@"35074582" forKey:@"trackId"];
    [level3Config setObject:@"5" forKey:@"duration"];
    [level3Config setObject:@"2.5" forKey:@"minInterval"];
    [level3Config setObject:@"0" forKey:@"lastRecognitionTime"];
    [levelConfigList addObject:level3Config];
    [applauseDataList addObject:[NSData data]];
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

                [applauseDataList replaceObjectAtIndex:level  withObject:data];
                [self addDotToInfo];
                loadedApplauseCount++;
                if ([levelConfigList count] == loadedApplauseCount) {
                    [self showGoInfo];
                }
                 
                 NSLog(@"Applause Data LOADED LEVEL:  %d", level);
             }];
}

//------SETTINGS
- (IBAction)openSettings:(id)sender
{
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]])
        {
             settingsResponse = (NSArray *)jsonResponse;
             [self performSegueWithIdentifier:@"forwardSegue" sender:self];
        }
    };

    NSString *resourceURL = [NSString stringWithFormat:@"https://api.soundcloud.com/tracks.json?q=%@&duration[to]=60000&client_id=%@", @"applause", @"fa1fd2df5a17a560f8456aed4016160a"];
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:handler];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ApplauseTrackListViewController *trackListVC = segue.destinationViewController;
    trackListVC.tracks = (NSArray *)settingsResponse;
}

@end
