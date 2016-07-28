//
//  NSObject+YSCRuntime.h
//  YSCTools
//
//  Created by yushichao on 16/7/26.
//  Copyright © 2016年 MMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(YSCRuntime)

- (NSString *)nameWithInstance:(id)instance;
- (void)getProperty;
@end
