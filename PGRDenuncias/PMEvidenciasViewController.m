//
//  PMEvidenciasViewController.m
//  PGRDenuncias
//
//  Created by Planet Media on 16/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import "PMEvidenciasViewController.h"

#define _ID_CELL_ @"cellIdentifier"

@interface PMEvidenciasViewController (){
    NSMutableArray *imagesArray;
    UIImagePickerController *pickerController;
}

@end

@implementation PMEvidenciasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_ID_CELL_];
}

- (void)didReceiveMemoryWarning
{
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
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (IBAction)selectView:(id)sender {
    UISegmentedControl *button = (UISegmentedControl*) sender;
    if (button.selectedSegmentIndex == 0){
        [_audioListTable setHidden:NO];
        [_microBtn setHidden:NO];
    }else if (button.selectedSegmentIndex == 1){
        [_audioListTable setHidden:YES];
        [_microBtn setHidden:YES];
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
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:_ID_CELL_ forIndexPath:indexPath];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[imagesArray objectAtIndex:indexPath.row]];
	[cell setBackgroundView:imageView];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [imagesArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(75, 75);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	return 1;
}
@end
