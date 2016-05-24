//
//  ViewController.m
//  GCD计时器
//
//  Created by 孙云 on 16/5/24.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction)clickBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _btn.layer.cornerRadius = 10;
    _btn.layer.masksToBounds = YES;
    [self.btn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBtn:(UIButton *)sender {
    if (!sender.selected) {
        [self countDown];
        sender.selected = YES;
    }else{
    
    
        NSLog(@"正在倒计时中");
    }
    
}
/**
 *  倒计时
 */
- (void)countDown{

    __block typeof(self)weakSelf =self;
    __block int timeOut = 60;//倒计时时间
    //设置一个全局线程
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 *NSEC_PER_SEC, 0);
    //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakSelf.btn.selected = NO;
                //设置最终界面
                [weakSelf.btn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
            });
            
        }else{
        
            int sec = timeOut % (timeOut + 1);
            NSString *showStr = [NSString stringWithFormat:@"%d秒后重新获取验证码",sec];
            dispatch_async(dispatch_get_main_queue(), ^{
               
                
                [weakSelf.btn setTitle:showStr forState:UIControlStateNormal];
            });
            timeOut --;
        }
    });
    dispatch_resume(timer);
}
@end
