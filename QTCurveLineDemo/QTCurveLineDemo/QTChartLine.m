//
//  QTChartLine.m
//  QTCurveLineDemo
//
//  Created by thsboy on 2020/9/2.
//  Copyright © 2020 qdd. All rights reserved.
//

#import "QTChartLine.h"

@interface QTChartLine()

@property (nonatomic,assign) BOOL isDrawFlag;//绘图标记
@property (nonatomic,strong) NSArray *pointArray;//锚点数组

@property (nonatomic,strong) NSMutableArray *pathArray;//

@property (nonatomic,strong) CAShapeLayer *drawLayer;

@end

@implementation QTChartLine

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (self.isDrawFlag) {
        self.pointArray = [self prepareData:self.dataSource];
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
    [self removeSubLayer];
    [self setNeedsDisplay];
}

-(void)refreshWithArray:(NSArray *)array{
    self.dataSource = array;
//    [self draw];
    
    NSArray *pointArr = [self prepareData:array];
    UIBezierPath *path = [self pathFromArray:pointArr];
    self.drawLayer.path = path.CGPath;
//    for (NSValue *value in arr) {
//        CGPoint point = [value CGPointValue];
//        if ([self.path containsPoint:point]) {
//            printf("+");
//        }else{
//            printf("-");
//        }
//    }
//    [self.path removeAllPoints];
    
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
-(NSArray *)prepareData:(NSArray *)array{
    long count = array.count;
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSNumber *value = array[i];
        float x = i * self.stepWidth;
        float y = (self.maxValue - [value floatValue])* self.bounds.size.height/self.maxValue;
        [mArray addObject:[NSValue valueWithCGPoint:CGPointMake(x,y)]];
    }
    return mArray;
}
/*
 * 绘制CurveLine
 */
-(void)drawCurveLine{
    //曲线图layer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    UIBezierPath *path = [self pathFromArray:self.pointArray];
    layer.path = path.CGPath;
    layer.fillColor = nil;
    layer.strokeColor = self.strokeColor.CGColor;
    layer.lineWidth = self.lineWidth;
    self.drawLayer = layer;
    [self.layer addSublayer:layer];
    //锚点layer
//    [self drawPointAtPointArray:self.pointArray];
}

-(UIBezierPath *)pathFromArray:(NSArray *)array{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint pc1;//控制点1
    CGPoint pc2;//控制点2
    CGPoint cPoint = CGPointMake(0, 0);//根据P(i-1)~P(i)控制点Pc2 得到P(i)~P(i+1)控制点Pc1
    float rate = 0;//算控制点使用的斜率
    NSLog(@"for循环开始");
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
            //曲线路径
            [path addCurveToPoint:p2 controlPoint1:pc1 controlPoint2:pc2];
            //提前计算P(i) 、P(i+1)的第一个控制点，此控制点跟 P(i-1) 、P(i) 的第二个控制点 和P(i) 共线（斜率相同）
            float x = p2.x - pc2.x;
            float y = p2.y - pc2.y;
            cPoint = CGPointMake((x + p2.x), (y + p2.y));
        }
    }
    NSLog(@"for循环结束");
    return path;
}

-(void)drawPointAtPointArray:(NSArray *)array{
    for (NSValue *value in array) {
        CGPoint point = [value CGPointValue];
        CAShapeLayer *pointLayer = [[CAShapeLayer alloc] init];
        pointLayer.frame = CGRectMake(point.x - self.diam/2, point.y - self.diam/2, self.diam, self.diam);
        pointLayer.backgroundColor = [UIColor orangeColor].CGColor;
        pointLayer.cornerRadius = self.diam/2;
        [self.layer addSublayer:pointLayer];
    }
}

#pragma mark -给定缺省值
-(float)stepWidth{
    _stepWidth = self.bounds.size.width/self.dataSource.count;
    return _stepWidth;
}

-(float)lineWidth{
    if (_lineWidth <= 0) {
        _lineWidth = 2.0f;
    }
    return _lineWidth;
}

-(float)diam{
    if (_diam <= 0) {
        _diam = self.lineWidth * 2;
    }
    return _diam;
}

-(UIColor *)strokeColor{
    if (!_strokeColor) {
        _strokeColor = [UIColor orangeColor];
    }
    return _strokeColor;
}

-(UIColor *)anchorColor{
    if (!_anchorColor) {
        _anchorColor = [UIColor greenColor];
    }
    return _anchorColor;
}

-(NSMutableArray *)pathArray{
    if(!_pathArray){
        _pathArray = [[NSMutableArray alloc] init];
        
    }
    return _pathArray;
}
@end
