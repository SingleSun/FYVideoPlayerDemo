//
//  FYPlayerToolView.m
//  FYVideoPlayerDemo
//
//  Created by 樊杨 on 2017/8/25.
//  Copyright © 2017年 YHCRT.FY. All rights reserved.
//

#import "FYPlayerToolView.h"
#import "Masonry.h"
#import "FYSlider.h"
#import "FYActivityView.h"
#import "FYTouchMovedView.h"
#define Padding 10
#define MarginPadding 7.5
#define ToolViewHeight 40

@interface FYPlayerToolView()


@end

@implementation FYPlayerToolView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        //初始化视图
        [self setupInitView];
    }
    return self;
}

-(void)setupInitView{
    [self addSubview:self.topToolView];
    [self addSubview:self.bottomToolView];
    //活动视图
    [self addSubview:self.activityView];
    [self addSubview:self.movedView];
    //顶部工具条
    [self.topToolView addSubview:self.backButton];
    [self.topToolView addSubview:self.videoNameLabel];
    //底部工具条
    [self.bottomToolView addSubview:self.playButton];
    [self.bottomToolView addSubview:self.currentTimeLabel];
    [self.bottomToolView addSubview:self.progressView];
    [self.bottomToolView addSubview:self.sliderView];
    [self.bottomToolView addSubview:self.totalTimeLabel];
    [self.bottomToolView addSubview:self.fullScreenButton];
    //添加点击手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
}

#pragma mark 顶部工具
-(UIView *)topToolView{
    if (_topToolView == nil) {
        _topToolView = [[UIView alloc]init];
        _topToolView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        _topToolView.userInteractionEnabled = YES;
    }
    return _topToolView;
}
#pragma mark 底部工具
-(UIView *)bottomToolView{
    if (_bottomToolView == nil) {
        _bottomToolView = [[UIView alloc]init];
        _bottomToolView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        _bottomToolView.userInteractionEnabled = YES;
    }
    return _bottomToolView;
}

#pragma mark 活动视图
-(FYActivityView *)activityView{
    if (_activityView == nil) {
        _activityView = [[FYActivityView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        _activityView.backgroundLayerColor = [UIColor lightGrayColor];
    }
    return _activityView;
}
#pragma mark 进度显示视图
-(FYTouchMovedView *)movedView{
    if (_movedView == nil) {
        _movedView = [[FYTouchMovedView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
        _movedView.hidden = YES;
    }
    return _movedView;
}

#pragma mark 返回按钮
-(UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[self getPictureWithName:@"back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

#pragma mark 视频名称
-(UILabel *)videoNameLabel{
    if (_videoNameLabel == nil) {
        _videoNameLabel = [[UILabel alloc]init];
        _videoNameLabel.textAlignment = NSTextAlignmentLeft;
        _videoNameLabel.textColor = self.videoNameColor;
    }
    return _videoNameLabel;
}

#pragma mark 播放按钮
-(UIButton *)playButton{
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[self getPictureWithName:@"play"] forState:UIControlStateNormal];
        [_playButton setImage:[self getPictureWithName:@"pause"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

#pragma mark 当前播放时间
-(UILabel *)currentTimeLabel{
    if (_currentTimeLabel == nil) {
        _currentTimeLabel = [[UILabel alloc]init];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.text = @"00:00";
        _currentTimeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _currentTimeLabel;
}
#pragma mark 视频总时长
-(UILabel *)totalTimeLabel{
    if (_totalTimeLabel == nil) {
        _totalTimeLabel = [[UILabel alloc]init];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.text = @"00:00";
        _totalTimeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _totalTimeLabel;
}

#pragma mark 缓冲进度条
-(UIProgressView *)progressView{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc]init];
    }
    return _progressView;
}

#pragma mark 滑块进度条
-(UISlider *)sliderView{
    if (_sliderView == nil) {
        _sliderView = [[FYSlider alloc]init];
        _sliderView.maximumTrackTintColor = [UIColor clearColor];
        _sliderView.minimumTrackTintColor = [UIColor whiteColor];
        [_sliderView setThumbImage:[self getPictureWithName:@"slider"] forState:UIControlStateNormal];
        
        //开始滑动
        [_sliderView addTarget:self action:@selector(progressSliderStartTouch:) forControlEvents:UIControlEventTouchDown];
        //滑块滑动事件
        [_sliderView addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        //结束滑动
        [_sliderView addTarget:self action:@selector(progressSliderEndTouch:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    return _sliderView;
}

#pragma mark 全屏按钮
-(UIButton *)fullScreenButton{
    if (_fullScreenButton == nil) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[self getPictureWithName:@"max"] forState:UIControlStateNormal];
        [_fullScreenButton setImage:[self getPictureWithName:@"min"] forState:UIControlStateSelected];
        [_fullScreenButton addTarget:self action:@selector(fullScreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenButton;
}

#pragma mark 约束
-(void)makeConstraint{
    //顶部工具
    [self.topToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(ToolViewHeight);
    }];
    //底部工具
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(ToolViewHeight);
    }];
    //活动
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(60);
    }];
    //进度显示视图
    [self.movedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    
    //返回按钮
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(MarginPadding);
        make.bottom.mas_equalTo(-MarginPadding);
        make.width.equalTo(self.backButton.mas_height);
    }];
    //视频名称
    [self.videoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.equalTo(self.backButton.mas_right).offset(Padding);
    }];
    
    //播放按钮
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(MarginPadding);
        make.bottom.mas_equalTo(-MarginPadding);
        make.width.equalTo(self.playButton.mas_height);
    }];
    //全屏按钮
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(MarginPadding);
        make.bottom.mas_equalTo(-MarginPadding);
        make.width.equalTo(self.fullScreenButton.mas_height);
    }];
    //当前播放时间
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playButton.mas_right).offset(Padding);
        make.width.mas_equalTo(45);
        make.centerY.equalTo(self.bottomToolView);
    }];
    //总时间
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullScreenButton.mas_left).offset(-Padding);
        make.width.mas_equalTo(45);
        make.centerY.equalTo(self.bottomToolView);
    }];
    //缓冲进度条
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTimeLabel.mas_right).offset(Padding);
        make.right.equalTo(self.totalTimeLabel.mas_left).offset(-Padding);
        make.height.mas_equalTo(2);
        make.centerY.equalTo(self.bottomToolView);
    }];
    //滑动进度条
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.progressView);
    }];
}

