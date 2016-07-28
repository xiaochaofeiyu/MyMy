//
//  YSCGooeyView.m
//  GooeySlideMenuDemo
//
//  Created by yushichao on 16/6/1.
//  Copyright © 2016年 MMS. All rights reserved.
//

#import "YSCGooeyView.h"

#define EXTRAAREA 50

@interface YSCGooeyView ()

@property (nonatomic,strong) CADisplayLink *displayLink;
@property  NSInteger animationCount; // 动画的数量
@end

@implementation YSCGooeyView {
    UIView *backgroundView;//接收点击事件消除试图
    UIView *helperCenterView;
    UIView *helperSideView;
    UIWindow *keyWindow;
    BOOL triggered;
    CGFloat diff;
    UIColor *_backgroundColor;
    BaiduHKGooeyPopupDirection _popupDirection;
    BOOL _shouldHaveBackgroundView;
}

- (instancetype)initWithFrame:(CGRect)frame Direction:(BaiduHKGooeyPopupDirection)popupDirection shouldHaveBackgroundView:(BOOL)shouldHaveBackgroundView backgroundColor:(UIColor *)backgroundColor
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundColor = backgroundColor;
        _popupDirection = popupDirection;
        _shouldHaveBackgroundView = shouldHaveBackgroundView;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor clearColor];
        [self insertSubview:_contentView atIndex:0];
        
        keyWindow = [[UIApplication sharedApplication] keyWindow];
        CGRect helperSideFrame = CGRectZero;
        CGRect helperCenterFrame = CGRectZero;
        CGRect selfFrame = CGRectZero;
        CGRect contentFrame = CGRectZero;
        if (BaiduHKGooeyPopupDirectionLeft == popupDirection) {
            helperSideFrame = CGRectMake(-40, 0, 40, 40);
            helperCenterFrame = CGRectMake(-40, CGRectGetHeight(frame)/2 - 20, 40, 40);
            selfFrame = CGRectMake(-frame.size.width - EXTRAAREA, 0, frame.size.width + EXTRAAREA, frame.size.height);
            contentFrame = frame;
        } else if (BaiduHKGooeyPopupDirectionRight == popupDirection) {
            helperSideFrame = CGRectMake(CGRectGetWidth(keyWindow.frame), 0, 40, 40);
            helperCenterFrame = CGRectMake(CGRectGetWidth(keyWindow.frame), CGRectGetHeight(frame)/2 - 20, 40, 40);
            selfFrame = CGRectMake(keyWindow.frame.size.width, 0, frame.size.width + EXTRAAREA, frame.size.height);
            contentFrame = CGRectMake(EXTRAAREA, 0, frame.size.width, frame.size.height);
        } else if (BaiduHKGooeyPopupDirectionUp == popupDirection) {
            helperSideFrame = CGRectMake(0, -40, 40, 40);
            helperCenterFrame = CGRectMake(CGRectGetWidth(frame)/2 - 20, -40, 40, 40);
            selfFrame = CGRectMake(0, - frame.size.height - EXTRAAREA, frame.size.width, frame.size.height + EXTRAAREA);
            contentFrame = frame;
        } else if (BaiduHKGooeyPopupDirectionDown == popupDirection) {
            helperSideFrame = CGRectMake(0, CGRectGetHeight(keyWindow.frame), 40, 40);
            helperCenterFrame = CGRectMake(CGRectGetWidth(frame)/2 - 20, CGRectGetHeight(keyWindow.frame), 40, 40);
            selfFrame = CGRectMake(0, keyWindow.frame.size.height, frame.size.width, frame.size.height + EXTRAAREA);
            contentFrame = CGRectMake(0, EXTRAAREA, frame.size.width, frame.size.height);
        }
        helperSideView = [[UIView alloc]initWithFrame:helperSideFrame];
        helperSideView.backgroundColor = [UIColor clearColor];
        helperSideView.hidden = NO;
        [keyWindow addSubview:helperSideView];
        
        helperCenterView = [[UIView alloc]initWithFrame:helperCenterFrame];
        helperCenterView.backgroundColor = [UIColor clearColor];
        helperCenterView.hidden = NO;
        [keyWindow addSubview:helperCenterView];
        
        _contentView.frame = contentFrame;
        self.frame = selfFrame;
        self.backgroundColor = [UIColor clearColor];
        
        if (shouldHaveBackgroundView) {
            backgroundView = [[UIView alloc]initWithFrame:keyWindow.bounds];
            backgroundView.backgroundColor = [UIColor blackColor];
            backgroundView.alpha = 0.0;
            backgroundView.userInteractionEnabled = YES;
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundViewTapGesture:)];
            [backgroundView addGestureRecognizer:gesture];
        }
    }
    
    return self;
}

