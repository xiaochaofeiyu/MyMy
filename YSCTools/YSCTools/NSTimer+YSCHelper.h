//
//  NSTimer+YSCHelper.h
//  YSCTools
//
//  Created by yushichao on 16/7/29.
//  Copyright © 2016年 MMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer(YSCHelper)
/*
目的:想让这个 NSTimer 一直输出，直到 self 销毁了才停止
即在self的delloc方法中调用invalidate方法，timer停止；系统的timer则不会停止，若想停止，则在viewDidDisappear中停止，而非delloc
 - (void) viewDidDisappear:(BOOL)animated
 {
 [_timer invalidate];
 _timer = nil;
 }
 */
+ (NSTimer *)ysc_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
+ (NSTimer *)ysc_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
@end