-(void)setVideoNameColor:(UIColor *)videoNameColor{
    _videoNameColor = videoNameColor;
    self.videoNameLabel.textColor = _videoNameColor;
}
-(void)setProgressViewColor:(UIColor *)progressViewColor{
    _progressViewColor = progressViewColor;
    self.progressView.progressTintColor = progressViewColor;
}
#pragma mark 返回按钮点击事件
-(void)backButtonClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(toolView:backSelected:)]) {
        [self.delegate toolView:self backSelected:sender];
    }
}
#pragma mark 播放视频事件
-(void)playButtonClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(toolView:playVieo:)]) {
        [self.delegate toolView:self playVieo:sender];
    }
}

#pragma mark 开始滑动
-(void)progressSliderStartTouch:(UISlider *)slider{
    if ([self.delegate respondsToSelector:@selector(toolView:slideStartTouch:)]) {
        [self.delegate toolView:self slideStartTouch:slider];
    }
}

#pragma mark 滑块滑动事件
-(void)progressSliderValueChanged:(UISlider *)slider{
    if ([self.delegate respondsToSelector:@selector(toolView:slideValueChangeEvent:)]) {
        [self.delegate toolView:self slideValueChangeEvent:slider];
    }
}

#pragma mark 结束滑动
-(void)progressSliderEndTouch:(UISlider *)slider{
    if ([self.delegate respondsToSelector:@selector(toolView:slideEndTouch:)]) {
        [self.delegate toolView:self slideEndTouch:slider];
    }
}

#pragma mark 全屏按钮点击事件
-(void)fullScreenButtonClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(toolView:fullScreenSelected:)]) {
        [self.delegate toolView:self fullScreenSelected:sender];
    }
}

#pragma mark 显示活动视图
-(void)showActivityView{
    [self.activityView showAnimation];
}

#pragma mark 隐藏活动视图
-(void)hideActivityView{
    [self.activityView hideAnimation];
}
#pragma mark 点击工具条出现
-(void)tapClick{
//    self.movedView.hidden = YES;
//    if ([self.delegate respondsToSelector:@selector(toolViewAppear:withIsDisAppear:)]) {
//        [self.delegate toolViewAppear:self withIsDisAppear:self.isDisAppear];
//    }
}

#pragma mark 手势
//触摸开始
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    //获取触摸开始的坐标
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self];
    //开始触摸显示进度视图
    self.movedView.hidden = YES;
    [self.delegate touchesBeganWithPoint:currentP];
    if ([self.delegate respondsToSelector:@selector(toolViewAppear:withIsDisAppear:)]) {
        [self.delegate toolViewAppear:self withIsDisAppear:self.isDisAppear];
    }
}

//触摸结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self];
    self.movedView.hidden = YES;
    [self.delegate touchesEndWithPoint:currentP];
}

//移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self];
    self.movedView.hidden = NO;
    self.direction = DirectionNone;
    [self.delegate touchesMoveWithPoint:currentP];
}

//setter
-(void)setTouchProgressValue:(CGFloat)touchProgressValue{
    _touchProgressValue = touchProgressValue;
    [self.movedView.touchProgress setProgress: touchProgressValue];
}
-(void)setTouchTitle:(NSString *)touchTitle{
    _touchTitle = touchTitle;
    self.movedView.titleLabel.text = touchTitle;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [self makeConstraint];
}

#pragma mark - 获取资源图片
-(UIImage *)getPictureWithName:(NSString *)name{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FYPlayer" ofType:@"bundle"]];
    NSString *path   = [bundle pathForResource:name ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
