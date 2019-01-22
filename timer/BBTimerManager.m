//
//  BBTimerManager.m
//  timer
//
//  Created by 程肖斌 on 2019/1/21.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBProxy.h"
#import "BBTimerManager.h"

@interface BBTimerManager()
@property(nonatomic, strong) NSTimer       *timer;
@property(nonatomic, strong) CADisplayLink *link;

@property(nonatomic, assign) double count; //当前值
@property(nonatomic, assign) double step;  //每次添加的间隔

@property(nonatomic, strong) void(^callback)(double index);
@property(nonatomic, strong) void(^countBlock)(void);

@property(nonatomic, assign) BOOL is_pause;//是否暂停
@end

@implementation BBTimerManager

+ (BBTimerManager *)manager{
    return [[self alloc] init];
}


- (void)count:(double)duration
     callback:(void(^)(void))callback{
    NSAssert(callback, @"请设置回调");
    callback();
    self.countBlock = callback;
    BBProxy *proxy  = [BBProxy proxyWithTarget:self];
    self.timer = [NSTimer timerWithTimeInterval:duration
                                         target:proxy
                                       selector:@selector(timeCount)
                                       userInfo:nil
                                        repeats:YES];
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)increase:(double)from
        duration:(double)duration
            step:(double)step
        callback:(void(^)(double index))callback{
    NSAssert(callback, @"请设置回调");
    callback(from);
    self.count = from;
    self.step  = step;
    self.callback  = callback;
    BBProxy *proxy = [BBProxy proxyWithTarget:self];
    self.timer = [NSTimer timerWithTimeInterval:duration
                                         target:proxy
                                       selector:@selector(increase)
                                       userInfo:nil
                                        repeats:YES];
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)decrease:(double)from
        duration:(double)duration
            step:(double)step
        callback:(void(^)(double index))callback{
    NSAssert(callback, @"请设置回调");
    callback(from);
    self.count = from;
    self.step  = step;
    self.callback  = callback;
    BBProxy *proxy = [BBProxy proxyWithTarget:self];
    self.timer = [NSTimer timerWithTimeInterval:duration
                                         target:proxy
                                       selector:@selector(decrease)
                                       userInfo:nil
                                        repeats:YES];
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)displaylinkWithFrame:(NSInteger)frame
                    callback:(void (^)(void))callback{
    NSAssert(callback, @"请设置回调");
    callback();
    self.countBlock = callback;
    BBProxy *proxy  = [BBProxy proxyWithTarget:self];
    self.link = [CADisplayLink displayLinkWithTarget:proxy
                                            selector:@selector(timeCount)];
    [self displaylinkFrame:frame];
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [self.link addToRunLoop:loop forMode:NSRunLoopCommonModes];
}

//同上，这里的frame指一秒内执行几次回调
- (void)displaylinkWithDuration:(NSInteger)frame
                       callback:(void (^)(void))callback{
    NSAssert(callback, @"请设置回调");
    callback();
    self.countBlock = callback;
    BBProxy *proxy  = [BBProxy proxyWithTarget:self];
    self.link = [CADisplayLink displayLinkWithTarget:proxy
                                            selector:@selector(timeCount)];
    [self preferredFramesPerSecond:frame];
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [self.link addToRunLoop:loop forMode:NSRunLoopCommonModes];
}

- (void)timerMode:(NSRunLoopMode)mode{
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop addTimer:self.timer forMode:mode];
}

- (void)displaylinkMode:(NSRunLoopMode)mode{
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [self.link addToRunLoop:loop forMode:mode];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)displaylinkFrame:(NSInteger)frame{
    if(@available(iOS 10.0, *)){self.link.preferredFramesPerSecond = 60 / MAX(frame, 1);}
    else{self.link.frameInterval = frame;}
}

- (void)preferredFramesPerSecond:(NSInteger)frame{
    if(@available(iOS 10.0, *)){self.link.preferredFramesPerSecond = frame;}
    else{self.link.frameInterval = 60 * frame;}
}
#pragma clang diagnostic pop

- (void)destory{
    [self.timer invalidate];
    self.timer = nil;
    
    [self.link invalidate];
    self.link = nil;
}

- (void)pause{
    [self.timer setFireDate:[NSDate distantFuture]];
    self.link.paused = YES;
    self.is_pause    = YES;
}

- (void)goOn{
    [self.timer setFireDate:[NSDate distantPast]];
    self.link.paused = NO;
    self.is_pause    = NO;
}

- (BOOL)isPause{
    return self.is_pause;
}

- (void)increase{
    self.count += self.step;
    self.callback(self.count);
}

- (void)decrease{
    self.count -= self.step;
    self.callback(self.count);
}

- (void)timeCount{
    self.countBlock();
}

- (void)dealloc{
    [self destory];
    NSLog(@"%@销毁了",[self class]);
}

@end
