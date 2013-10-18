//
//  PMPrincipalViewController.h
//  PGRDenuncias
//
//  Created by Planet Media on 16/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "PMAudioManager.h"
#import "PMEvidenciasViewController.h"
#import "PMConnectionHandler.h"

@interface PMPrincipalViewController : UIViewController <AVAudioPlayerDelegate, AVAudioRecorderDelegate, PMAudioManagerDelegate, ConnectionHandlerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *recordBtn;
@end
