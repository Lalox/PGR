//
//  PMEvidenciasViewController.m
//  PGRDenuncias
//
//  Created by Planet Media on 16/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import "PMEvidenciasViewController.h"

#define _ID_IMAGE_CELL_ @"cellImageIdentifier"
#define _ID_AUDIO_CELL_ @"cellAudioIdentifier"

@interface PMEvidenciasViewController (){
    //Image management variables
    NSMutableArray *imagesArray;
    UIImagePickerController *pickerController;
    PMAudioManager *audioManager;
    
    //Audio management variables
    NSMutableArray *audioArray;
    NSURL *outputFileURL;
    NSFileManager *fileManger;
}

@end

@implementation PMEvidenciasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        outputFileURL = [PMUtilityManager getPathWithName:@"Audio.caf"];
        audioManager = [[PMAudioManager alloc] init];
        audioManager.delegate = self;
        [audioManager prepareRecordingWithURL:outputFileURL];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_ID_IMAGE_CELL_];
    [_audioListTable registerClass:[UITableViewCell class] forCellReuseIdentifier:_ID_AUDIO_CELL_];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBOulet Methods

- (IBAction)takePicture:(id)sender {
    if (pickerController == nil)
        pickerController = [[UIImagePickerController alloc] init];
	pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	pickerController.delegate = self;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
	[self presentViewController:pickerController animated:YES completion:nil];
}

- (IBAction)recordAudio:(id)sender {
    if (_microBtn.selected){
        _microBtn.selected = NO;
        [audioManager stopPlayingRecording];
    }else{
        _microBtn.selected = YES;
        [audioManager startRecording];
    }
}

- (IBAction)selectView:(id)sender {
    UISegmentedControl *button = (UISegmentedControl*) sender;
    if (button.selectedSegmentIndex == 0){
        [_audioListTable setHidden:NO];
        [_microBtn setHidden:NO];
        [_collectionView setHidden:YES];
    }else if (button.selectedSegmentIndex == 1){
        [_audioListTable setHidden:YES];
        [_microBtn setHidden:YES];
        [_collectionView setHidden:NO];
        [_collectionView reloadData];
    }
}

#pragma mark UIImagePickerDelegate Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    if (!imagesArray){
        imagesArray = [[NSMutableArray alloc] init];
    }
    [imagesArray addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [_collectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIImagePickerDelegate and Datasource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:_ID_IMAGE_CELL_ forIndexPath:indexPath];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[imagesArray objectAtIndex:indexPath.row]];
	[cell setBackgroundView:imageView];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [imagesArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(75, 75);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	return 1;
}

#pragma mark PMAudioManagerDelegate Methods

- (void)finishRecordingPlaying{
    NSError *error;
    fileManger = [NSFileManager defaultManager];
    
    NSURL *theNewURL = [PMUtilityManager getPathWithName:[NSString stringWithFormat:@"Audio_%d.caf",([audioArray count]+1)]];
    
    [fileManger moveItemAtURL:outputFileURL toURL:theNewURL error:&error];
    if(error){
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[PMUtilityManager getErrorInfoWithError:error inMethod:_cmd inClass:NSStringFromClass([self class])]  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [errorAlert show];
    }else{
        if (!audioArray){
            audioArray = [[NSMutableArray alloc] init];
        }
        [audioArray addObject:[theNewURL lastPathComponent]];
        [_audioListTable reloadData];
    }
}

#pragma mark UITableViewDelegate and Datasource Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_ID_AUDIO_CELL_ forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[audioArray objectAtIndex:indexPath.item]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [audioArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSURL *url = [PMUtilityManager getPathWithName:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    [audioManager playWithURL:url];
}

@end
