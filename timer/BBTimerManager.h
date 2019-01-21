//
//  BBTimerManager.h
//  timer
//
//  Created by 程肖斌 on 2019/1/21.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBTimerManager : NSObject

//获取实例对象
+ (BBTimerManager *)manager;

/*
    计时器；
    duration：周期，例如没隔1秒执行一次回调
    callback：回调
*/
- (void)count:(double)duration
     callback:(void(^)(void))callback;

/*
    正计时；
    from：从什么时候开始，例如从0开始计时
    duration：周期，例如1s，意思是说1秒执行一次回调
    step：步进，例如为1，表示每次回调，都会累加1
    callback：回调
*/
- (void)increase:(double)from
        duration:(double)duration
            step:(double)step
        callback:(void(^)(double index))callback;

/*
    反计时；
    from：从什么时候开始，例如从10开始计时
    duration：周期，例如1s，意思是说1秒执行一次回调
    step：步进，例如为1，表示每次回调，都会递减1
    callback：回调
*/
- (void)decrease:(double)from
        duration:(double)duration
            step:(double)step
        callback:(void(^)(double index))callback;


/*
    displayLink，用于页面刷新
    frame：表示每隔多少帧执行一次回调;
    例如设置成5，那么每隔5帧执行一次callback;
    系统刷新频率是一秒60帧，所以设置成5就是一秒执行12(60 / 5)次callback，依次类推
    callback：回调
*/
- (void)displaylinkWithFrame:(NSInteger)frame
                    callback:(void (^)(void))callback;

//同上，这里的fram指一秒内执行几次回调
- (void)displaylinkWithDuration:(NSInteger)frame
                       callback:(void (^)(void))callback;

//重置NSTimer的runloopMode，若不设置，默认是commonMode
- (void)timerMode:(NSRunLoopMode)mode;

//重置CADisplaylink的runloopMode，若不设置，默认是commonMode
- (void)displaylinkMode:(NSRunLoopMode)mode;

//重置CADisplaylink的帧数，若不设置，默认是1秒60帧,ios10以下设置
- (void)displaylinkFrame:(NSInteger)frame;

//重置帧数，ios10以上设置，上面那个方法和下面这个随便设置一个就行
- (void)preferredFramesPerSecond:(NSInteger)frame;

//销毁计时器
- (void)destory;

//暂停执行
- (void)pause;

//继续执行
- (void)goOn;

//是否是暂停状态
- (BOOL)isPause;

@end
