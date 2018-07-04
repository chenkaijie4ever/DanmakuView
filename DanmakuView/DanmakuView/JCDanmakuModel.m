//
//  JCDanmakuModel.m
//  HuaYang
//
//  Created by Chenkaijie on 2018/7/4.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "JCDanmakuModel.h"
#import "JCDanmakuViewDefine.h"

@implementation JCDanmakuModel

+ (instancetype)modelWithData:(id)data {
    
    JCDanmakuModel *model = [JCDanmakuModel new];
    model.data = data;
    model.createTime = JCLocalUTCTime;
    return model;
}

@end
