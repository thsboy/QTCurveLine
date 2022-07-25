//
//  ViewController.m
//  QTCurveLineDemo
//
//  Created by thsboy on 2020/7/22.
//  Copyright © 2020 qdd. All rights reserved.
//

#import "ViewController.h"
#import "QTCurveLine.h"
#import "QTChartLine.h"

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenheight   [UIScreen mainScreen].bounds.size.height

#define kSafeTop        ([UIApplication sharedApplication].windows.count>0 ? [UIApplication sharedApplication].windows[0].safeAreaInsets.top : 0)
#define kSafeBottom     ([UIApplication sharedApplication].windows.count>0 ? [UIApplication sharedApplication].windows[0].safeAreaInsets.bottom:0)
#define kNaviHeight    (kSafeTop + 44)
#define kNaviOnlyHeight 44
#define kTabHeight     (kSafeBottom + 50)

@interface ViewController ()

@property (nonatomic,strong) UIButton *btn;

@property (nonatomic,strong) UIButton *autoBtn;

@property (nonatomic,strong) QTCurveLine *curve;
@property (nonatomic,strong) QTChartLine *chart;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) UITextField *arrCountField;
@property (nonatomic,strong) UITextField *maxField;


//
@property (nonatomic,strong) NSArray *originArray;
@property (nonatomic,strong) NSArray *refreshArray;


@property (nonatomic,assign) int arrCount;
@property (nonatomic,assign) int maxNum;

@end

@implementation ViewController

-(int)arrCount{
    _arrCount = self.arrCountField.text.intValue;
    if (_arrCount <= 0) {
        _arrCount = 20;
    }
    return  _arrCount;
}
-(int)maxNum{
    _maxNum = self.maxField.text.intValue;
    if (_maxNum <= 0){
        _maxNum = 100;
    }
    return  _maxNum;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kSafeTop, kScreenWidth, kNaviOnlyHeight)];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.text = @"连续曲线图";
    topLabel.textColor = [UIColor blackColor];
    topLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:topLabel];
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(50, kNaviHeight +10.f, 80, 40)];
    [self.btn setTitle:@"绘图" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btn.backgroundColor = [UIColor whiteColor];
    self.btn.layer.cornerRadius = 5.0f;
    self.btn.layer.masksToBounds = YES;
    self.btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.btn];
    [self.btn  addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.autoBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50 - 100, kNaviHeight +10.f, 100, 40)];
    [self.autoBtn setTitle:@"自动刷新" forState:UIControlStateNormal];
    [self.autoBtn setTitle:@"停止刷新" forState:UIControlStateSelected];
    [self.autoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.autoBtn.backgroundColor = [UIColor whiteColor];
    self.autoBtn.layer.cornerRadius = 5.0f;
    self.autoBtn.layer.masksToBounds = YES;
    self.autoBtn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.autoBtn];
    [self.autoBtn  addTarget:self action:@selector(autoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.arrCountField = [[UITextField alloc] initWithFrame:CGRectMake(15, kNaviHeight + 65, kScreenWidth/2 - 30, 40)];
    self.arrCountField.layer.borderColor = [UIColor redColor].CGColor;
    self.arrCountField.layer.borderWidth = 0.6;
    self.arrCountField.layer.masksToBounds = YES;
    self.arrCountField.layer.cornerRadius = 5;
    self.arrCountField.font = [UIFont systemFontOfSize:16.0f];
    self.arrCountField.placeholder = @"输入数组元素个数";
    [self.view addSubview:self.arrCountField];
    
    self.maxField = [[UITextField alloc] initWithFrame:CGRectMake(kScreenWidth/2 + 15, kNaviHeight + 65, kScreenWidth/2 - 30, 40)];
    self.maxField.layer.borderColor = [UIColor redColor].CGColor;
    self.maxField.layer.borderWidth = 0.6;
    self.maxField.layer.masksToBounds = YES;
    self.maxField.layer.cornerRadius = 5;
    self.maxField.font = [UIFont systemFontOfSize:16.0f];
    self.maxField.placeholder = @"输入最大值（振幅）";
    [self.view addSubview:self.maxField];
    
    /*
    self.curve = [[QTCurveLine alloc] initWithFrame:CGRectMake(15, kNaviHeight + 90, kScreenWidth - 30, 200)];
    // 自定义样式相关属性
        self.curve.anchorColor = [UIColor greenColor];
        self.curve.diam = 6.0f;
        self.curve.strokeColor = [UIColor orangeColor];
        self.curve.anchorPointHiden = NO;
        self.curve.stepWidth = 40.0f;
        self.curve.lineWidth = 2.0f;
        self.curve.showAinimation = YES;
        self.curve.duration = 5.0f;
        self.curve.repeatCount = 1;
    [self.view addSubview:self.curve];
    */
    self.chart = [[QTChartLine alloc] initWithFrame:CGRectMake(15, kNaviHeight + 80 + 250, kScreenWidth - 30, 200)];
    [self.view addSubview:self.chart];
}

-(void)refreshDataAndDraw{
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i < self.arrCount; i++) {
        int randomMax = self.maxNum;
        float value = rand()%randomMax;
        [array addObject:[NSNumber numberWithFloat:value]];
    }
    self.refreshArray = array;
    //
    [self.chart refreshWithArray:array];
}

-(void)originDraw{
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i < self.arrCount; i++) {
        int randomMax = self.maxNum;
        float value = rand()%randomMax;
        [array addObject:[NSNumber numberWithFloat:value]];
    }
    self.originArray = array;
    //
//    self.curve.maxValue = self.maxNum;
//    self.curve.dataSource = array;
//    self.curve.showAinimation = YES;
//    [self.curve draw];
    //
    self.chart.maxValue = self.maxNum;
    self.chart.dataSource = array;
    [self.chart draw];
}

-(void)btnClick{
    [self.view endEditing:YES];
    [self originDraw];
}



/*
 * 自动刷新
 */
-(void)autoBtnClick{
    [self.view endEditing:YES];
    self.autoBtn.selected = !self.autoBtn.selected;
    if (self.autoBtn.selected) {
        [self.timer fire];
        [self.timer setFireDate:[NSDate date]];
    }else{
        [self.timer setFireDate:[NSDate distantFuture]];
    }
//    [self refreshDataAndDraw];
}

-(NSTimer *)timer{
    if (!_timer) {
        __weak typeof(self) weakSelf = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf refreshDataAndDraw];
        }];
    }
    return _timer;
}
@end
