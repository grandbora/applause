//
//  ApplauseViewController.h
//  Applause
//
//  Created by Bora Tunca on 6/8/13.
//  Copyright (c) 2013 Bora Tunca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ApplauseViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureLevel1;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureLevel2;
- (IBAction)tapLevel1Catched:(id)sender;
- (IBAction)tapLevel2Catched:(id)sender;
@property (nonatomic, strong) NSMutableArray *playerList;
@property (nonatomic, strong) NSData *applause1Data;
@property double lastTapTime;
@end
