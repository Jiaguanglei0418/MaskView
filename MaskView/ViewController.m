//
//  ViewController.m
//  MaskView
//
//  Created by Guangleijia on 2018/3/12.
//  Copyright © 2018年 YaoMi. All rights reserved.
//

#import "ViewController.h"
#import "MaskView.h"

@interface ViewController ()<MaskViewDataSource>
@property(nonatomic, strong) MaskView *maskView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    _maskView = [[MaskView alloc] initWithFrame:self.view.window.bounds];
    _maskView.dataSource = self;
    
    [_maskView showInWindow];
}

#pragma mark - datasource
- (NSArray<MaskViewItem *> *)maskViewItems:(MaskView *)maskView{
    MaskViewItem *item1 = [self setupItemWithY:300 quardrant:MaskItemQuadrant1];
//    MaskViewItem *item2 = [self setupItemWithY:200 quardrant:MaskItemQuadrant2];
//    MaskViewItem *item3 = [self setupItemWithY:400 quardrant:MaskItemQuadrant3];
//    MaskViewItem *item4 = [self setupItemWithY:550 quardrant:MaskItemQuadrant4];
    return @[item1];
}

- (MaskViewItem *)setupItemWithY:(CGFloat)y quardrant:(MaskItemQuadrant)quandrant {
    MaskViewItem *item = [[MaskViewItem alloc] init];
    item.arrowImage = [UIImage imageNamed:@"arrow.png"];
    item.arrowSize = CGSizeMake(100, 62);
    item.tipText = @"就不告诉你就不就不告诉你就不告诉你就不告诉你就不告诉你就不告诉你";
    item.arcCenter = CGPointMake(200, y);
    item.radius = 50.f;
    item.arrowOffset = CGPointMake(-40, 40);
    item.textPosition = MaskItemArrowTipPositionBottom;
    item.maskStyle = MaskViewStyleCircle;
    item.quardrant = quandrant;
    return item;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
