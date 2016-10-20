//
//  MLImageHandle.h
//  画板
//
//  Created by Dylan on 16/8/11.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLImageHandle : UIView

/** image */
@property (nonatomic, strong) UIImage *image;
/** 处理完成 */
@property (nonatomic, strong) void(^handleCompletion)(UIImage *image);
@end
