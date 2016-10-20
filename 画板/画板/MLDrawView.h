//
//  MLDrawView.h
//  画板
//
//  Created by Dylan on 16/8/11.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLDrawView : UIView
/** lindWidth */
@property (nonatomic, assign) CGFloat lindWidh;
/** 颜色 */
@property (nonatomic, strong) UIColor *seletedColor;
/** 相片 */
@property (nonatomic, strong) UIImage *image;

/*!
 *  清屏
 */
- (void)clear;

/*!
 *  撤销
 */
- (void)undo;

/*!
 *  橡皮擦
 */
- (void)eraser;
@end
