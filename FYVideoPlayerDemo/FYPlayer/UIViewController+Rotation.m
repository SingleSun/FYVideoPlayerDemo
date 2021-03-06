//
//  UIViewController+Rotation.m
//  FYVideoPlayerDemo
//
//  Created by 樊杨 on 2017/8/27.
//  Copyright © 2017年 YHCRT.FY. All rights reserved.
//

#import "UIViewController+Rotation.h"

@implementation UIViewController (Rotation)
// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return NO;
}
// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscape;
}
// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
@end
