//
//  ViewController.m
//  画板
//
//  Created by Dylan on 16/8/11.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "ViewController.h"
#import "MLDrawView.h"
#import "MLImageHandle.h"
@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *yellowBtn;
@property (weak, nonatomic) IBOutlet UIButton *greenBtn;
@property (weak, nonatomic) IBOutlet UIButton *redBtn;
@property (weak, nonatomic) IBOutlet MLDrawView *drawView;

@end

@implementation ViewController

/*!
 *  清屏
 *
 *  @param sender
 */
- (IBAction)clear:(id)sender {
    [self.drawView clear];
}

/*!
 *  撤销
 *
 *  @param sender <#sender description#>
 */
- (IBAction)undo:(id)sender {
    [self.drawView undo];

}

/*!
 *  橡皮擦
 *
 *  @param sender <#sender description#>
 */
- (IBAction)eraser:(id)sender {
    [self.drawView eraser];

}

- (IBAction)photo:(id)sender {
    [self choosePhotoLibary];
}

- (IBAction)save:(id)sender {
    
    UIGraphicsBeginImageContextWithOptions(self.drawView.bounds.size, NO, 0);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [self.drawView.layer renderInContext:contextRef];
    UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"contextInfo%@",contextInfo);
}


/*!
 *  滑块控件
 *
 *  @param sender
 */
- (IBAction)slider:(UISlider *)sender {
    self.drawView.lindWidh = sender.value;
}
/*!
 *  绿色按钮
 *
 *  @param sender 
 */
- (IBAction)greenBtn:(UIButton *)sender {
    self.drawView.seletedColor = sender.backgroundColor;
}
/*!
 *  黄色按钮
 *
 *  @param sender
 */
- (IBAction)yellowBtn:(UIButton *)sender {
    self.drawView.seletedColor = sender.backgroundColor;

}
/*!
 *  红色按钮
 *
 *  @param sender
 */
- (IBAction)redBtn:(UIButton *)sender {
    self.drawView.seletedColor = sender.backgroundColor;

}
/*!
 *  选择相片
 */
- (void)choosePhotoLibary{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *pickerImage = info[UIImagePickerControllerOriginalImage];
    MLImageHandle *handle = [[MLImageHandle alloc]init];
    handle.frame = self.drawView.bounds;
    handle.image = pickerImage;
    handle.handleCompletion = ^(UIImage *image){
        if (image) {
            self.drawView.image = image;
        }
    };
    [self.drawView addSubview:handle];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
