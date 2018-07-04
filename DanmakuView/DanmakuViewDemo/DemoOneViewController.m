//
//  DemoOneViewController.m
//  DanmakuView
//
//  Created by jakchen on 2018/7/4.
//  Copyright © 2018年 ckj. All rights reserved.
//

#import "DemoOneViewController.h"
#import "JCDanmakuView.h"

@interface DemoOneViewController () <JCDanmakuViewDelegate, JCDanmakuViewDataSource>

@property (nonatomic, strong) JCDanmakuView *danmakuView;

@end

@implementation DemoOneViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"DemoOne";
    
    [self initUI];
}

- (void)initUI {
    
    UIButton *addPlainDanmakuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addPlainDanmakuBtn setTitle:@"添加普通弹幕" forState:UIControlStateNormal];
    [addPlainDanmakuBtn sizeToFit];
    addPlainDanmakuBtn.center = CGPointMake(self.view.center.x, self.view.center.y + 100.f);
    [addPlainDanmakuBtn addTarget:self action:@selector(addPlainDanmaku) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPlainDanmakuBtn];
    
    JCDanmakuConfiguration *configuration = [JCDanmakuConfiguration defaultConfiguration];
    configuration.heightOfTrack = 40;
    configuration.numberOfTracks = 5;
    _danmakuView = [[JCDanmakuView alloc] initWithFrame:CGRectMake(5, 150, self.view.bounds.size.width - 10, configuration.heightOfTrack * configuration.numberOfTracks)
                                   danmakuConfiguration:configuration];
    _danmakuView.dataSource = self;
    _danmakuView.delegate = self;
    _danmakuView.backgroundColor = [UIColor darkGrayColor];
    _danmakuView.userInteractionEnabled = YES;
    // _danmakuView.autoClearWhenEnterForeground = NO;
    [self.view addSubview:_danmakuView];
}

- (void)addPlainDanmaku {
    
    NSString *message = nil;
    switch (arc4random_uniform(4)) {
        case 0:
            message = @"嘤~";
            break;
        case 1:
            message = @"666666";
            break;
        case 2:
            message = @"主播有点东西，棒棒哒 💯";
            break;
        case 3:
            message = @"All work and no play makes Jack a dull boy.";
            break;
    }
    [_danmakuView addDanmaku:message priority:DanmakuPriority_Default];
}

- (NSTimeInterval)durationOfDanmuku:(id)danmakuModel {
    
    return 6;
}

- (CGSize)estimatedSizeForItem:(id)danmakuModel {
    
    if ([danmakuModel isKindOfClass:[NSString class]]) {
        NSString *message = (NSString *)danmakuModel;
        CGSize messsageSize = [message boundingRectWithSize:CGSizeMake(FLT_MAX, 0.0f)
                                                    options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f]}
                                                    context:nil].size;
        return messsageSize;
    }
    return CGSizeZero;
}

- (__kindof JCDanmakuViewCell *)danmakuView:(JCDanmakuView *)danmakuView cellForItem:(id)danmakuModel estimatedSize:(CGSize)estimatedSize {
    
    if ([danmakuModel isKindOfClass:[NSString class]]) {
        JCDanmakuViewCell *cell = [[JCDanmakuViewCell alloc] initWithFrame:CGRectMake(0, 0, estimatedSize.width, estimatedSize.height)];
        cell.textLabel.text = (NSString *)danmakuModel;
        cell.textLabel.textColor = [UIColor colorWithRed:(CGFloat)random() / (CGFloat)RAND_MAX
                                                   green:(CGFloat)random() / (CGFloat)RAND_MAX
                                                    blue:(CGFloat)random() / (CGFloat)RAND_MAX
                                                   alpha:1.0f];
        return cell;
    }
    return [JCDanmakuViewCell new];
}

- (void)danmakuView:(JCDanmakuView *)danmakuView didSelectDanmaku:(id)danmakuModel {
    
    if ([danmakuModel isKindOfClass:[NSString class]]) {
        NSString *message = (NSString *)danmakuModel;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"点击了弹幕"
                                                        message:[NSString stringWithFormat:@"内容为:%@", message]
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
