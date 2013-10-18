//
//  PMAudioManager.m
//  PGRDenuncias
//
//  Created by Planet Media on 16/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import "PMAudioManager.h"

@implementation PMAudioManager

@synthesize delegate;

-(void)prepareRecordingWithURL:(NSURL *)url{
    // Setup audio session
    audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    NSError *error;
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
    if (error) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[self getErrorInfoWithError:error inMethod:_cmd]  delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [errorAlert show];
    }else{
        recorder.delegate = self;
        recorder.meteringEnabled = YES;
        [recorder prepareToRecord];
    }
}

-(void)stopPlayingRecording{
    // Stop recording
    [recorder stop];
    audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

-(void)startRecording{
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }
    
    // Start recording
    NSError *error;
    [audioSession setActive:YES error:&error];
    if (error) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[self getErrorInfoWithError:error inMethod:_cmd]  delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [errorAlert show];
    }else{
        [recorder record];
    }
}

-(void)playRecordinWithURL:(NSString *)url{

}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorderM successfully:(BOOL)flag{
    NSError *error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorderM.url error:&error];
    [player setDelegate:self];
    if (error) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[self getErrorInfoWithError:error inMethod:_cmd]  delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [errorAlert show];
    }else{
        [player play];
    }
    [self.delegate finishRecordingPlaying];
}


-(NSString *) getErrorInfoWithError: (NSError*) error inMethod: (SEL)method{
    return [NSString stringWithFormat:@"%@ (%@): %@", NSStringFromClass([self class]), NSStringFromSelector(method),error.description];
}

@end
