# About DanmakuView

A lightweight Danmaku component for iOS.

## How to import into your project

Just drag the 'DanmakuView' folder to your project.

## How to use it

you can initial the widget in Objective-C code in this way:

```objective-c

JCDanmakuView *danmakuView = [[JCDanmakuView alloc] initWithFrame:self.view.frame];
danmakuView.dataSource = self;
danmakuView.delegate = self;
[self.view addSubview:danmakuView];

```
you can also control the danmakuView's appearance using custom configuration:

```objective-c

JCDanmakuConfiguration *configuration = [JCDanmakuConfiguration defaultConfiguration];
configuration.heightOfTrack = 50;
configuration.numberOfTracks = 4;
configuration.intervalOfDanmaku = 0.1f;
...

JCDanmakuView *danmakuView = [[JCDanmakuView alloc] initWithFrame:self.view.frame danmakuConfiguration:configuration];
danmakuView.dataSource = self;
danmakuView.delegate = self;
[self.view addSubview:danmakuView];

```
Of cource, JCDanmakuViewDataSource is required. This protocol represents the data model object.

```objective-c

@protocol JCDanmakuViewDataSource <NSObject>

@required
- (NSTimeInterval)durationOfDanmuku:(id)danmakuModel;
- (CGSize)estimatedSizeForItem:(id)danmakuModel;
- (__kindof JCDanmakuViewCell *)danmakuView:(JCDanmakuView *)danmakuView cellForItem:(id)danmakuModel estimatedSize:(CGSize)estimatedSize;

@end

```
The protocol JCDanmakuViewDelegate provide event's callback, it is optional. Typically, we implement our business logic here.

```objective-c

@protocol JCDanmakuViewDelegate <NSObject>

@optional
- (void)danmakuView:(JCDanmakuView *)danmakuView didSelectDanmaku:(id)danmakuModel;
- (BOOL)danmakuViewShouldSendDanmaku:(id)danmakuModel;
- (void)danmakuViewWillEnterForeground:(JCDanmakuView *)danmakuView;

@end

```
## What does it look like

<img src="https://github.com/chenkaijie4ever/DanmakuView/blob/master/ScreenShot/1.gif" width="571" />

## Author

Chen Kaijie

chenkaijie4ever@gmail.com


## LICENSE

Copyright 2018 Chen Kaijie

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

