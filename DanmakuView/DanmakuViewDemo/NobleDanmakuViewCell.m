//
//  NobleDanmakuViewCell.m
//  DanmakuView
//
//  Created by jakchen on 2018/7/4.
//  Copyright © 2018年 ckj. All rights reserved.
//

#import "NobleDanmakuViewCell.h"

#define AvatarDecorateImageViewWidth    34.f
#define AvatarDecorateImageViewHeight   40.f

#define MessageLabelFontSize            15.f
#define MessageLabelMarginLeft          3.f
#define MessageLabelMarginRight         10.f

@interface NobleDanmakuViewCell ()

@property (nonatomic, strong, readwrite) NobleDanmakuModel *model;

@property (nonatomic, strong) UIImageView *messageBgImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *avatarDecorateImageView;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation NobleDanmakuViewCell

+ (CGFloat)estimatedHeight {
    
    return 34.f;
}

+ (CGSize)estimatedSizeForItem:(NobleDanmakuModel *)model {
    
    CGFloat avatarDecorateImageViewWidth = AvatarDecorateImageViewWidth;
    CGFloat messageWidth = [self messageWidthWithModel:model];
    CGFloat totalWidth = avatarDecorateImageViewWidth + MessageLabelMarginLeft + messageWidth + MessageLabelMarginRight;
    return CGSizeMake(totalWidth, [self estimatedHeight]);
}

+ (CGFloat)messageWidthWithModel:(NobleDanmakuModel *)model {
    
    NSString *message = model.message.length > 0 ? model.message : @" ";
    CGFloat messageWidth = [message boundingRectWithSize:CGSizeMake(FLT_MAX, [self estimatedHeight])
                                                 options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:MessageLabelFontSize]}
                                                 context:nil].size.width;
    return messageWidth;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.contentView.layer.masksToBounds = NO;
        
        CGFloat estimatedHeight = [NobleDanmakuViewCell estimatedHeight];
        
        _messageBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 34.f)];
        [self.contentView addSubview:_messageBgImageView];
        
        CGFloat avatarMargin = 3.f;
        CGFloat avatarSize = estimatedHeight - 2 * avatarMargin;
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(avatarMargin, avatarMargin, avatarSize, avatarSize)];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.cornerRadius = avatarSize / 2.0f;
        _avatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarImageView];
        
        _avatarDecorateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AvatarDecorateImageViewWidth, AvatarDecorateImageViewHeight)];
        _avatarDecorateImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_avatarDecorateImageView];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.numberOfLines = 1;
        _messageLabel.font = [UIFont systemFontOfSize:MessageLabelFontSize];
        [self.contentView addSubview:_messageLabel];
    }
    return self;
}

- (void)setDataSource:(NobleDanmakuModel *)model {
    
    if (_model != model) {
        _model = model;
        
        // Load image via url.
        [_avatarImageView setImage:[UIImage imageNamed:@"avatar.jpg"]];
        _messageLabel.text = _model.message.length > 0 ? _model.message : @" ";
        [self setupCustomStyle:_model];
        
        [self setNeedsLayout];
    }
}

- (void)setupCustomStyle:(NobleDanmakuModel *)model {
    
    UIImage *avatarDecorateImage = nil;
    UIImage *messageBgImage = nil;
    UIColor *messageTextColor = [UIColor whiteColor];
    switch (model.elementType) {
        case NobleDanmakuElementType_Gold: {
            avatarDecorateImage = [UIImage imageNamed:@"PhotoFrame_Gold@3x"];
            messageBgImage = [UIImage imageNamed:@"Bg_Gold@3x"];
        }
            break;
        case NobleDanmakuElementType_Platinum: {
            avatarDecorateImage = [UIImage imageNamed:@"PhotoFrame_Platinum@3x"];
            messageBgImage = [UIImage imageNamed:@"Bg_Platinum@3x"];
        }
            break;
        case NobleDanmakuElementType_Diamond: {
            avatarDecorateImage = [UIImage imageNamed:@"PhotoFrame_Diamond@3x"];
            messageBgImage = [UIImage imageNamed:@"Bg_Diamond@3x"];
            messageTextColor = [UIColor colorWithRed:(222 / 255.0) green:(199 / 255.0) blue:(87 / 255.0) alpha:1.0];
        }
            break;
        default:
        case NobleDanmakuElementType_Silver: {
            avatarDecorateImage = [UIImage imageNamed:@"PhotoFrame_Sliver@3x"];
            messageBgImage = [UIImage imageNamed:@"Bg_Sliver@3x"];
        }
            break;
    }
    CGFloat messageBgImageHalfHeight = messageBgImage.size.height / 2.0f;
    UIEdgeInsets messageBgImageEdgeInsets = UIEdgeInsetsMake(messageBgImageHalfHeight, 20.f, messageBgImageHalfHeight, 20.f);
    messageBgImage = [messageBgImage resizableImageWithCapInsets:messageBgImageEdgeInsets
                                                    resizingMode:UIImageResizingModeStretch];
    [_messageBgImageView setImage:messageBgImage];
    [_avatarDecorateImageView setImage:avatarDecorateImage];
    _messageLabel.textColor = messageTextColor;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat centerY = self.bounds.size.height / 2.f;
    
    CGRect avatarDecorateImageViewFrame = _avatarDecorateImageView.frame;
    avatarDecorateImageViewFrame.origin.x = 0;
    _avatarDecorateImageView.frame = avatarDecorateImageViewFrame;
    _avatarDecorateImageView.center = CGPointMake(_avatarDecorateImageView.center.x, centerY);
    
    _avatarImageView.center = CGPointMake(_avatarDecorateImageView.center.x, _avatarDecorateImageView.center.y + 1);
    
    [_messageLabel sizeToFit];
    CGRect messageLabelFrame = _messageLabel.frame;
    messageLabelFrame.origin.x = _avatarDecorateImageView.frame.origin.x + _avatarDecorateImageView.frame.size.width + MessageLabelMarginLeft;
    _messageLabel.frame = messageLabelFrame;
    _messageLabel.center = CGPointMake(_messageLabel.center.x, centerY);
    
    CGRect messageBgImageViewFrame = _messageBgImageView.frame;
    messageBgImageViewFrame.origin.x = _avatarDecorateImageView.center.x - 6.f;
    messageBgImageViewFrame.size.width = _messageLabel.frame.origin.x + _messageLabel.frame.size.width + MessageLabelMarginRight - _messageBgImageView.frame.origin.x;
    _messageBgImageView.frame = messageBgImageViewFrame;
    _messageBgImageView.center = CGPointMake(_messageBgImageView.center.x, centerY);
    
    
    CGRect selfFrame = self.frame;
    selfFrame.size.width = _messageBgImageView.frame.origin.x + _messageBgImageView.frame.size.width;
    self.frame = selfFrame;
    self.contentView.frame = self.bounds;
}

@end
