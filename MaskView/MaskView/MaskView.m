//
//  MaskView.m
//  WMPageControllerExample
//
//  Created by Guangleijia on 2018/3/9.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MaskView.h"
#import <objc/runtime.h>

#define ROOTWINDOW [[[UIApplication sharedApplication] delegate] window]

NS_ASSUME_NONNULL_BEGIN
typedef void (^UIViewGestureComplete)(UIView *_Nonnull view);

@interface MaskView()


@end

@implementation MaskView

- (void)showInWindow {
    [self setupMakeMask];
    [ROOTWINDOW addSubview:self];
}

- (void)setupMakeMask {
//    if ([self conformsToProtocol:@protocol(MaskViewDataSource)]) {
//        id <MaskViewDataSource> dataSource = (id <MaskViewDataSource>) self;
//        _maskItems = [dataSource maskViewItems:self];
//        
//        NSLog(@"_makeItems = %@", _maskItems);
//    }
    
    [self makeMask];
}

- (void)setDataSource:(_Nullable id<MaskViewDataSource>)dataSource{
    _dataSource = dataSource;
    
    if ([_dataSource respondsToSelector:@selector(maskViewItems:)]) {
        _maskItems = [[_dataSource maskViewItems:self] copy];
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [_maskItems enumerateObjectsUsingBlock:^(MaskViewItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (obj.maskStyle) {
                // 如果是圆形 就绘制圆形虚线框
            case MaskViewStyleCircle:
                [[self addDashInBezierPath:[self addArcBezierPath:obj isDash:YES]] fill];
                break;
            case MaskViewStyleOval:
                [[self addDashInBezierPath:[self addArcBezierPath:obj isDash:YES]] fill];
                break;
            default:
                break;
        }
    }];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.75];
        
        /** 为 UIView 添加点击事件, 用来移除蒙版 */
        __weak __typeof(self)weakSelf = self;
        [self addTapGestureWithComplete:^(UIView * _Nonnull view) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf  actionButtonClick];
        }];
        
    }
    return self;
}

