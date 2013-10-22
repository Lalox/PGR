//
//  PMAutorizacionViewController.m
//  PGRDenuncias
//
//  Created by Planet Media on 18/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import "PMAutorizacionViewController.h"

@interface PMAutorizacionViewController (){
    PMAudioManager *audioManager;
}

@end

@implementation PMAutorizacionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSURL *outputFileURL = [PMUtilityManager getPathWithName:@"Autorización.caf"];
        audioManager = [[PMAudioManager alloc] init];
        audioManager.delegate = self;
        [audioManager prepareRecordingWithURL:outputFileURL];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

	[[[UIAlertView alloc] initWithTitle:@"PGR" message:@"Solicite autorización para realizar inspección superficial" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil] show];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)record:(id)sender {
    UIButton *btn = (UIButton *) sender;
    if (btn.selected){
        [btn setSelected:NO];
        [audioManager stopPlayingRecording];
    }else{
        [btn setSelected:YES];
        [audioManager startRecording];
    }
}

#pragma mark PMAudioManagerDelegate Methods

- (void)finishRecordingPlayingWithAudioUrl:(NSURL *)url{
    PMVideoViewController *videoVC = [[PMVideoViewController alloc] initWithNibName:@"PMVideoViewController" bundle:nil];
    [self.navigationController pushViewController:videoVC animated:YES];
}

@end
