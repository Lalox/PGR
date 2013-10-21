//
//  PMVideoViewController.h
//  PGRDenuncias
//
//  Created by Planet Media on 20/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PMAudioManager.h"

@interface PMVideoViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *videoList;
- (IBAction)recordVideo:(id)sender;

@end
