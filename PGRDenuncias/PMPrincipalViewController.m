//
//  PMPrincipalViewController.m
//  PGRDenuncias
//
//  Created by Planet Media on 16/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import "PMPrincipalViewController.h"

@interface PMPrincipalViewController (){
    PMAudioManager *audioManager;
}

@end

@implementation PMPrincipalViewController

#pragma mark Default Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Set audio file
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   @"Reporte_Inicial.caf",
                                   nil];
        
        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        audioManager = [[PMAudioManager alloc] init];
        audioManager.delegate = self;
        [audioManager prepareRecordingWithURL:outputFileURL];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Controls Methods

- (IBAction)recordAudio:(id)sender {
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

- (void)finishRecordingPlaying{
    PMEvidenciasViewController *evidencias = [[PMEvidenciasViewController alloc] initWithNibName:@"PMEvidenciasViewController" bundle:nil];
    [self.navigationController pushViewController:evidencias animated:YES];
}



@end
