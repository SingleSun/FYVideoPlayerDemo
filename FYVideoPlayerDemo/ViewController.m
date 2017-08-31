//
//  ViewController.m
//  FYVideoPlayerDemo
//
//  Created by 樊杨 on 2017/8/25.
//  Copyright © 2017年 YHCRT.FY. All rights reserved.
//

#import "ViewController.h"
#import "FYPlayerView.h"
#import "FYActivityView.h"
#define FYScreenWidth [UIScreen mainScreen].bounds.size.width

#define FYScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"视频播放";
    
    FYPlayerView * play = [[FYPlayerView alloc]initWithFrame:CGRectMake(0, 100,FYScreenWidth , 200)];
    play.url = [NSURL URLWithString:@"http://wvideo.spriteapp.cn/video/2016/1203/58425ad2a0c1d_wpd.mp4"];
    play.videoName = @"百思不得姐第52期";
    [self.view addSubview:play];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
