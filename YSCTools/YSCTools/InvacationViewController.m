//
//  InvacationViewController.m
//  RuntimeLearn
//
//  Created by yushichao on 16/4/6.
//  Copyright © 2016年 yushichao. All rights reserved.
//

#import "InvacationViewController.h"

@interface InvacationViewController ()

@end

@implementation InvacationViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    SEL myMethod = @selector(myLog:parm:parm:);
//    NSMethodSignature * sig  = [[self class] instanceMethodSignatureForSelector:myMethod];
//    NSInvocation * invocatin = [NSInvocation invocationWithMethodSignature:sig];
//    [invocatin setTarget:self];
//    [invocatin setSelector:myMethod];
//    InvacationViewController * view = self;
//    int a=1;
//    int b=2;
//    int c=3;
//    [invocatin setArgument:&view atIndex:0];
//    [invocatin setArgument:&myMethod atIndex:1];
//    [invocatin setArgument:&a atIndex:2];
//    [invocatin setArgument:&b atIndex:3];
//    [invocatin setArgument:&c atIndex:4];
//    [invocatin retainArguments];
//    
//    [invocatin invoke];
////    //我们将c的值设置为返回值
////    [invocatin setReturnValue:&c];
//    int d;
//    //取这个返回值
//    [invocatin getReturnValue:&d];
//    NSLog(@"%d",d);
//    
//}

-(int)myLog:(int)a parm:(int)b parm:(int)c{
    NSLog(@"MyLog%d:%d:%d",a,b,c);
    return a+b+c;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SEL myMethod = @selector(myLog);
    //创建一个函数签名，这个签名可以是任意的,但需要注意，签名函数的参数数量要和调用的一致。
    NSMethodSignature * sig  = [UIView instanceMethodSignatureForSelector:@selector(init)];
    //通过签名初始化
    NSInvocation * invocatin = [NSInvocation invocationWithMethodSignature:sig];
    //设置target
    [invocatin setTarget:self];
    //设置selecteor
    [invocatin setSelector:myMethod];
    //消息调用
    [invocatin invoke];
    
}
-(void)myLog{
    NSLog(@"MyLog");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
