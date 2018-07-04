//
//  JCDanmakuViewCell+Protected.h
//  HuaYang
//
//  Created by Chenkaijie on 2018/7/4.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "JCDanmakuViewCell.h"
#import "JCDanmakuModel.h"

@interface JCDanmakuViewCell (Protected)

- (JCDanmakuModel *)wrapperModel;
- (void)setWrapperModel:(JCDanmakuModel *)wrapperModel;

@end
