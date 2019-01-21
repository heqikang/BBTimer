//
//  ViewController.m
//  timer
//
//  Created by 程肖斌 on 2019/1/21.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import "ViewController.h"
#import "BBTimerManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *increaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *decreaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *displaylinkLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)time:(UIButton *)sender {
    static BBTimerManager  *manager = nil;
    static dispatch_once_t once_t   = 0;
    static NSInteger       value    = 0;
    
    manager.isPause ? [manager goOn] : [manager pause];
    NSString *show = manager.isPause ? @"点击继续" : @"点击暂停";
    [sender setTitle:show forState:UIControlStateNormal];
    
    dispatch_once(&once_t, ^{
        manager = [BBTimerManager manager];
        [manager count:1.0
              callback:^{
            self.timeLabel.text = @(value ++).description;
        }];
    });
}

- (IBAction)increase:(UIButton *)sender {
    static BBTimerManager *manager = nil;
    static dispatch_once_t once_t  = 0;
    
    manager.isPause ? [manager goOn] : [manager pause];
    NSString *show = manager.isPause ? @"点击继续" : @"点击暂停";
    [sender setTitle:show forState:UIControlStateNormal];
    
    dispatch_once(&once_t, ^{
        manager = [BBTimerManager manager];
        [manager increase:0
                 duration:1
                     step:1
                 callback:^(double index) {
            self.increaseLabel.text = [NSString stringWithFormat:@"%.0lf",index];
        }];
    });
}

- (IBAction)decrease:(UIButton *)sender {
    static BBTimerManager *manager = nil;
    static dispatch_once_t once_t  = 0;
    
    manager.isPause ? [manager goOn] : [manager pause];
    NSString *show = manager.isPause ? @"点击继续" : @"点击暂停";
    [sender setTitle:show forState:UIControlStateNormal];
    
    dispatch_once(&once_t, ^{
        manager = [BBTimerManager manager];
        [manager decrease:60
                 duration:1
                     step:1
                 callback:^(double index) {
            self.decreaseLabel.text = [NSString stringWithFormat:@"%.0lf",index];
        }];
    });
}

- (IBAction)displaylink:(UIButton *)sender {
    static BBTimerManager *manager = nil;
    static dispatch_once_t once_t  = 0;
    static NSInteger       value   = 0;
    
    manager.isPause ? [manager goOn] : [manager pause];
    NSString *show = manager.isPause ? @"点击继续" : @"点击暂停";
    [sender setTitle:show forState:UIControlStateNormal];
    
    dispatch_once(&once_t, ^{
        manager = [BBTimerManager manager];
        [manager displaylinkWithFrame:5
                             callback:^{
            self.displaylinkLabel.text = @(value ++).description;
        }];
    });
}

- (void)dealloc{
    //注意，一定要销毁计时器，不然会内存泄漏。。。demo就不写了
}


@end
