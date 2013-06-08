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
@synthesize player;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches
            withEvent:(UIEvent *)event
{
    self.view.backgroundColor = [UIColor redColor];
    
    NSString *stream_url = @"https://api.soundcloud.com/tracks/13158665/stream?client_id=fa1fd2df5a17a560f8456aed4016160a"; //remove hardcore
    
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:stream_url]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                 NSError *playerError;
                 player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
                 [player play];
             }];
}

- (void) touchesEnded:(NSSet *)touches
            withEvent:(UIEvent *)event
{
    self.view.backgroundColor = [UIColor blueColor];
}

@end