-(void)gooeyShowWithCompleteBlock:(GooeyViewShowCompletedBlock)showBlock
{
    if (!self.superview) {
        [keyWindow insertSubview:self belowSubview:helperSideView];
    }
    if (_shouldHaveBackgroundView && !backgroundView.superview) {
        [keyWindow insertSubview:backgroundView belowSubview:self];
    }

    CGPoint helperSideViewEndCenter = CGPointZero;
    CGPoint helperCenterViewEndCenter = CGPointZero;
    CGPoint selfCenter = CGPointZero;
    if (BaiduHKGooeyPopupDirectionLeft == _popupDirection) {
        helperSideViewEndCenter = CGPointMake(self.frame.size.width - EXTRAAREA, helperSideView.frame.size.height / 2);
        helperCenterViewEndCenter = CGPointMake(self.frame.size.width - EXTRAAREA, self.frame.size.height / 2);
        selfCenter = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    } else if (BaiduHKGooeyPopupDirectionRight == _popupDirection) {
        helperSideViewEndCenter = CGPointMake(keyWindow.frame.size.width - self.frame.size.width + EXTRAAREA, helperSideView.frame.size.height / 2);
        helperCenterViewEndCenter = CGPointMake(keyWindow.frame.size.width - self.frame.size.width + EXTRAAREA, self.frame.size.height / 2);
        selfCenter = CGPointMake(keyWindow.frame.size.width - self.frame.size.width / 2, self.frame.size.height / 2);
    } else if (BaiduHKGooeyPopupDirectionUp == _popupDirection) {
        helperSideViewEndCenter = CGPointMake(helperSideView.frame.size.width / 2, self.frame.size.height - EXTRAAREA);
        helperCenterViewEndCenter = CGPointMake(self.frame.size.width / 2, self.frame.size.height - EXTRAAREA);
        selfCenter = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    } else if (BaiduHKGooeyPopupDirectionDown == _popupDirection) {
        helperSideViewEndCenter = CGPointMake(helperSideView.frame.size.width / 2, keyWindow.frame.size.height - self.frame.size.height + EXTRAAREA);
        helperCenterViewEndCenter = CGPointMake(self.frame.size.width / 2, keyWindow.frame.size.height - self.frame.size.height + EXTRAAREA);
        selfCenter = CGPointMake(self.frame.size.width / 2, keyWindow.frame.size.height - self.frame.size.height / 2);
    }
    
    self.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.center = selfCenter;
        self.alpha = 1.0;
        backgroundView.alpha = 0.3f;
    }];
    
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        helperSideView.center = helperSideViewEndCenter;
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        helperCenterView.center = helperCenterViewEndCenter;
    } completion:^(BOOL finished) {
        [self finishAnimation];
        if (showBlock) {
            showBlock();
        }
    }];
}

