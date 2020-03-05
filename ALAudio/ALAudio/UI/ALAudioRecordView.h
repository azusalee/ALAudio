//
//  ALAudioRecordView.h
//  ALAudio
//
//  Created by lizihong on 2020/3/5.
//  Copyright © 2020 AL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ALAudioRecordView;
@protocol ALAudioRecordViewDelegate <NSObject>

- (void)alAudioView:(ALAudioRecordView*)view didRecordWithPath:(NSString*)fullPath fileName:(NSString*)fileName;

@end

@interface ALAudioRecordView : UIView

@property (nonatomic, strong) NSString *foloderPath;

@end

NS_ASSUME_NONNULL_END
