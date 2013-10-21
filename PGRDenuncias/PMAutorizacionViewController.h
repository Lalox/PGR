//
//  PMAutorizacionViewController.h
//  PGRDenuncias
//
//  Created by Planet Media on 18/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMAudioManager.h"
#import "PMVideoViewController.h"

@interface PMAutorizacionViewController : UIViewController<PMAudioManagerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *recordBtn;
- (IBAction)record:(id)sender;
@end
