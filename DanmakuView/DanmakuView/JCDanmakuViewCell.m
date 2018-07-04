//
//  JCDanmakuViewCell.m
//  HuaYang
//
//  Created by Chenkaijie on 2018/7/4.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "JCDanmakuViewCell.h"
#import "JCDanmakuModel.h"

@interface JCDanmakuViewCell()

@property (nonatomic, readwrite, strong) UIView *contentView;
@property (nonatomic, readwrite, strong) UILabel *textLabel;
@property (nonatomic, readwrite, strong) JCDanmakuModel *wrapperModel;

@end

@implementation JCDanmakuViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.exclusiveTouch = YES;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.layer.masksToBounds = YES;
        [self addSubview:_contentView];
    }
    return self;
}

- (UILabel *)textLabel {
    
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.textColor = [UIColor whiteColor];
        [_contentView addSubview:_textLabel];
    }
    return _textLabel;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (_textLabel && _textLabel.superview) {
        [_textLabel sizeToFit];
        CGRect contentViewFrame = _contentView.frame;
        contentViewFrame.size = _textLabel.bounds.size;
        _contentView.frame = contentViewFrame;
    } else {
        _contentView.frame = self.bounds;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGRect presentationLayerFrame = self.layer.presentationLayer.frame;
    presentationLayerFrame.origin.x -= self.layer.frame.origin.x;
    presentationLayerFrame.origin.y -= self.layer.frame.origin.y;
    if (CGRectContainsPoint(presentationLayerFrame, point)) {
        return self;
    }
    return [super hitTest:point withEvent:event];
}

@end
