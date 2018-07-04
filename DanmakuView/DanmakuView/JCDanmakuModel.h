//
//  JCDanmakuModel.h
//  HuaYang
//
//  Created by Chenkaijie on 2018/7/4.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCDanmakuModel : NSObject

/** 进入缓存队列时间 */
@property (nonatomic, assign) NSTimeInterval createTime;
/** 发送时间 */
@property (nonatomic, assign) NSTimeInterval sendTime;
/** 持续时长 */
@property (nonatomic, assign) NSTimeInterval duration;
/** 所在轨道 */
@property (nonatomic, assign) NSInteger track;

/** 绑定数据 */
@property (nonatomic, strong) id data;

+ (instancetype)modelWithData:(id)data;

@end
