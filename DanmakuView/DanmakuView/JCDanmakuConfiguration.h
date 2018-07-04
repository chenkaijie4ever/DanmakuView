//
//  JCDanmakuConfiguration.h
//  HuaYang
//
//  Created by Chenkaijie on 2018/7/4.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCDanmakuConfiguration : NSObject

/** 轨道数 */
@property (nonatomic, assign) NSInteger numberOfTracks;
/** 每条轨道高度 */
@property (nonatomic, assign) CGFloat heightOfTrack;
/** 弹幕发送间隔 */
@property (nonatomic, assign) NSTimeInterval intervalOfDanmaku;

- (void)normalize;

+ (instancetype)defaultConfiguration;

@end
