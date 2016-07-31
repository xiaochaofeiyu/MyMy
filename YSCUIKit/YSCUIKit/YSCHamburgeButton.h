//
//  YSCHamburgeButton.h
//  YSCUIKit
//
//  Created by yushichao on 16/7/29.
//  Copyright © 2016年 MMS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, YSCHamburgeButtonShowType) {
    YSCHamburgeButtonShowTypeHamburge           = 0,
    YSCHamburgeButtonShowTypeCancel       = 1,
};

@interface YSCHamburgeButton : UIButton

@property (nonatomic, assign) YSCHamburgeButtonShowType showType;
- (void)showInParentView:(UIView *)parentView withArea:(UIEdgeInsets)viewEdgeInsets withShowType:(YSCHamburgeButtonShowType)showType;
@end
