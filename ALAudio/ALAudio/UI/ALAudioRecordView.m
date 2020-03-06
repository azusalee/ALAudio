//
//  ALAudioRecordView.m
//  ALAudio
//
//  Created by lizihong on 2020/3/5.
//  Copyright © 2020 AL. All rights reserved.
//

#import "ALAudioRecordView.h"
#import "ALAudioRecorder.h"

typedef enum : NSUInteger {
    /// 没有触摸
    ALAudioRecordViewTouchStateNone = 0,
    /// 触摸在里面
    ALAudioRecordViewTouchStateTouchIn,
    /// 触摸在外面
    ALAudioRecordViewTouchStateTouchOut
} ALAudioRecordViewTouchState;

@interface ALAudioRecordView()<ALAudioRecorderDelegate>

@property (nonatomic, assign) ALAudioRecordViewTouchState touchState;
@property (nonatomic, strong) ALAudioRecorder *recorder;

@property (nonatomic, strong) UILabel *label;

@end

@implementation ALAudioRecordView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.multipleTouchEnabled = NO;
    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.label.text = @"点击开始录音";
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor blackColor];
    [self addSubview:self.label];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.folderPath == nil) {
        self.folderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    }
    self.touchState = ALAudioRecordViewTouchStateTouchIn;
    NSInteger dateTime = [NSDate now].timeIntervalSince1970;
    NSString *fileName = [NSString stringWithFormat:@"%ld.caf", dateTime];
    self.recorder = [[ALAudioRecorder alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.folderPath, fileName]]];
    self.recorder.extType = ALAudioRecorderExtTypeMp3;
    self.recorder.delegate = self;
    [self.recorder startRecord];
    self.label.text = @"松开完成录音";
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, touchPoint)) {
        self.touchState = ALAudioRecordViewTouchStateTouchIn;
        self.label.text = @"松开完成录音";
    }else{
        self.touchState = ALAudioRecordViewTouchStateTouchOut;
        self.label.text = @"松开取消录音";
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.touchState == ALAudioRecordViewTouchStateTouchIn) {
        [self.recorder stopRecord];
    }else if (self.touchState == ALAudioRecordViewTouchStateTouchOut){
        [self.recorder cancelRecord];
    }
    self.label.text = @"点击开始录音";
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.touchState == ALAudioRecordViewTouchStateTouchIn) {
        [self.recorder stopRecord];
    }else if (self.touchState == ALAudioRecordViewTouchStateTouchOut){
        [self.recorder cancelRecord];
    }
    self.label.text = @"点击开始录音";
}


- (void)alAudio:(ALAudioRecorder*)recorder didRecordFinishWithTime:(NSTimeInterval)time{
    //NSLog(@"%@", [recorder getFinishFileUrl]);
    NSString *urlString = [recorder getFinishFileUrl].absoluteString;
    [self.delegate alAudioView:self didRecordWithPath:urlString fileName:[urlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/", self.folderPath] withString:@""]];
}

- (void)alAudio:(ALAudioRecorder *)recorder failWithError:(NSString *)errorString{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
