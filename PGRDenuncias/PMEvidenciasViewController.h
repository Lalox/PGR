//
//  PMEvidenciasViewController.h
//  PGRDenuncias
//
//  Created by Planet Media on 16/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMAutorizacionViewController.h"

@interface PMEvidenciasViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *cameraBtn;
@property (strong, nonatomic) IBOutlet UIButton *microBtn;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITableView *audioListTable;

- (IBAction)takePicture:(id)sender;
- (IBAction)recordAudio:(id)sender;
- (IBAction)selectView:(id)sender;

@end
