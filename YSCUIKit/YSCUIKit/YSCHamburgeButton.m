//
//  YSCHamburgeButton.m
//  YSCUIKit
//
//  Created by yushichao on 16/7/29.
//  Copyright © 2016年 MMS. All rights reserved.
//

#import "YSCHamburgeButton.h"

@interface YSCHamburgeButton ()

@property (nonatomic, strong) CAShapeLayer *topLineLayer;
@property (nonatomic, strong) CAShapeLayer *bottomLineLayer;
@property (nonatomic, strong) CAShapeLayer *middleLineLayer;
@end

@implementation YSCHamburgeButton {
    CGFloat _menuStrokeStart;
    CGFloat _menuStrokeEnd;
    CGFloat _hamburgerStrokeStart;
    CGFloat _hamburgerStrokeEnd;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        _menuStrokeStart = 0.325;
        _menuStrokeEnd = 0.9;
        _hamburgerStrokeStart = 0.028;
        _hamburgerStrokeEnd = 0.111;
    }
    return self;
}

- (void)showInParentView:(UIView *)parentView withArea:(UIEdgeInsets)viewEdgeInsets withShowType:(YSCHamburgeButtonShowType)showType
{
    if (![self.superview isKindOfClass:[parentView class]]) {
        [parentView addSubview:self];
    }
    _showType = showType;
    [self addLineLayers];
    [self addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary * views = NSDictionaryOfVariableBindings(parentView,self);
    NSMutableArray *allConstraints = [NSMutableArray array];
    NSString *constraintsHFormat = [NSString stringWithFormat:@"H:|-%f-[self]-%f-|",viewEdgeInsets.left, viewEdgeInsets.right];
    NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:constraintsHFormat options:0 metrics:nil views:views];
    [allConstraints addObjectsFromArray:constraintsH];
    NSString *constraintsVFormat = [NSString stringWithFormat:@"V:|-%f-[self]-%f-|",viewEdgeInsets.top, viewEdgeInsets.bottom];
    NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:constraintsVFormat options:0 metrics:nil views:views];
    [allConstraints addObjectsFromArray:constraintsV];
    
    [parentView addConstraints:allConstraints];
}

- (void)addLineLayers
{
    [self.layer addSublayer:self.topLineLayer];
    [self.layer addSublayer:self.bottomLineLayer];
    [self.layer addSublayer:self.middleLineLayer];
    
    self.topLineLayer.anchorPoint = CGPointMake(28.0 / 30.0, 0.5);
    self.topLineLayer.position = CGPointMake(40, 18);
    self.middleLineLayer.position = CGPointMake(27, 27);
    self.middleLineLayer.strokeStart = _menuStrokeStart;
    self.middleLineLayer.strokeEnd = _menuStrokeEnd;
    self.bottomLineLayer.anchorPoint = CGPointMake(28.0 / 30.0, 0.5);
    self.bottomLineLayer.position = CGPointMake(40, 36);
    
    if (YSCHamburgeButtonShowTypeCancel == _showType) {
        self.middleLineLayer.strokeStart = _menuStrokeStart;
        self.middleLineLayer.strokeEnd = _menuStrokeEnd;
        CATransform3D translation = CATransform3DMakeTranslation(-4, 0, 0);
        self.topLineLayer.transform = CATransform3DRotate(translation, -0.7853975, 0, 0, 1);
        self.bottomLineLayer.transform = CATransform3DRotate(translation, 0.7853975, 0, 0, 1);
    } else if (YSCHamburgeButtonShowTypeHamburge == _showType) {
        self.middleLineLayer.strokeStart = _hamburgerStrokeStart;
        self.middleLineLayer.strokeEnd = _hamburgerStrokeEnd;
        self.topLineLayer.transform = CATransform3DIdentity;
        self.bottomLineLayer.transform = CATransform3DIdentity;
    }
}

