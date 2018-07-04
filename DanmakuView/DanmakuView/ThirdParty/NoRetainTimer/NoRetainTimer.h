//
//  NoRetainTimer.h
//  Common
//
//  Created by Chenkaijie on 2018/7/4.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoRetainTimer : NSObject

@property (nonatomic, strong) id userInfo;
@property (nonatomic, strong, readonly) NSTimer *timer;
+ (NoRetainTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;
+ (NoRetainTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;

- (void)invalidate;

@end