- (void)gooeyDismissWithCompleteBlock:(GooeyViewDismissCompletedBlock)dismissBlock
{
    CGRect helperSideFrame = CGRectZero;
    CGRect helperCenterFrame = CGRectZero;
    CGRect selfFrame = CGRectZero;
    if (BaiduHKGooeyPopupDirectionLeft == _popupDirection) {
        helperSideFrame = CGRectMake(-40, 0, 40, 40);
        helperCenterFrame = CGRectMake(-40, CGRectGetHeight(self.frame)/2 - 20, 40, 40);
        selfFrame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    } else if (BaiduHKGooeyPopupDirectionRight == _popupDirection) {
        helperSideFrame = CGRectMake(CGRectGetWidth(keyWindow.frame), 0, 40, 40);
        helperCenterFrame = CGRectMake(CGRectGetWidth(keyWindow.frame), CGRectGetHeight(self.frame)/2 - 20, 40, 40);
        selfFrame = CGRectMake(keyWindow.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    } else if (BaiduHKGooeyPopupDirectionUp == _popupDirection) {
        helperSideFrame = CGRectMake(0, -40, 40, 40);
        helperCenterFrame = CGRectMake(CGRectGetWidth(self.frame)/2 - 20, -40, 40, 40);
        selfFrame = CGRectMake(0, - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } else if (BaiduHKGooeyPopupDirectionDown == _popupDirection) {
        helperSideFrame = CGRectMake(0, CGRectGetHeight(keyWindow.frame), 40, 40);
        helperCenterFrame = CGRectMake(CGRectGetWidth(self.frame)/2 - 20, CGRectGetHeight(keyWindow.frame), 40, 40);
        selfFrame = CGRectMake(0, keyWindow.frame.size.height, self.frame.size.width, self.frame.size.height);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = selfFrame;
        self.alpha = 0.0;
        backgroundView.alpha = 0.0f;
    }];
    
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        helperSideView.frame = helperSideFrame;
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        helperCenterView.frame = helperCenterFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            [self finishAnimation];
            if (dismissBlock) {
                dismissBlock();
            }
        }
    }];
}

-(void)backgroundViewTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self gooeyDismissWithCompleteBlock:_dismissBlock];
    }
}

//动画之前调用
-(void)beforeAnimation{
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    self.animationCount ++;
}

//动画完成之后调用
-(void)finishAnimation{
    self.animationCount --;
    if (self.animationCount == 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

-(void)displayLinkAction:(CADisplayLink *)dis{
    
    CALayer *sideHelperPresentationLayer   =  (CALayer *)[helperSideView.layer presentationLayer];
    CALayer *centerHelperPresentationLayer =  (CALayer *)[helperCenterView.layer presentationLayer];
    
    CGRect centerRect = [[centerHelperPresentationLayer valueForKeyPath:@"frame"]CGRectValue];
    CGRect sideRect = [[sideHelperPresentationLayer valueForKeyPath:@"frame"]CGRectValue];
    
    if (BaiduHKGooeyPopupDirectionLeft == _popupDirection || BaiduHKGooeyPopupDirectionRight == _popupDirection) {
        diff = sideRect.origin.x - centerRect.origin.x;
    } else if (BaiduHKGooeyPopupDirectionUp == _popupDirection || BaiduHKGooeyPopupDirectionDown == _popupDirection) {
        diff = sideRect.origin.y - centerRect.origin.y;
    }
    
    //    NSLog(@"diff:%f",diff);
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    //画的图形的相对坐标系是本试图self
    if (BaiduHKGooeyPopupDirectionLeft == _popupDirection) {
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(self.frame.size.width-EXTRAAREA, 0)];
        [path addQuadCurveToPoint:CGPointMake(self.frame.size.width-EXTRAAREA, self.frame.size.height) controlPoint:CGPointMake(self.frame.size.width - EXTRAAREA + diff, self.frame.size.height/2)];
        [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
        [path closePath];
    } else if (BaiduHKGooeyPopupDirectionRight == _popupDirection) {
        [path moveToPoint:CGPointMake(self.frame.size.width, 0)];
        [path addLineToPoint:CGPointMake(EXTRAAREA, 0)];
        [path addQuadCurveToPoint:CGPointMake(EXTRAAREA, self.frame.size.height) controlPoint:CGPointMake(EXTRAAREA + diff, self.frame.size.height / 2)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
        [path closePath];
    } else if (BaiduHKGooeyPopupDirectionUp == _popupDirection) {
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(0, self.frame.size.height - EXTRAAREA)];
        [path addQuadCurveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - EXTRAAREA) controlPoint:CGPointMake(self.frame.size.width / 2, self.frame.size.height - EXTRAAREA + diff)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, 0)];
        [path closePath];
    } else if (BaiduHKGooeyPopupDirectionDown == _popupDirection) {
        [path moveToPoint:CGPointMake(0, self.frame.size.height)];
        [path addLineToPoint:CGPointMake(0, EXTRAAREA)];
        [path addQuadCurveToPoint:CGPointMake(self.frame.size.width, EXTRAAREA) controlPoint:CGPointMake(self.frame.size.width / 2, EXTRAAREA + diff)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
        [path closePath];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    [_backgroundColor set];
    CGContextFillPath(context);
}

@end