- (void)addAnimations
{
    CABasicAnimation *strokeStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    CABasicAnimation *strokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    if (YSCHamburgeButtonShowTypeCancel == _showType) {
        self.middleLineLayer.strokeStart = _menuStrokeStart;
        self.middleLineLayer.strokeEnd = _menuStrokeEnd;
        
        strokeStart.fromValue = [NSNumber numberWithFloat:_hamburgerStrokeStart];
        strokeStart.toValue = [NSNumber numberWithFloat:_menuStrokeStart];
        strokeStart.duration = 0.5;
        strokeStart.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :-0.4 :0.5 :1];
        
        strokeEnd.fromValue = [NSNumber numberWithFloat:_hamburgerStrokeEnd];
        strokeEnd.toValue = [NSNumber numberWithFloat:_menuStrokeEnd];
        strokeEnd.duration = 0.6;
        strokeEnd.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :-0.4 :0.5 :1];
    } else if (YSCHamburgeButtonShowTypeHamburge == _showType) {
        self.middleLineLayer.strokeStart = _hamburgerStrokeStart;
        self.middleLineLayer.strokeEnd = _hamburgerStrokeEnd;
        
        strokeStart.fromValue = [NSNumber numberWithFloat:_menuStrokeStart];
        strokeStart.toValue = [NSNumber numberWithFloat:_hamburgerStrokeStart];
        strokeStart.duration = 0.5;
        strokeStart.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :0 :0.5 :1];
        strokeStart.beginTime = CACurrentMediaTime() + 0.1;
        strokeStart.fillMode = kCAFillModeBackwards;
        
        strokeEnd.fromValue = [NSNumber numberWithFloat:_menuStrokeEnd];
        strokeEnd.toValue = [NSNumber numberWithFloat:_hamburgerStrokeEnd];
        strokeEnd.duration = 0.6;
        strokeEnd.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :0.3 :0.5 :0.9];
    }
    
    [self.middleLineLayer addAnimation:strokeStart forKey:nil];
    [self.middleLineLayer addAnimation:strokeEnd forKey:nil];
    
    CABasicAnimation *topTransform = [CABasicAnimation animationWithKeyPath:@"transform"];
    topTransform.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5 :-0.8 :0.5 :1.85];
    topTransform.duration = 0.4;
    topTransform.fillMode = kCAFillModeBackwards;
    
    CABasicAnimation *bottomTransform = [topTransform copy];
    
    
    if (YSCHamburgeButtonShowTypeCancel == _showType) {
        CATransform3D translation = CATransform3DMakeTranslation(-4, 0, 0);
        topTransform.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        topTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(translation, -0.7853975, 0, 0, 1)];
        topTransform.beginTime = CACurrentMediaTime() + 0.25;
        
        bottomTransform.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        bottomTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(translation, 0.7853975, 0, 0, 1)];
        bottomTransform.beginTime = CACurrentMediaTime() + 0.25;
        
        self.topLineLayer.transform = CATransform3DRotate(translation, -0.7853975, 0, 0, 1);
        self.bottomLineLayer.transform = CATransform3DRotate(translation, 0.7853975, 0, 0, 1);
    } else if (YSCHamburgeButtonShowTypeHamburge == _showType) {
        CATransform3D translation = CATransform3DMakeTranslation(-4, 0, 0);
        topTransform.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(translation, -0.7853975, 0, 0, 1)];
        topTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        topTransform.beginTime = CACurrentMediaTime() + 0.05;
        
        bottomTransform.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(translation, 0.7853975, 0, 0, 1)];
        bottomTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        bottomTransform.beginTime = CACurrentMediaTime() + 0.05;
        
        self.topLineLayer.transform = CATransform3DIdentity;
        self.bottomLineLayer.transform = CATransform3DIdentity;
    }
    
    [self.topLineLayer addAnimation:topTransform forKey:nil];
    [self.bottomLineLayer addAnimation:bottomTransform forKey:nil];
}

- (void)buttonTouched:(id)sender
{
    _showType = (_showType + 1) % 2;
    [self addAnimations];
}

