//
//  JCDanmakuViewCell+Protected.h
//  HuaYang
//
//  Created by jakchen on 2018/5/4.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "JCDanmakuViewCell.h"
#import "JCDanmakuModel.h"

@interface JCDanmakuViewCell (Protected)

- (JCDanmakuModel *)wrapperModel;
- (void)setWrapperModel:(JCDanmakuModel *)wrapperModel;

@end
