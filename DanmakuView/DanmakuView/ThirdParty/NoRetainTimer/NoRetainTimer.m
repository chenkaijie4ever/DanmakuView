//
//  NoRetainTimer.m
//  Common
//
//  Created by Chenkaijie on 2018/7/4.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "NoRetainTimer.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface NoRetainTimer ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak)id target;
@property (nonatomic, assign) SEL selector;

@end

@implementation NoRetainTimer

+ (NoRetainTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo
{
    NoRetainTimer *timer = [[NoRetainTimer alloc] init];
    timer.userInfo = userInfo;
    [timer timerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    return timer;
}

+ (NoRetainTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo
{
    NoRetainTimer *timer = [[NoRetainTimer alloc] init];
    timer.userInfo = userInfo;
    [timer scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    return timer;
}

- (void)invalidate
{
    [self.timer invalidate];
}

- (void)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo
{
    self.target = aTarget;
    self.selector = aSelector;
    self.timer = [NSTimer timerWithTimeInterval:ti target:self selector:@selector(onTimer:) userInfo:userInfo repeats:yesOrNo];
}

- (void)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo
{
    self.target = aTarget;
    self.selector = aSelector;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(onTimer:) userInfo:userInfo repeats:yesOrNo];
}

- (void)onTimer:(NSTimer *)timer
{
    SuppressPerformSelectorLeakWarning(
        [self.target performSelector:self.selector withObject:self]
    );
}

@end
