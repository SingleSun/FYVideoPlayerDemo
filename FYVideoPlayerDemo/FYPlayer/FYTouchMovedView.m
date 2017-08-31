//
//  FYTouchMovedView.m
//  FYVideoPlayerDemo
//
//  Created by 樊杨 on 2017/8/30.
//  Copyright © 2017年 YHCRT.FY. All rights reserved.
//

#import "FYTouchMovedView.h"

@interface FYTouchMovedView()

@end

@implementation FYTouchMovedView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setDefault];
        //初始化视图
        [self initView];
    }
    return self;
}

#pragma mark 设置默认值
-(void)setDefault{
    self.titleColor = [UIColor whiteColor];
    self.touchProgressColor = [UIColor whiteColor];
}

-(void)initView{
    //进度时间显示
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2.0-15, self.frame.size.width, 30)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = self.titleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    //进度条
    UIProgressView * touchProgress = [[UIProgressView alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(titleLabel.frame)+5, self.frame.size.width-20, 2)];
    touchProgress.progressTintColor = self.touchProgressColor;
    self.touchProgress = touchProgress;
    [self addSubview:touchProgress];
}

-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

-(void)setTouchTitle:(NSString *)touchTitle{
    _touchTitle = touchTitle;
    self.titleLabel.text = touchTitle;
}

-(void)setTouchProgressColor:(UIColor *)touchProgressColor{
    _touchProgressColor = touchProgressColor;
    _touchProgress.progressTintColor = self.touchProgressColor;
}

-(void)setTouchProgressValue:(CGFloat)touchProgressValue{
    _touchProgressValue = touchProgressValue;
    [_touchProgress setProgress:touchProgressValue];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
