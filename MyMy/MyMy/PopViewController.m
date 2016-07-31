//
//  PopViewController.m
//  MyMy
//
//  Created by yushichao on 16/7/29.
//  Copyright © 2016年 MMS. All rights reserved.
//

#import "PopViewController.h"
#import "YSCTools.h"

@interface PopViewController ()

@property (nonatomic, strong) NSTimer *ysctimer;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation PopViewController

//- (void)dealloc
//{
//    [_ysctimer invalidate];
//    [_timer invalidate];
//    NSLog(@"delloc");
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    
//    _ysctimer = [NSTimer ysc_scheduledTimerWithTimeInterval:0.5 block:^{
//        NSLog(@"ysctime fire");
//    } repeats:YES];
//    [_ysctimer fire];
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
    [_timer fire];
}

-(void)timerFire:(id)userinfo {
    NSLog(@"time Fire");
}

- (void) viewDidDisappear:(BOOL)animated
{
    [_timer invalidate];
    _timer = nil;
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
