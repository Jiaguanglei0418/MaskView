//
//  MaskViewItem.m
//  WMPageControllerExample
//
//  Created by Guangleijia on 2018/3/9.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "MaskViewItem.h"

@implementation MaskViewItem
#pragma mark -- lazyLoad
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.font = [UIFont systemFontOfSize:14.f];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}


- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _arrowImageView;
}
@end
