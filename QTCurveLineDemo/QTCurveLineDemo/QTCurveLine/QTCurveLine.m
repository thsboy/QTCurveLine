//
//  QTCurveLine.m
//  RACDemo
//
//  Created by thsboy on 2020/7/21.
//  Copyright © 2020 qdd. All rights reserved.
//

#import "QTCurveLine.h"

@interface QTCurveLine()

@property (nonatomic,assign) BOOL isDrawFlag;//绘图标记
@property (nonatomic,strong) NSArray *pointArray;//锚点数组

@property (nonatomic,assign) BOOL showControlPoint;//是否显示控制点
@property (nonatomic,strong) UIColor *controlColor;//控制点颜色
@end

@implementation QTCurveLine

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (self.isDrawFlag) {
        [self prepareData];
        [self drawCurveLine];
    }
}
/*
 * 开始绘制
 */
-(void)draw{
    if (self.dataSource.count <= 0) {
        NSLog(@"You have a wrong dataSource,Please check the dataSource!");
        return;
    }
    if (self.maxValue <= 0) {
        NSLog(@"You have a wrong maxValue,Please check the maxValue!");
        return;
    }
    self.isDrawFlag = YES;
//    self.showControlPoint = YES;//显示控制点
    [self removeSubLayer];
    [self setNeedsDisplay];
}

-(void)removeSubLayer{
    NSArray *array = [self.layer.sublayers copy];
    for (CALayer *layer in array) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
}
/*
 * 准备数据
 */
-(void)prepareData{
    long count = self.dataSource.count;
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSNumber *value = self.dataSource[i];
        float x = i * self.stepWidth;
        float y = (self.maxValue - [value floatValue])* self.bounds.size.height/self.maxValue;
        [array addObject:[NSValue valueWithCGPoint:CGPointMake(x,y)]];
    }
    self.pointArray = array;
}
/*
 * 绘制CurveLine
 */
-(void)drawCurveLine{
    //锚点数组
    NSArray *array = self.pointArray;
    //曲线图layer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint pc1;//控制点1
    CGPoint pc2;//控制点2
    CGPoint cPoint = CGPointMake(0, 0);//根据P(i-1)~P(i)控制点Pc2 得到P(i)~P(i+1)控制点Pc1
    float rate = 0;//算控制点使用的斜率
    for (int i = 0; i< array.count; i++) {
        CGPoint p2 = [array[i] CGPointValue];//第二个锚点（当前锚点）
        if (i == 0) {
            //路径起点
            [path moveToPoint:p2];
            cPoint = p2;//起点这里的 控制点设为起点本身。
        }else{
            CGPoint p1 = [array[i - 1] CGPointValue];//第一个锚点
            if (i< array.count - 1) {
                //根据当前锚点的 前一个 锚点 和 后一个锚点 算出斜率rate。
                CGPoint p3 = [array[i + 1] CGPointValue];
                rate = (p3.y - p1.y)/(p3.x- p1.x);
            }
            int a = 3;//控制点取 stepWidth/a
            //第一个控制点 根据上一次 的Pc2共线的点得出
            pc1 =  cPoint;
            if (i == array.count - 1) {
                //终点这里的 控制点设为终点本身。
                pc2 = p2;
            }else{
                //第二个控制点、取斜率等于 P(i+1)/P(i-1)
                pc2 = CGPointMake(p2.x - self.stepWidth/a, p2.y - rate*self.stepWidth/a);
            }
            //绘制锚点
            if (!self.anchorPointHiden) {
                [self addPoint:layer array:@[[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2]] diam:self.diam color:self.anchorColor];
            }
            //绘制控制点
            if (self.showControlPoint) {
                [self addPoint:layer array:@[[NSValue valueWithCGPoint:pc1],[NSValue valueWithCGPoint:pc2]] diam:self.diam color:self.controlColor];
            }
            //曲线路径
            [path addCurveToPoint:p2 controlPoint1:pc1 controlPoint2:pc2];
            //提前计算P(i) 、P(i+1)的第一个控制点，此控制点跟 P(i-1) 、P(i) 的第二个控制点 和P(i) 共线（斜率相同）
            float x = p2.x - pc2.x;
            float y = p2.y - pc2.y;
            cPoint = CGPointMake((x + p2.x), (y + p2.y));
        }
    }
    layer.path = path.CGPath;
    layer.fillColor = nil;
    layer.strokeColor = self.strokeColor.CGColor;
    layer.lineWidth = self.lineWidth;
    //动画
    if (self.showAinimation) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = self.duration;
        animation.fromValue = @(0);
        animation.toValue = @(1);
        animation.repeatCount = self.repeatCount;
        [layer addAnimation:animation forKey:@"kQTCurveLineAnimation"];
    }
    [self.layer addSublayer:layer];
}

/*
 * 标记array中的点
 */
-(void)addPoint:(CAShapeLayer *)layer array:(NSArray *)array diam:(float)diam color:(UIColor *)color{
    for (NSValue *value in array) {
        CGPoint point = [value CGPointValue];
        CAShapeLayer *pointLayer = [[CAShapeLayer alloc] init];
        pointLayer.frame = CGRectMake(point.x - diam/2, point.y - diam/2, diam, diam);
        pointLayer.backgroundColor = color.CGColor;
        pointLayer.cornerRadius = diam/2;
        [layer addSublayer:pointLayer];
        //
        if (self.showAinimation) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            animation.duration = self.duration;
            animation.fromValue = @(0);
            animation.toValue = @(1);
            animation.repeatCount = self.repeatCount;
            [pointLayer addAnimation:animation forKey:@"kQTAnchorPointAnimation"];
        }
    }
}

#pragma mark -给定缺省值
-(float)stepWidth{
    if (_stepWidth <= 0) {
        _stepWidth = self.bounds.size.width/self.dataSource.count;
    }
    return _stepWidth;
}

-(float)lineWidth{
    if (_lineWidth <= 0) {
        _lineWidth = 2.0f;
    }
    return _lineWidth;
}

-(long)repeatCount{
    if (_repeatCount <= 0 && self.showAinimation) {
        _repeatCount = 1;
    }
    return _repeatCount;
}

-(float)duration{
    if (_duration <=0 && self.showAinimation) {
        _duration = 5.0f;
    }
    return _duration;
}

-(float)diam{
    if (_diam <= 0) {
        _diam = self.lineWidth * 2;
    }
    return _diam;
}

-(UIColor *)anchorColor{
    if (!_anchorColor) {
        _anchorColor = [UIColor greenColor];
    }
    return _anchorColor;
}

-(UIColor *)strokeColor{
    if (!_strokeColor) {
        _strokeColor = [UIColor orangeColor];
    }
    return _strokeColor;
}

-(UIColor *)controlColor{
    if (!_controlColor) {
        _controlColor = [UIColor blackColor];
    }
    return _controlColor;
}
@end
