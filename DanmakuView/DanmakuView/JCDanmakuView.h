//
//  JCDanmakuView.h
//  HuaYang
//
//  Created by jakchen on 2018/4/26.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCDanmakuViewCell.h"
#import "JCDanmakuConfiguration.h"
@class JCDanmakuView;

typedef NS_ENUM(NSInteger, DanmakuPriority) {
    
    DanmakuPriority_Default,    /** 默认规则 */
    DanmakuPriority_Immediate,  /** 加到头部并优先展示 */
};

@protocol JCDanmakuViewDataSource <NSObject>

@required
- (NSTimeInterval)durationOfDanmuku:(id)danmakuModel;
- (CGSize)estimatedSizeForItem:(id)danmakuModel;
- (__kindof JCDanmakuViewCell *)danmakuView:(JCDanmakuView *)danmakuView cellForItem:(id)danmakuModel estimatedSize:(CGSize)estimatedSize;

@end

@protocol JCDanmakuViewDelegate <NSObject>

@optional
- (void)danmakuView:(JCDanmakuView *)danmakuView didSelectDanmaku:(id)danmakuModel;
- (BOOL)danmakuViewShouldSendDanmaku:(id)danmakuModel;
- (void)danmakuViewWillEnterForeground:(JCDanmakuView *)danmakuView;

@end

@interface JCDanmakuView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame danmakuConfiguration:(JCDanmakuConfiguration *)danmakuConfiguration;

@property (nonatomic, weak) id <JCDanmakuViewDelegate> delegate;
@property (nonatomic, weak) id <JCDanmakuViewDataSource> dataSource;

- (void)addDanmaku:(id)danmakuModel priority:(DanmakuPriority)priority;

@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) BOOL autoClearWhenEnterForeground;    /** Default is YES */

- (void)abandonDanmakuBeforTime:(NSTimeInterval)time;

@end