- (CGPoint)convertCenterView:(UIView *)view {
    CGRect rect = [view convertRect:view.bounds toView:self];
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

//- (void)setDataSource:(_Nullable id<MaskViewDataSource>)dataSource{
//    _dataSource = dataSource;
//    if([_dataSource respondsToSelector:@selector(maskViewItems:)]){
//        NSLog(@"%@", self.maskItems);
//        [_dataSource maskViewItems:self];
//    }
//}


#pragma mark - private method
// 为了让界面消失前, 传递界面消失信息给外界, 我们新建一个异步回调的 block
- (void)actionButtonClick {
    if (self.actionCompletionHandle) {
        self.actionCompletionHandle();
    }
     [self removeFromSuperview];
}

//- (void)setupMakeMask {
//
//
//}

#pragma mark - 绘制

- (void)makeMask {
    // 如果没有配置数据, 就可以直接返回 什么都不做
    if(_maskItems.count == 0){
        return;
    }
    
    // 绘制一个画板, 用于防止镂空路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    // 遍历外部传入数据源
    [_maskItems enumerateObjectsUsingBlock:^(MaskViewItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (obj.maskStyle) {
            case MaskViewStyleCircle: // 圆形
                [path appendPath:[self addArcBezierPath:obj isDash:NO]];
                break;
            case MaskViewStyleOval: // 椭圆
                [path appendPath:[self addOvlcBezierPath:obj isDash:NO]];
                break;
            default:
                break;
        }
        
        // 添加箭头图标
        [self addArrowImageInView:obj];
        // 添加文本描述
        [self addArrowTipLabel:obj];
    }];
    
    // 新建一个 shapeLayer, 用于绘制路径 做镂空
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
}

/** 绘制 圆形 path
 item: 数据源
 isDash: 是否带有虚线框
 */
- (UIBezierPath *)addArcBezierPath:(MaskViewItem *)item isDash:(BOOL)isDash{
    // 设置半径 (带虚线框的半径大些)
    CGFloat radius = item.radius + (isDash ? 5 : 3);
    
    return [UIBezierPath bezierPathWithArcCenter:item.arcCenter radius:radius startAngle:0 endAngle:2*M_PI clockwise:NO];
}

/** 绘制 椭圆形 path
 item: 数据源
 isDash: 是否带有虚线框
 */
- (UIBezierPath *)addOvlcBezierPath:(MaskViewItem *)item isDash:(BOOL)isDash{
    // 设置偏移量 (带虚线框的半径大些)
    CGFloat offSet = isDash ? 5 : 3;
    
    CGRect rect = CGRectMake(item.arcCenter.x-item.ovalSize.width*0.5 - offSet,
                             item.arcCenter.y-item.ovalSize.height*0.5-offSet,
                             item.ovalSize.width+offSet*2,
                             item.ovalSize.height+offSet*2);
    return [UIBezierPath bezierPathWithOvalInRect:rect];
}

/**
 添加箭头图片
 */
- (void)addArrowImageInView:(MaskViewItem *)item {
    // 如果没有图片, 直接返回
    if (item.arrowImage == nil) return;
    // 如果没有设置大小, 直接返回
    if(CGSizeEqualToSize(item.arrowSize, CGSizeZero)) return;
 
    // 计算 箭头点的坐标
    CGPoint arrowPoint = CGPointMake(item.arcCenter.x + item.arrowOffset.x, item.arcCenter.y+item.arrowOffset.y);
    // 箭头 点坐标 对点坐标值
    CGFloat arrowCenterX, arrowCenterY;
    // 参考点是箭头图片的中心点
    switch (item.quardrant) {
        case MaskItemQuadrant1:{
            arrowCenterX = arrowPoint.x-item.arrowSize.width*0.5;
            arrowCenterY = arrowPoint.y+item.arrowSize.height*0.5;
        }
            break;
        case MaskItemQuadrant2:{
            arrowCenterX = arrowPoint.x+item.arrowSize.width*0.5;
            arrowCenterY = arrowPoint.y+item.arrowSize.height*0.5;
        }
            break;
        case MaskItemQuadrant3:{
            arrowCenterX = arrowPoint.x+item.arrowSize.width*0.5;
            arrowCenterY = arrowPoint.y-item.arrowSize.height*0.5;
        }
            break;
        case MaskItemQuadrant4:{
            arrowCenterX = arrowPoint.x-item.arrowSize.width*0.5;
            arrowCenterY = arrowPoint.y-item.arrowSize.height*0.5;
        }
            break;
        default:
            break;
    }
    
    item.arrowImageView.image = item.arrowImage;
    item.arrowImageView.frame = CGRectMake(0, 0, item.arrowSize.width, item.arrowSize.height);
    item.arrowImageView.center = CGPointMake(arrowCenterX, arrowCenterY);
    [self addSubview:item.arrowImageView];
}


/**
    添加提示文本
 */
- (void)addArrowTipLabel:(MaskViewItem *)item {
    // 没有文字描述
    if (item.tipText.length == 0) return;
    item.tipLabel.text = item.tipText;
    item.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:item.tipLabel];
    
    // 设置文本 位置
    CGFloat margin = 20.f;
    CGSize textSize = [item.tipText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.bounds)-margin*2, MAXFLOAT)
                                                 options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName: item.tipLabel.font}
                                                 context:nil].size;
    CGFloat tipLabelX = margin;
    CGFloat relativeSpace = item.textPosition == MaskItemArrowTipPositionTop ?  -1 : 1;
    CGFloat tipLabelY = CGRectGetMidY(item.arrowImageView.frame)+ textSize.height* relativeSpace ;
    
    item.tipLabel.frame = CGRectMake(tipLabelX, tipLabelY, textSize.width, textSize.height);
}


/**
    绘制虚线框
 */
- (UIBezierPath *)addDashInBezierPath:(UIBezierPath *)bezierPath {
    [[UIColor whiteColor] setStroke];
    bezierPath.lineWidth = 2.f;
    CGFloat dash[] = {3.f, 3.f};
    [bezierPath setLineDash:dash count:2 phase:0];
    [bezierPath stroke];
    return bezierPath;
}


// 添加点击事件的分类方法
- (void)addTapGestureWithComplete:(UIViewGestureComplete)complete {
    NSParameterAssert(complete);
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    objc_setAssociatedObject(self, @selector(tapGesture), tapGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(tapGestureComplete), complete, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addGestureRecognizer:tapGesture];
}


#pragma mark - Gesture method
- (void)tapClick {
    self.tapGestureComplete(self);
    
}

#pragma mark - property Get
- (UITapGestureRecognizer *)tapGesture {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIViewGestureComplete)tapGestureComplete {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)dealloc{
    NSLog(@"%s", __FUNCTION__);
}

@end
NS_ASSUME_NONNULL_END
