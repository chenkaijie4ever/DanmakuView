//
//  ViewController.m
//  DanmakuView
//
//  Created by jakchen on 2018/7/4.
//  Copyright © 2018年 ckj. All rights reserved.
//

#import "ViewController.h"
#import "DemoOneViewController.h"
#import "DemoTwoViewController.h"

typedef NS_ENUM(NSInteger, RowTag) {
    
    RowTag_DemoOne = 0,
    RowTag_DemoTwo,
    RowTag_NumberOfRows,
};

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Danmaku";
    
    [self initUI];
}

- (void)initUI {
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DanmakuCell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return RowTag_NumberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DanmakuCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case RowTag_DemoOne: {
            cell.textLabel.text = @"使用范例 1";
            cell.tag = RowTag_DemoOne;
        }
            break;
        case RowTag_DemoTwo: {
            cell.textLabel.text = @"使用范例 2";
            cell.tag = RowTag_DemoTwo;
        }
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch ([tableView cellForRowAtIndexPath:indexPath].tag) {
        case RowTag_DemoOne: {
            DemoOneViewController *vc = [DemoOneViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case RowTag_DemoTwo: {
            DemoTwoViewController *vc = [DemoTwoViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
        default:
            break;
    }
}

@end