- (CGPathRef)shortStrokeLinePath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 2, 2);
    CGPathAddLineToPoint(path, nil, 28, 2);
    
    return path;
}

- (CGPathRef)middleAndOutlinePath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 10, 27);
    CGPathAddCurveToPoint(path, nil, 12.00, 27.00, 28.02, 27.00, 40, 27);
    CGPathAddCurveToPoint(path, nil, 55.92, 27.00, 50.47,  2.00, 27,  2);
    CGPathAddCurveToPoint(path, nil, 13.16,  2.00,  2.00, 13.16,  2, 27);
    CGPathAddCurveToPoint(path, nil,  2.00, 40.84, 13.16, 52.00, 27, 52);
    CGPathAddCurveToPoint(path, nil, 40.84, 52.00, 52.00, 40.84, 52, 27);
    CGPathAddCurveToPoint(path, nil, 52.00, 13.16, 42.39,  2.00, 27,  2);
    CGPathAddCurveToPoint(path, nil, 13.16,  2.00,  2.00, 13.16,  2, 27);
    
    return path;
}

#pragma mark - gettersAndsetters

- (CAShapeLayer *)topLineLayer
{
    if (!_topLineLayer) {
        _topLineLayer = [[CAShapeLayer alloc] init];
        _topLineLayer.fillColor = [UIColor clearColor].CGColor;
        _topLineLayer.strokeColor = [UIColor whiteColor].CGColor;
        _topLineLayer.lineWidth = 4;
        _topLineLayer.miterLimit = 4;
        _topLineLayer.lineCap = kCALineCapRound;
        _topLineLayer.path = [self shortStrokeLinePath];
        _topLineLayer.masksToBounds = YES;
        
        CGPathRef boundingPath = CGPathCreateCopyByStrokingPath(_topLineLayer.path, nil, 4, kCGLineCapRound, kCGLineJoinMiter, 4);
        _topLineLayer.bounds = CGPathGetPathBoundingBox(boundingPath);
    }
    
    return _topLineLayer;
}

- (CAShapeLayer *)bottomLineLayer
{
    if (!_bottomLineLayer) {
        _bottomLineLayer = [[CAShapeLayer alloc] init];
        _bottomLineLayer.fillColor = [UIColor clearColor].CGColor;
        _bottomLineLayer.strokeColor = [UIColor whiteColor].CGColor;
        _bottomLineLayer.lineWidth = 4;
        _bottomLineLayer.miterLimit = 4;
        _bottomLineLayer.lineCap = kCALineCapRound;
        _bottomLineLayer.path = [self shortStrokeLinePath];
        _bottomLineLayer.masksToBounds = YES;
        
        CGPathRef boundingPath = CGPathCreateCopyByStrokingPath(_bottomLineLayer.path, nil, 4, kCGLineCapRound, kCGLineJoinMiter, 4);
        _bottomLineLayer.bounds = CGPathGetPathBoundingBox(boundingPath);
    }
    
    return _bottomLineLayer;
}

- (CAShapeLayer *)middleLineLayer
{
    if (!_middleLineLayer) {
        _middleLineLayer = [[CAShapeLayer alloc] init];
        _middleLineLayer.fillColor = [UIColor clearColor].CGColor;
        _middleLineLayer.strokeColor = [UIColor whiteColor].CGColor;
        _middleLineLayer.lineWidth = 4;
        _middleLineLayer.miterLimit = 4;
        _middleLineLayer.lineCap = kCALineCapRound;
        _middleLineLayer.path = [self middleAndOutlinePath];
        _middleLineLayer.masksToBounds = YES;
        
        CGPathRef boundingPath = CGPathCreateCopyByStrokingPath(_middleLineLayer.path, nil, 4, kCGLineCapRound, kCGLineJoinMiter, 4);
        _middleLineLayer.bounds = CGPathGetPathBoundingBox(boundingPath);
    }
    
    return _middleLineLayer;
}

@end
