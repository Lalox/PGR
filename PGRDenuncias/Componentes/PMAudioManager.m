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
        [PMUtilityManager getErrorInfoWithError:error inMethod:_cmd inClass:NSStringFromClass([self class])];
    }else{
        recorder.delegate = self;
        recorder.meteringEnabled = YES;
        [recorder prepareToRecord];
    }
}

-(void)stopPlayingRecording{
    // Stop recording
    NSError *error;
    [recorder stop];
    audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:&error];
    if (error) {
        [PMUtilityManager getErrorInfoWithError:error inMethod:_cmd inClass:NSStringFromClass([self class])];
    }
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
        [PMUtilityManager getErrorInfoWithError:error inMethod:_cmd inClass:NSStringFromClass([self class])];
    }else{
        [recorder record];
    }
}

-(void)playWithURL:(NSURL *)url{
    NSError *error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error) {
        [PMUtilityManager getErrorInfoWithError:error inMethod:_cmd inClass:NSStringFromClass([self class])];
    }else{
        [audioSession setActive:YES error:&error];
        if (error) {
            [PMUtilityManager getErrorInfoWithError:error inMethod:_cmd inClass:NSStringFromClass([self class])];
        }else{
            [player play];
        }
    }
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorderM successfully:(BOOL)flag{
    NSError *error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorderM.url error:&error];
    [player setDelegate:self];
    if (error) {
<<<<<<< HEAD
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[PMUtilityManager getErrorInfoWithError:error inMethod:_cmd inClass:NSStringFromClass([self class])]  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [errorAlert show];
    }else{
//        [player play];
=======
        [PMUtilityManager getErrorInfoWithError:error inMethod:_cmd inClass:NSStringFromClass([self class])];
>>>>>>> b0dd90267b4d795a24005d317900ce467a9a2c03
    }
    [self.delegate finishRecordingPlayingWithAudioUrl:recorderM.url];
}

@end
