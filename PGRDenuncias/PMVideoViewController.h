//
//  PMVideoViewController.h
//  PGRDenuncias
//
//  Created by Planet Media on 20/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PMAudioManager.h"
#import "PMConnectionHandler.h"

@interface PMVideoViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, ConnectionHandlerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *videoList;
- (IBAction)recordVideo:(id)sender;

@end
