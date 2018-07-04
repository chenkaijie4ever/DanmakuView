//
//  DemoTwoViewController.m
//  DanmakuView
//
//  Created by Chenkaijie on 2018/7/4.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "DemoTwoViewController.h"
#import "JCDanmakuView.h"
#import "NobleDanmakuModel.h"
#import "NobleDanmakuViewCell.h"

@interface DemoTwoViewController () <JCDanmakuViewDelegate, JCDanmakuViewDataSource>

@property (nonatomic, strong) JCDanmakuView *danmakuView;

@end

@implementation DemoTwoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"DemoTwo";
    
    [self initUI];
}

- (void)initUI {
    
    UIButton *addPlainDanmakuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addPlainDanmakuBtn setTitle:@"添加普通弹幕" forState:UIControlStateNormal];
    [addPlainDanmakuBtn sizeToFit];
    addPlainDanmakuBtn.center = CGPointMake(self.view.center.x, self.view.center.y + 100.f);
    [addPlainDanmakuBtn addTarget:self action:@selector(addPlainDanmaku) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPlainDanmakuBtn];
    
    UIButton *addNobleDanmakuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addNobleDanmakuBtn setTitle:@"添加贵族弹幕" forState:UIControlStateNormal];
    [addNobleDanmakuBtn sizeToFit];
    addNobleDanmakuBtn.center = CGPointMake(self.view.center.x, self.view.center.y + 140.f);
    [addNobleDanmakuBtn addTarget:self action:@selector(addNobleDanmaku) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addNobleDanmakuBtn];
    
    UISwitch *switchControl = [UISwitch new];
    switchControl.center = CGPointMake(self.view.center.x, self.view.center.y + 200.f);
    [switchControl setOn:YES];
    [switchControl addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchControl];
    
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

- (void)onSwitch:(UISwitch *)sender {
    
    _danmakuView.enable = [sender isOn];
}

- (void)addPlainDanmaku {
    
    NSString *message = nil;
    switch (arc4random_uniform(4)) {
        case 0:
            message = @"嘤";
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

- (void)addNobleDanmaku {
    
    NobleDanmakuElementType type = arc4random_uniform(4) + 1;
    NSString *message = nil;
    switch (arc4random_uniform(4)) {
        case 0:
            message = @"嘤";
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
    NobleDanmakuModel *model = [NobleDanmakuModel new];
    model.message = message;
    model.iconUrl = @"";
    model.elementType = type;
    [_danmakuView addDanmaku:model priority:DanmakuPriority_Default];
}

- (NSTimeInterval)durationOfDanmuku:(id)danmakuModel {
    
    if ([danmakuModel isKindOfClass:[NSString class]]) {
        NSString *message = (NSString *)danmakuModel;
        if (message.length > 10) {
            return 5;
        } else if (message.length > 5) {
            return 6;
        } else {
            return 7;
        }
    } else if ([danmakuModel isKindOfClass:[NobleDanmakuModel class]]) {
        NSString *message = ((NobleDanmakuModel *)danmakuModel).message;
        if (message.length > 10) {
            return 8;
        } else if (message.length > 5) {
            return 9;
        } else {
            return 10;
        }
    }
    return 0;
}

- (CGSize)estimatedSizeForItem:(id)danmakuModel {
    
    if ([danmakuModel isKindOfClass:[NSString class]]) {
        NSString *message = (NSString *)danmakuModel;
        CGSize messsageSize = [message boundingRectWithSize:CGSizeMake(FLT_MAX, 0.0f)
                                                    options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f]}
                                                    context:nil].size;
        return messsageSize;
    } else if ([danmakuModel isKindOfClass:[NobleDanmakuModel class]]) {
        return [NobleDanmakuViewCell estimatedSizeForItem:danmakuModel];
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
    } else if ([danmakuModel isKindOfClass:[NobleDanmakuModel class]]) {
        NobleDanmakuViewCell *cell = [[NobleDanmakuViewCell alloc] initWithFrame:CGRectMake(0, 0, estimatedSize.width, estimatedSize.height)];
        [cell setDataSource:danmakuModel];
        return cell;
    }
    return [JCDanmakuViewCell new];
}

static NSArray<NSString *> *dirtyWords = nil;

- (BOOL)danmakuViewShouldSendDanmaku:(id)danmakuModel {

    if (!dirtyWords) {
        dirtyWords = @[@"嘤", @"卧槽"];
    }
    
    NSString *message = nil;
    if ([danmakuModel isKindOfClass:[NSString class]]) {
        message = (NSString *)danmakuModel;
    } else if ([danmakuModel isKindOfClass:[NobleDanmakuModel class]]) {
        message = ((NobleDanmakuModel *)danmakuModel).message;
    }
    if ([dirtyWords containsObject:message]) {
        NSLog(@"Hit dirty word.");
        return NO;
    }
    return YES;
}

- (void)danmakuView:(JCDanmakuView *)danmakuView didSelectDanmaku:(id)danmakuModel {
    
    NSString *message = nil;
    NSString *title = nil;
    if ([danmakuModel isKindOfClass:[NSString class]]) {
        message = (NSString *)danmakuModel;
        title = @"点击了普通弹幕";
    } else if ([danmakuModel isKindOfClass:[NobleDanmakuModel class]]) {
        message = ((NobleDanmakuModel *)danmakuModel).message;
        title = @"点击了贵族弹幕";
    }
    if (message.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:[NSString stringWithFormat:@"内容为:%@", message]
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
