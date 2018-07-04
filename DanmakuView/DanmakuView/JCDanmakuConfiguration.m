//
//  JCDanmakuConfiguration.m
//  HuaYang
//
//  Created by Chenkaijie on 2018/7/4.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "JCDanmakuConfiguration.h"
#import "JCDanmakuViewDefine.h"

@implementation JCDanmakuConfiguration

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _numberOfTracks = DEFAULT_NUMBER_OF_TRACKS;
        _heightOfTrack = DEFAULT_HEIGHT_OF_TRACK;
        _intervalOfDanmaku = DEFAULT_INTERVAL_OF_DANMAKU;
    }
    return self;
}

- (void)normalize {
    
    _numberOfTracks = MAX(_numberOfTracks, 1);
    _heightOfTrack = fmax(0, _heightOfTrack);
    _intervalOfDanmaku = fmax(MIN_INTERVAL_OF_DANMAKU, _intervalOfDanmaku);
}

+ (instancetype)defaultConfiguration {
    
    return [[self alloc] init];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    
    JCDanmakuConfiguration *configuration = [[[self class] allocWithZone:zone] init];
    configuration.numberOfTracks = self.numberOfTracks;
    configuration.heightOfTrack = self.heightOfTrack;
    configuration.intervalOfDanmaku = self.intervalOfDanmaku;
    return configuration;
}

@end
