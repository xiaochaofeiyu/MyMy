//
//  ViewControllerRuntimeTest.m
//  RuntimeLearn
//
//  Created by yushichao on 16/3/25.
//  Copyright © 2016年 yushichao. All rights reserved.
//

#import "ViewControllerRuntimeTest.h"
#import <objc/runtime.h>

@implementation ViewControllerHelper

- (void)method2
{
    NSLog(@"%@, %p", self, _cmd);
}

- (void)method3
{
    NSLog(@"%@, %p", self, _cmd);
}

@end

@interface ViewControllerRuntimeTest ()

@property (nonatomic, strong) ViewControllerHelper *helper;
@end

@implementation ViewControllerRuntimeTest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _helper = [[ViewControllerHelper alloc] init];
    
//    objc_property_t tt = class_getProperty([self class], "view");
    
    [self performSelectorOnMainThread:@selector(method3) withObject:@"haha" waitUntilDone:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logg:(NSString *)str
{
    NSLog(@"logg");
}

void functionForMethod1(id self, SEL _cmd, NSString *str) {
    NSLog(@"%@, %p, %@", self, _cmd, str);
}

//以[object message]的方式调用方法，如果object无法响应message消息时，编译器会报错。但如果是以perform…的形式来调用，则需要等到运 行时才能确定object是否能接收message消息,performSelector式方找不到对应方法，走到以下函数;

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    NSString *selectorString = NSStringFromSelector(sel);
    
    if ([selectorString isEqualToString:@"method1:"]) {
        class_addMethod(self.class, @selector(method1:), (IMP)functionForMethod1, "@:@");
    }
    
    return [super resolveInstanceMethod:sel];
}

//上面的处理不了，掉到这
- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    NSLog(@"forwardingTargetForSelector");
    
    NSString *selectorString = NSStringFromSelector(aSelector);
    
    // 将消息转发给_helper来处理
    if ([selectorString isEqualToString:@"method2"]) {
        return _helper;
    }
    
    return [super forwardingTargetForSelector:aSelector];
}

//还是处理不了，走这
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    
    if (!signature) {
        if ([ViewControllerHelper instancesRespondToSelector:aSelector]) {
            signature = [ViewControllerHelper instanceMethodSignatureForSelector:aSelector];
        }
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([ViewControllerHelper instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_helper];
    }
}

@end
