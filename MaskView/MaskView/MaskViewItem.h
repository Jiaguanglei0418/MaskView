//
//  MaskViewItem.h
//  WMPageControllerExample
//
//  Created by Guangleijia on 2018/3/9.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
    箭头距离圆形中心 的象限位置
 */
typedef NS_ENUM(NSUInteger, MaskItemQuadrant) {
    MaskItemQuadrant1,
    MaskItemQuadrant2,
    MaskItemQuadrant3,
    MaskItemQuadrant4
};

/**
     箭头提示文本 相对于 箭头的方向 (上下位置)
 */
typedef NS_ENUM(NSUInteger, MaskItemArrowTipPosition) {
    MaskItemArrowTipPositionTop, // tip 在上方
    MaskItemArrowTipPositionBottom,
};


/**
 创建蒙板类型
 */
typedef NS_ENUM (NSUInteger, MaskViewStyle) {
    MaskViewStyleCircle,
    MaskViewStyleOval,
};


//@class MaskView;
//@class MaskViewItem;


@interface MaskViewItem : NSObject

//@property(nonatomic, weak) MaskViewDataSource dataSource;

@property(nonatomic, assign) MaskViewStyle maskStyle;


/** 圆形的 圆心 */
@property(nonatomic, assign) CGPoint arcCenter;

/** 圆形的 半径 */
@property(nonatomic, assign) CGFloat radius;

/** 箭头 尾部相对于头部 位置的象限 */
@property(nonatomic, assign) MaskItemQuadrant quardrant;

/** 箭头距离中心圆的偏移量 */
@property(nonatomic, assign) CGPoint arrowOffset;

/** 箭头图片大小 */
@property(nonatomic, assign) CGSize arrowSize;

/** 箭头的图片 */
@property(nonatomic, strong) UIImageView *arrowImageView;
@property(nonatomic, strong) UIImage *arrowImage;


/** 描述文字相对于箭头的上下位置 */
@property(nonatomic, assign) MaskItemArrowTipPosition textPosition;
/** 描述文字内容 */
@property(nonatomic, copy) NSString *tipText;
/** 描述文字 label */
@property(nonatomic, strong) UILabel *tipLabel;

#pragma mark - oval
/** 绘制椭圆大小 */
@property(nonatomic, assign) CGSize ovalSize;




@end
