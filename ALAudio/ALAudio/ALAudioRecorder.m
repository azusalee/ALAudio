//
//  ALAudioRecorder.m
//  ALAudio
//
//  Created by lizihong on 2020/3/5.
//  Copyright © 2020 AL. All rights reserved.
//

#import "ALAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface ALAudioRecorder()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *record;
@property (nonatomic, strong) NSURL *url;

@end

@implementation ALAudioRecorder


- (instancetype)initWithURL:(NSURL *)url{
    if (self = [super init]){
        _url = url;
        [self setup];
    }
    return self;
}

- (void)setup{
    NSDictionary *settingDic = @{// 编码格式
                                AVFormatIDKey:@(kAudioFormatLinearPCM),
                                // 采样率
                                AVSampleRateKey:@(11025.0),
                                // 通道数
                                AVNumberOfChannelsKey:@(2),
                                // 录音质量
                                AVEncoderAudioQualityKey:@(AVAudioQualityMin)
                                };
    NSError *error = nil;
    self.record = [[AVAudioRecorder alloc] initWithURL:self.url settings:settingDic error:&error];
    if (error) {
        NSLog(@"error:%@",error);
        return;
    }
    self.record.meteringEnabled = YES;
    self.record.delegate = self;
    // 准备录音(系统会给我们分配一些资源)
    [self.record prepareToRecord];
}

- (void)startRecord{
    [self.record record];
}

- (void)stopRecord{
    NSTimeInterval durationTime = self.record.currentTime;
    [self.record stop];
    if (durationTime > 2) {
        [self.delegate alAudio:self didRecordFinishWithTime:durationTime];
    }else{
        [self.record deleteRecording];
        [self.delegate alAudio:self failWithError:@"录音时间过短"];
    }
}

- (void)cancelRecord{
    [self.record stop];
    [self.record deleteRecording];
}

- (float)detectVolumn{
    [self.record updateMeters];
    return [self.record peakPowerForChannel:0];
}

// - mark AVAudioDelegate


- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{
    [self.delegate alAudio:self failWithError:error.description];
}

@end
