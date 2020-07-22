//
//  QTCurveLine.h
//  RACDemo
//
//  Created by thsboy on 2020/7/21.
//  Copyright © 2020 qdd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QTCurveLine : UIView
/* 可缺省 ~  样式相关 */
@property (nonatomic,assign) BOOL anchorPointHiden;//是否隐藏锚点
@property (nonatomic,strong) UIColor *anchorColor;//锚点颜色
@property (nonatomic,assign) float diam;//锚点直径
@property (nonatomic,strong) UIColor *strokeColor;//曲线颜色
@property (nonatomic,assign) float lineWidth;//曲线宽度
@property (nonatomic,assign) float stepWidth;//步长(相邻点x坐标之差)
@property (nonatomic,assign) BOOL showAinimation;//是否显示动画
@property (nonatomic,assign) long repeatCount;//动画重复次数
@property (nonatomic,assign) float duration;//动画时间

/* 不可缺省 ~ 数据相关 */
@property (nonatomic,strong) NSArray *dataSource;//绘制数组，对应y的值
@property (nonatomic,assign) float maxValue;//最大值，y轴最高点的值。

//绘制曲线图
-(void)draw;

@end

NS_ASSUME_NONNULL_END
