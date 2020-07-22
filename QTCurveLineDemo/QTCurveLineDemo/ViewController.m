//
//  ViewController.m
//  QTCurveLineDemo
//
//  Created by thsboy on 2020/7/22.
//  Copyright © 2020 qdd. All rights reserved.
//

#import "ViewController.h"
#import "QTCurveLine.h"

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

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation ViewController

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
    [self.btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.btn.backgroundColor = [UIColor whiteColor];
    self.btn.layer.cornerRadius = 5.0f;
    self.btn.layer.masksToBounds = YES;
    [self.view addSubview:self.btn];
    [self.btn  addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.autoBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50 - 100, kNaviHeight +10.f, 100, 40)];
    [self.autoBtn setTitle:@"自动刷新" forState:UIControlStateNormal];
    [self.autoBtn setTitle:@"停止刷新" forState:UIControlStateSelected];
    [self.autoBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.autoBtn.backgroundColor = [UIColor whiteColor];
    self.autoBtn.layer.cornerRadius = 5.0f;
    self.autoBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.autoBtn];
    [self.autoBtn  addTarget:self action:@selector(autoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.curve = [[QTCurveLine alloc] initWithFrame:CGRectMake(75, kNaviHeight + 80, kScreenWidth - 70, 200)];
    /* 自定义样式相关属性
        self.curve.anchorColor = [UIColor greenColor];
        self.curve.diam = 6.0f;
        self.curve.strokeColor = [UIColor orangeColor];
        self.curve.anchorPointHiden = NO;
        self.curve.stepWidth = 40.0f;
        self.curve.lineWidth = 2.0f;
        self.curve.showAinimation = YES;
        self.curve.duration = 5.0f;
        self.curve.repeatCount = 1;
     */
    [self.view addSubview:self.curve];
}

-(void)refreshDataAndDraw{
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i < 10; i++) {
        int randomMax = 1000;
        float value = rand()%randomMax;
        [array addObject:[NSNumber numberWithFloat:value]];
    }
    self.curve.maxValue = 1000;
    self.curve.dataSource = array;
    [self.curve draw];
}

-(void)btnClick{
    NSLog(@"btnClick");
    [self refreshDataAndDraw];
}

/*
 * 自动刷新
 */
-(void)autoBtnClick{
    self.autoBtn.selected = !self.autoBtn.selected;
    if (self.autoBtn.selected) {
        [self.timer fire];
        [self.timer setFireDate:[NSDate date]];
    }else{
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

-(NSTimer *)timer{
    if (!_timer) {
        __weak typeof(self) weakSelf = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf refreshDataAndDraw];
        }];
    }
    return _timer;
}
@end
