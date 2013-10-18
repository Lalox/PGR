//
//  PMAudioManager.h
//  PGRDenuncias
//
//  Created by Planet Media on 16/10/13.
//  Copyright (c) 2013 Planet Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol PMAudioManagerDelegate <NSObject>

//-(void)finishRecordingPlaying;
-(void)finishRecordingPlayingWithAudioUrl:(NSURL *)url;

@end

@interface PMAudioManager : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate>{
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    AVAudioSession *audioSession;
}

@property (nonatomic,retain) id<PMAudioManagerDelegate> delegate;

-(void)prepareRecordingWithURL: (NSURL*)url;
-(void)startRecording;
-(void)stopPlayingRecording;
-(void)playRecordinWithURL: (NSString*)url;

@end

