//
//  JCDanmakuView.m
//  HuaYang
//
//  Created by jakchen on 2018/4/26.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "JCDanmakuView.h"
#import "NoRetainTimer.h"
#import "JCDanmakuModel.h"
#import "JCDanmakuViewDefine.h"
#import "JCDanmakuViewCell+Protected.h"

@interface JCDanmakuView ()

@property (nonatomic, strong) JCDanmakuConfiguration *configuration;

@property (nonatomic, strong) NoRetainTimer *timer;
@property (nonatomic, strong) NSLock *lock;

@property (nonatomic, strong) NSMutableArray<JCDanmakuModel *> *msgList;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSMutableArray<JCDanmakuViewCell *> *> *trackList;

@end

@implementation JCDanmakuView

- (instancetype)initWithFrame:(CGRect)frame {
    
    return [self initWithFrame:frame
          danmakuConfiguration:[JCDanmakuConfiguration defaultConfiguration]];
}

- (instancetype)initWithFrame:(CGRect)frame danmakuConfiguration:(JCDanmakuConfiguration *)danmakuConfiguration {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        
        _configuration = [danmakuConfiguration copy];
        [_configuration normalize];
        
        _lock = [NSLock new];
        _enable = YES;
        _autoClearWhenEnterForeground = YES;
        
        _msgList = [NSMutableArray array];
        NSInteger numberOfTracks = _configuration.numberOfTracks;
        _trackList = [NSMutableDictionary dictionaryWithCapacity:numberOfTracks];
        for (NSInteger index = 0; index < numberOfTracks; index++) {
            [_trackList setObject:[NSMutableArray array] forKey:@(index)];
        }
        
        [self registerNotifications];
        [self startTimer];
    }
    return self;
}

- (void)registerNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)dealloc {
    
    [self stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)precheck {
    
    NSAssert(_dataSource, @"JCDanmakuViewDataSource can't nil");
    NSAssert([_dataSource respondsToSelector:@selector(durationOfDanmuku:)],
             @"JCDanmakuViewDataSource should responds to selector : durationOfDanmuku:");
    NSAssert([_dataSource respondsToSelector:@selector(estimatedSizeForItem:)],
             @"JCDanmakuViewDataSource should responds to selector : estimatedSizeForItem:");
    NSAssert([_dataSource respondsToSelector:@selector(danmakuView:cellForItem:estimatedSize:)],
             @"JCDanmakuViewDataSource should responds to selector : danmakuView:cellForItem:estimatedSize:");
}

#pragma mark - Get & Set

- (void)addOneDanmaku:(JCDanmakuModel *)wrapperModel priority:(DanmakuPriority)priority {
    
    [_lock lock];
    if (wrapperModel) {
        switch (priority) {
            case DanmakuPriority_Immediate : {
                [_msgList insertObject:wrapperModel atIndex:0];
            }
                break;
            case DanmakuPriority_Default:
            default: {
                [_msgList addObject:wrapperModel];
            }
                break;
        }
    }
    [_lock unlock];
}

- (void)addDanmakus:(NSArray<JCDanmakuModel *> *)wrapperModelList {
    
    [_lock lock];
    if (wrapperModelList.count > 0) {
        [_msgList addObjectsFromArray:wrapperModelList];
    }
    [_lock unlock];
}

- (void)removeOneDanmaku:(JCDanmakuModel *)wrapperModel {
    
    [_lock lock];
    if (wrapperModel) {
        [_msgList removeObject:wrapperModel];
    }
    [_lock unlock];
}

- (void)removeDanmakus:(NSArray<JCDanmakuModel *> *)wrapperModelList {
    
    [_lock lock];
    if (wrapperModelList.count > 0) {
        [_msgList removeObjectsInArray:wrapperModelList];
    }
    [_lock unlock];
}

- (void)removeAllDanmakus {
    
    [_lock lock];
    [_msgList removeAllObjects];
    [_lock unlock];
}

#pragma mark - Send Danmaku

- (void)addDanmaku:(id)danmakuModel priority:(DanmakuPriority)priority {
    
    [self precheck];
    if (!_enable) return;
    
    if (danmakuModel) {
        JCDanmakuModel *wrapperModel = [JCDanmakuModel modelWithData:danmakuModel];
        [self addOneDanmaku:wrapperModel priority:priority];
    }
}

- (void)onTimer {
    
    if (_msgList.count > 0) {
        JCDanmakuModel *wrapperModel = [_msgList firstObject];
        [self removeOneDanmaku:wrapperModel];
        
        wrapperModel.sendTime = JCLocalUTCTime;
        wrapperModel.track = [self seekForSuitableTrack];
        wrapperModel.duration = [_dataSource durationOfDanmuku:wrapperModel.data];
        
        [self sendDanmaku:wrapperModel];
    }
}

- (NSInteger)seekForSuitableTrack {
    
    CGFloat maxSupportWidth = self.bounds.size.width;
    NSInteger seekTrack = -1;
    CGFloat maxMarginInAllTrack = 0;
    for (NSInteger i = 0; i < _trackList.count; i++) {
        NSMutableArray *danmakuCellList = [_trackList objectForKey:@(i)];
        NSTimeInterval now = JCLocalUTCTime;
        CGFloat minMargin = maxSupportWidth;
        for (NSInteger j = 0; j < danmakuCellList.count; j++) {
            JCDanmakuViewCell *cell = [danmakuCellList objectAtIndex:j];
            JCDanmakuModel *wrapperModel = cell.wrapperModel;
            NSTimeInterval interval = now - wrapperModel.sendTime;
            CGFloat marginToRight = ((maxSupportWidth + cell.bounds.size.width) / wrapperModel.duration) * interval - cell.bounds.size.width;
            minMargin = fmin(minMargin, marginToRight);
        }
        if (i == 0) {
            maxMarginInAllTrack = minMargin;
            seekTrack = i;
        }
        if (minMargin > maxMarginInAllTrack) {
            maxMarginInAllTrack = minMargin;
            seekTrack = i;
            // 如果找到了一条空轨道，则直接break
            if (maxMarginInAllTrack == maxSupportWidth) break;
        }
    }
    if (seekTrack == -1) {
        seekTrack = rand() % _trackList.count;
    }
    return seekTrack;
}

- (void)sendDanmaku:(JCDanmakuModel *)wrapperModel {
    
    /** 弹幕过滤逻辑 */
    if ([_delegate respondsToSelector:@selector(danmakuViewShouldSendDanmaku:)]) {
        if (![_delegate danmakuViewShouldSendDanmaku:wrapperModel.data]) return;
    }
    
    CGSize estimatedSize = [_dataSource estimatedSizeForItem:wrapperModel.data];
    JCDanmakuViewCell *cell = [_dataSource danmakuView:self cellForItem:wrapperModel.data estimatedSize:estimatedSize];
    if (cell) {
        cell.wrapperModel = wrapperModel;
        NSInteger track = wrapperModel.track;
    
        NSMutableArray *array = [_trackList objectForKey:@(track)];
        [array addObject:cell];
        
        CGFloat centerY = (track + 0.5f) * _configuration.heightOfTrack;
        CGRect cellFrame = cell.frame;
        cellFrame.origin.x = self.bounds.size.width;
        cell.frame = cellFrame;
        cell.center = CGPointMake(cell.center.x, centerY);
        [self addSubview:cell];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleTapGesture:)];
        [cell addGestureRecognizer:tapGesture];
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:wrapperModel.duration
                              delay:0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                                CGRect cellFrame = cell.frame;
                                cellFrame.origin.x = -estimatedSize.width;
                                cell.frame = cellFrame;
                            } completion:^(BOOL finished) {
                                [cell removeFromSuperview];
                                
                                __strong typeof(self) strongSelf = weakSelf;
                                if (strongSelf) {
                                    NSInteger track = cell.wrapperModel.track;
                                    NSMutableArray *array = [strongSelf.trackList objectForKey:@(track)];
                                    [array removeObject:cell];
                                }
                                
                            }];
    }
}

