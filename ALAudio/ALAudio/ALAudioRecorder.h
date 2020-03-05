//
//  ALAudioRecorder.h
//  ALAudio
//
//  Created by lizihong on 2020/3/5.
//  Copyright © 2020 AL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ALAudioRecorder;
@protocol ALAudioRecorderDelegate <NSObject>

- (void)alAudio:(ALAudioRecorder*)recorder failWithError:(NSString*)errorString;
- (void)alAudio:(ALAudioRecorder*)recorder didRecordFinishWithTime:(NSTimeInterval)time;

@end

@interface ALAudioRecorder : NSObject

@property (nonatomic, weak) id<ALAudioRecorderDelegate> delegate;


@property (nonatomic, readonly) NSURL *url;

- (instancetype)initWithURL:(NSURL *)url;

// 开始录音
- (void)startRecord;
// 结束录音
- (void)stopRecord;
// 取消录音(删除文件)
- (void)cancelRecord;
// 获取音量
- (float)detectVolumn;


@end

NS_ASSUME_NONNULL_END
