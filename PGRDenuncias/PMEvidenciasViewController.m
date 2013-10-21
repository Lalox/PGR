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
    
    //Audio management variables
    NSMutableArray *audioArray;
    NSURL *outputFileURL;
    NSFileManager *fileManger;
    PMAudioManager *audioManager;
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
        if (!audioArray){
            audioArray = [[NSMutableArray alloc] init];
        }
        [audioArray addObject:@"Reporte_Inicial.caf"];
    }
    return self;
}

- (void) sendInformation:(id)sender{
    if (![PMUtilityManager isThereInternetAccess]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[NSBundle mainBundle] localizedStringForKey:(@"Error") value:@"Error" table:nil] message:[[NSBundle mainBundle] localizedStringForKey:(@"NoConnection") value:@"No se detecta conexión a Internet ¿Desea continuar?" table:nil] delegate:self cancelButtonTitle:[[NSBundle mainBundle] localizedStringForKey:(@"OK") value:@"Aceptar" table:nil] otherButtonTitles:nil];
        [alert show];
    }else{
        PMAutorizacionViewController *vc = [[PMAutorizacionViewController alloc]initWithNibName:@"PMAutorizacionViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];

    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_ID_IMAGE_CELL_];
    [_audioListTable registerClass:[UITableViewCell class] forCellReuseIdentifier:_ID_AUDIO_CELL_];
    self.navigationItem.title = [[NSBundle mainBundle] localizedStringForKey:(@"Evidences") value:@"Evidencias" table:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[[NSBundle mainBundle] localizedStringForKey:(@"Send") value:@"Enviar" table:nil] style:UIBarButtonItemStyleBordered target:self action:@selector(sendInformation:)];
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

#pragma mark UICollectionViewDelegate and Datasource

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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view = [[UIImageView alloc] initWithImage:[imagesArray objectAtIndex:indexPath.row]];
	[vc.view setFrame:[[UIScreen mainScreen] bounds]];
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark PMAudioManagerDelegate Methods

- (void)finishRecordingPlaying{
    NSError *error;
    fileManger = [NSFileManager defaultManager];
    
    NSURL *theNewURL = [PMUtilityManager getPathWithName:[NSString stringWithFormat:@"Audio_%d.caf",[audioArray count]]];
    
    if([fileManger fileExistsAtPath:[theNewURL path]]){
        [fileManger removeItemAtURL:theNewURL error:&error];
        if(error){
            [PMUtilityManager getErrorInfoWithError:error inMethod:_cmd inClass:NSStringFromClass([self class])];
            return;
        }
    }
    [fileManger moveItemAtURL:outputFileURL toURL:theNewURL error:&error];
    if(error){
        [PMUtilityManager getErrorInfoWithError:error inMethod:_cmd inClass:NSStringFromClass([self class])];
    }else{
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

-(void)finishRecordingPlayingWithAudioUrl:(NSURL *)url{

}

@end
