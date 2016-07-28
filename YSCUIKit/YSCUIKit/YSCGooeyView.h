//
//  YSCGooeyView.h
//  GooeySlideMenuDemo
//
//  Created by yushichao on 16/6/1.
//  Copyright © 2016年 MMS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BaiduHKGooeyPopupDirection) {
    BaiduHKGooeyPopupDirectionUp        = 0,    //从上面弹出
    BaiduHKGooeyPopupDirectionDown      = 1,    //从下面弹出
    BaiduHKGooeyPopupDirectionLeft      = 2,    //从左边弹出
    BaiduHKGooeyPopupDirectionRight     = 3     //从右面弹出
};

typedef void(^GooeyViewShowCompletedBlock)(void);
typedef void(^GooeyViewDismissCompletedBlock)(void);

@interface YSCGooeyView : UIView

@property (nonatomic, strong) UIView *contentView;// 子视图须加在contentView上
@property (nonatomic, copy) GooeyViewShowCompletedBlock showBlock;
@property (nonatomic, copy) GooeyViewDismissCompletedBlock dismissBlock;

/*!
 @method
 
 @abstract
 初始化页面
 @param frame              origin参数不起作用，可设为0，0；size代表大小，最好有一边和屏幕相等
 @param popupDirection     弹出方向
 */
- (instancetype)initWithFrame:(CGRect)frame Direction:(BaiduHKGooeyPopupDirection)popupDirection shouldHaveBackgroundView:(BOOL)shouldHaveBackgroundView backgroundColor:(UIColor *)backgroundColor;

/*!
 @method
 
 @abstract
 弹出页面
 @param showBlock          弹出完成后回掉方法
 */
- (void)gooeyShowWithCompleteBlock:(GooeyViewShowCompletedBlock)showBlock;

/*!
 @method
 
 @abstract
 消除页面
 @param dismissBlock       页面消失后回掉方法
 */
- (void)gooeyDismissWithCompleteBlock:(GooeyViewDismissCompletedBlock)dismissBlock;
@end
