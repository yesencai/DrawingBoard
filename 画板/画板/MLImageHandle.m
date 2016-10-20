//
//  MLImageHandle.m
//  画板
//
//  Created by Dylan on 16/8/11.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "MLImageHandle.h"

@interface MLImageHandle ()<UIGestureRecognizerDelegate>

/** image */
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MLImageHandle
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return self.imageView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.frame = self.bounds;
        [self addGestureRecognizer];
        [self addSubview:_imageView];
    }
    return _imageView;
}


- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}

/*!
 *  添加手势
 */
- (void)addGestureRecognizer{
    
    //移动手势
    UIPanGestureRecognizer *pan= [[UIPanGestureRecognizer alloc]init];
    [pan addTarget:self action:@selector(pan:)];
    [self.imageView addGestureRecognizer:pan];
    
    //旋转手势
    UIRotationGestureRecognizer *ratation = [[UIRotationGestureRecognizer alloc]init];
    ratation.delegate = self;
    [ratation addTarget:self action:@selector(ratation:)];
    [self.imageView addGestureRecognizer:ratation];
    
    //缩放手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]init];
    [pinch addTarget:self action:@selector(pinch:)];
    pinch.delegate = self;
    [self.imageView addGestureRecognizer:pinch];
    
    //长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]init];
    [longPress addTarget:self action:@selector(longPress:)];
    [self.imageView addGestureRecognizer:longPress];
    
    
}

/*!
 *  是否同时支持多个手势
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

/*!
 *  移动手势
 *
 *  @param pan
 */
- (void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint currentPoint = [pan translationInView:self.imageView];
    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, currentPoint.x, currentPoint.y);
    [pan setTranslation:CGPointZero inView:self.imageView];
}
/*!
 *  旋转手势
 *
 *  @param pan
 */
- (void)ratation:(UIRotationGestureRecognizer *)ratation{
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, ratation.rotation);
    ratation.rotation = 0;
}

/*!
  *  缩放手势
  *
  *  @param pan
  */
- (void)pinch:(UIPinchGestureRecognizer *)pinch{
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, pinch.scale, pinch.scale);
    pinch.scale = 1;
}
/*!
  *  长按手势
  *
  *  @param pan
  */
- (void)longPress:(UILongPressGestureRecognizer *)longPress{

    if (longPress.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.alpha = 0.5;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.imageView.alpha = 1;
            } completion:^(BOOL finished) {
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
                CGContextRef contextRef = UIGraphicsGetCurrentContext();
                [self.layer renderInContext:contextRef];
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                if (_handleCompletion) {
                    _handleCompletion(image);
                }
                [self removeFromSuperview];
            }];
        }];
    }
    
}
@end