#pragma mark - Timer Logic

- (void)startTimer {
    
    [self startTimerWithTimeInterval:_configuration.intervalOfDanmaku];
}

- (void)startTimerWithTimeInterval:(NSTimeInterval)timeInterval {
    
    if (timeInterval <= 0) {
        return;
    }
    [self stopTimer];
    if (_timer == nil) {
        _timer = [NoRetainTimer scheduledTimerWithTimeInterval:timeInterval
                                                        target:self
                                                      selector:@selector(onTimer)
                                                      userInfo:nil
                                                       repeats:YES];
    }
}

- (void)stopTimer {
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Gesture

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    
    if ([_delegate respondsToSelector:@selector(danmakuView:didSelectDanmaku:)]) {
        JCDanmakuViewCell *cell = (JCDanmakuViewCell *)gesture.view;
        [_delegate danmakuView:self didSelectDanmaku:cell.wrapperModel.data];
    }
}

#pragma mark - Clear logic

- (void)setEnable:(BOOL)enable {

    if (_enable != enable) {
        _enable = enable;
        
        if (!enable) {
            [self clear];
            [self removeAllDanmakus];
        }
    }
}

- (void)clear {
    
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

#pragma mark - Background logic

- (void)appWillEnterForeground {
    
    [self clear];
    if (_autoClearWhenEnterForeground) {
        [self removeAllDanmakus];
    }
    if ([_delegate respondsToSelector:@selector(danmakuViewWillEnterForeground:)]) {
        [_delegate danmakuViewWillEnterForeground:self];
    }
    [self startTimer];
}

- (void)appDidEnterBackground {
    
    [self stopTimer];
}

#pragma mark - Filter logic

- (void)abandonDanmakuBeforTime:(NSTimeInterval)time {
    
    NSMutableArray <JCDanmakuModel *> *abandonList = [NSMutableArray array];
    for (JCDanmakuModel *danmaku in _msgList) {
        if (danmaku.createTime < time) {
            [abandonList addObject:danmaku];
        }
    }
    if (abandonList.count > 0) {
        [self removeDanmakus:abandonList];
    }
}

@end
