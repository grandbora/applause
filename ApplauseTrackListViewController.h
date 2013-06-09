//
//  ApplauseTrackListViewController.h
//  Applause
//
//  Created by Bora Tunca on 6/9/13.
//  Copyright (c) 2013 Bora Tunca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ApplauseTrackListViewController : UITableViewController <AVAudioPlayerDelegate>

@property (nonatomic, strong) NSArray *tracks;

@end