//
//  NSObject+YSCRuntime.m
//  YSCTools
//
//  Created by yushichao on 16/7/26.
//  Copyright © 2016年 MMS. All rights reserved.
//

#import "NSObject+YSCRuntime.h"
#import <objc/runtime.h>

@implementation NSObject(YSCRuntime)

- (NSString *)nameWithInstance:(id)instance
{
    unsigned int numIvars = 0;
    NSString *key=nil;
    Ivar * ivars = class_copyIvarList([self class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        if ((object_getIvar(self, thisIvar) == instance)) {//此处若 crash 不要慌！
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
            NSLog(@"-- %@ --", key);
            break;
        }
    }
    free(ivars);
    return key;
}

- (void)getProperty
{
    id LenderClass = [self class];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(LenderClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        fprintf(stdout, "%s %s\n", property_getName(property), property_getAttributes(property));
    }
}

@end
