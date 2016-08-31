//
//  ViewController.m
//  MHDrawBoard
//
//  Created by Macro on 11/4/15.
//  Copyright © 2015 Macro. All rights reserved.
//

#import "ViewController.h"
#import "MHBoardView.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

enum {
    CLEARBTN = 1000,
    BACKBTN,
    SAVEBTN
};

@interface ViewController ()
{
    MHBoardView *_boardView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];
    
    _boardView = [[MHBoardView alloc] initWithFrame:CGRectMake(10, 20, kWidth - 20, kHeight - 80)];
    [_boardView setLineWidth:5];
    [_boardView setLineColor:[UIColor redColor]];
//    _boardView.backgroundColor = [UIColor whiteColor];
    [_boardView setBackgroundImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:_boardView];
    
    [self.view addSubview:[self createBtnWithTitle:@"clear" frame:CGRectMake(10, kHeight - 45, (kWidth - 45) / 3, 30) tag:CLEARBTN]];
    [self.view addSubview:[self createBtnWithTitle:@"back" frame:CGRectMake(20 + (kWidth - 40) / 3, kHeight - 45, (kWidth - 40) / 3, 30) tag:BACKBTN]];
    [self.view addSubview:[self createBtnWithTitle:@"save" frame:CGRectMake(30 + (kWidth - 40) / 3 * 2, kHeight - 45, (kWidth - 40) / 3, 30) tag:SAVEBTN]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 创建按钮
- (UIButton *)createBtnWithTitle:(NSString *)title frame:(CGRect)frame tag:(NSInteger)tag{
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:title forState:(UIControlStateNormal)];
    [btn setTintColor:[UIColor whiteColor]];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn setTitleColor:[UIColor blueColor] forState:(UIControlStateHighlighted)];
    btn.frame = frame;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    btn.tag = tag;
    return btn;
}

// 按钮相应事件
- (void)btnAction:(UIButton *)btn {
    switch (btn.tag) {
        case CLEARBTN: {
            [_boardView clear];
            break;
        }
        case BACKBTN: {
            [_boardView back];
            break;
        }
        case SAVEBTN: {
            UIImage *image = [_boardView getImage];
            // 第三个参数必须要这种格式
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            [_boardView clear];
            break;
        }
        default:
            break;
    }
}

// 保存图片对应的selector
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil;
    if(error != NULL){
        msg = @"保存图片失败";
    }else{
        msg = @"保存图片成功";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

@end
