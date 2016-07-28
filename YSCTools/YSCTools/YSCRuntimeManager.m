//
//  YSCRuntimeManager.m
//  YSCTools
//
//  Created by yushichao on 16/7/26.
//  Copyright © 2016年 MMS. All rights reserved.
//

#import "YSCRuntimeManager.h"
#import <objc/runtime.h>

@implementation YSCRuntimeManager

+ (YSCRuntimeManager *)sharedManager
{
    static YSCRuntimeManager *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[YSCRuntimeManager alloc] init];
    });
    return handler;
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    if (sel == @selector(learnClass:)) {
        class_addMethod(object_getClass(self), sel, class_getMethodImplementation(object_getClass(self), @selector(myClassMethod:)), "v@:");
        return YES;
    }
    return [class_getSuperclass(self) resolveClassMethod:sel];
}

+ (BOOL)resolveInstanceMethod:(SEL)aSEL
{
    if (aSEL == @selector(goToSchool:)) {
        class_addMethod([self class], aSEL, class_getMethodImplementation([self class], @selector(myInstanceMethod:)), "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:aSEL];
}

+ (void)myClassMethod:(NSString *)string {
    NSLog(@"myClassMethod = %@", string);
}

- (void)myInstanceMethod:(NSString *)string {
    NSLog(@"myInstanceMethod = %@", string);
}

@end
