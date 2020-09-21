//
//  QTChartLine.h
//  QTCurveLineDemo
//
//  Created by thsboy on 2020/9/2.
//  Copyright © 2020 qdd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QTChartLine : UIView

/* 不可缺省 ~ 数据相关 */
@property (nonatomic,strong) NSArray *dataSource;//绘制数组，对应y的值
@property (nonatomic,assign) float maxValue;//最大值，y轴最高点的值。

@property (nonatomic,strong) UIColor *anchorColor;//锚点颜色
@property (nonatomic,assign) float diam;//锚点直径
@property (nonatomic,strong) UIColor *strokeColor;//曲线颜色
@property (nonatomic,assign) float lineWidth;//曲线宽度
@property (nonatomic,assign) float stepWidth;//步长(相邻点x坐标之差)



-(void)draw;
-(void)refreshWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
