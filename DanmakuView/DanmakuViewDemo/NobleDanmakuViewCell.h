//
//  NobleDanmakuViewCell.h
//  DanmakuView
//
//  Created by jakchen on 2018/7/4.
//  Copyright © 2018年 ckj. All rights reserved.
//

#import "JCDanmakuViewCell.h"
#import "NobleDanmakuModel.h"

@interface NobleDanmakuViewCell : JCDanmakuViewCell

@property (nonatomic, strong, readonly) NobleDanmakuModel *model;

- (void)setDataSource:(NobleDanmakuModel *)model;

+ (CGSize)estimatedSizeForItem:(NobleDanmakuModel *)model;

@end
