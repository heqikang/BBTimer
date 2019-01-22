//
//  BBProxy.h
//  timer
//
//  Created by 程肖斌 on 2019/1/22.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBProxy : NSProxy

+ (BBProxy *)proxyWithTarget:(id)target;

@end
