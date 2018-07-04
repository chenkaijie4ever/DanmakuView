//
//  NobleDanmakuModel.h
//  DanmakuView
//
//  Created by jakchen on 2018/7/4.
//  Copyright © 2018年 ckj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NobleDanmakuElementType) {
    
    NobleDanmakuElementType_None = 0,
    NobleDanmakuElementType_Silver,
    NobleDanmakuElementType_Gold,
    NobleDanmakuElementType_Platinum,
    NobleDanmakuElementType_Diamond,
};

@interface NobleDanmakuModel : NSObject

@property (nonatomic, assign) NobleDanmakuElementType elementType;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *message;

@end
