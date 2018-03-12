//
//  MaskView.h
//  WMPageControllerExample
//
//  Created by Guangleijia on 2018/3/9.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaskViewItem.h"

NS_ASSUME_NONNULL_BEGIN


@class MaskView;
/**
    maskView 数据源
 */
@protocol MaskViewDataSource <NSObject>
@required
- (NSArray <MaskViewItem *> *)maskViewItems:(MaskView *)maskView;
@end



@interface MaskView : UIView

/** 绘制椭圆的大小 */
@property(nonatomic, assign) CGSize ovalSize;

/** 描述文字 */
@property(nonatomic, strong, readonly) UILabel *tipLabel;

/** 箭头图片 */
@property(nonatomic, strong, readonly) UIImageView *arrowImageView;



/** 操作按钮点击回调 */
@property(nonatomic, copy) void (^actionCompletionHandle)(void);


@property(nonatomic, strong) NSArray <MaskViewItem *> *maskItems;

@property(nonatomic, weak) id<MaskViewDataSource> dataSource;


// 定义类似于 alert 弹出方式
- (void)showInWindow;
// 查找 视图相对于父类视图的中心位置
- (CGPoint)convertCenterView:(UIView *)view;
@end
NS_ASSUME_NONNULL_END
