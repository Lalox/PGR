//
//  PMVideoViewController.m
//  PGRDenuncias
//
//  Created by Planet Media on 20/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import "PMVideoViewController.h"

#define _ID_VIDEO_CELL_ @"cellVideoIdentifier"

@interface PMVideoViewController (){
    //Image management variables
    NSMutableArray *videoArray;
    UIImagePickerController *pickerController;
    NSFileManager *fileManger;
    NSURL *outputFileURL;
    AVAudioPlayer *player;
}

@end

@implementation PMVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSURL* url = [PMUtilityManager getPathWithName:@"Video.aiff"];
        NSError* error = nil;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if(!error)
        {
            [PMUtilityManager getErrorInfoWithError:error inMethod:_cmd inClass:NSStringFromClass([self class])];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_videoList registerClass:[UITableViewCell class] forCellReuseIdentifier:_ID_VIDEO_CELL_];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordVideo:(id)sender {
    if (pickerController == nil)
        pickerController = [[UIImagePickerController alloc] init];
	pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
	pickerController.delegate = self;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
	[self presentViewController:pickerController animated:YES completion:nil];

}

#pragma mark UITableViewDelegate and Datasource Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_ID_VIDEO_CELL_ forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[videoArray objectAtIndex:indexPath.item]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [videoArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSURL *url = [PMUtilityManager getPathWithName:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    //[audioManager playWithURL:url];
}

#pragma mark UIIMagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSError *error;
    fileManger = [NSFileManager defaultManager];
    
    NSURL *theNewURL = [PMUtilityManager getPathWithName:[NSString stringWithFormat:@"Video_%d.aiff",[videoArray count]+1]];
    
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
        [videoArray addObject:[theNewURL lastPathComponent]];
        [_videoList reloadData];
    }
    [pickerController dismissViewControllerAnimated:YES completion:nil];
}

@end
