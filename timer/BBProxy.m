//
//  BBProxy.m
//  timer
//
//  Created by 程肖斌 on 2019/1/22.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import "BBProxy.h"

@interface BBProxy()
@property(nonatomic, weak) id target;
@end

@implementation BBProxy

+ (BBProxy *)proxyWithTarget:(id)target{
    BBProxy *proxy = [self alloc];
    proxy.target   = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    [invocation invokeWithTarget:self.target];
}

@end
