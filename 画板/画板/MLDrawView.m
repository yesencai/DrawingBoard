//
//  MLDrawView.m
//  画板
//
//  Created by Dylan on 16/8/11.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "MLDrawView.h"
#import "MLDrawBezierPath.h"
@interface MLDrawView()

/** 贝斯尔曲线 */
@property (nonatomic, strong) MLDrawBezierPath *bezierPath;
/** 保存曲线路径 */
@property (nonatomic, strong) NSMutableArray *paths;
/** 保存图片 */
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation MLDrawView

- (NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (NSMutableArray *)paths
{
    if (!_paths) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

/*!
 *  清屏
 */
- (void)clear{
    [self.paths removeAllObjects];
    [self.images removeAllObjects];
    [self setNeedsDisplay];
}

/*!
 *  撤销
 */
- (void)undo{
    [self.paths removeLastObject];
    [self setNeedsDisplay];
}

/*!
 *  橡皮擦
 */
- (void)eraser{
    self.seletedColor = self.backgroundColor;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp{
    self.seletedColor = [UIColor blueColor];
    self.lindWidh = 5;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]init];
    [pan addTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint currentPoint = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.bezierPath = [[MLDrawBezierPath alloc]init];
        self.bezierPath.lineWidth = self.lindWidh;
        self.bezierPath.lineJoinStyle = kCGLineJoinRound;
        self.bezierPath.pathColor = self.seletedColor;
        [self.bezierPath moveToPoint:currentPoint];
        [self.paths addObject:self.bezierPath];
    }
    [self.bezierPath addLineToPoint:currentPoint];
    [self setNeedsDisplay];
}
- (void)setImage:(UIImage *)image{
    _image = image;
    [self.images addObject:image];
    [self setNeedsDisplay];
}
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    if (self.images.count>0) {
        for (UIImage *image in self.images) {
            [image drawAtPoint:CGPointZero];
        }
    }
    for (MLDrawBezierPath *path in self.paths) {
        [path.pathColor set];
        // Drawing code
        [path stroke];
    }

}


@end
