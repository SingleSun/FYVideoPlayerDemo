//
//  FYPlayerView.m
//  FYVideoPlayerDemo
//
//  Created by 樊杨 on 2017/8/25.
//  Copyright © 2017年 YHCRT.FY. All rights reserved.
//

#import "FYPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "FYPlayerToolView.h"
#import "FYSlider.h"
#import "FYActivityView.h"
#import <MediaPlayer/MediaPlayer.h>
#define FYScreenWidth [UIScreen mainScreen].bounds.size.width

#define FYScreenHeight [UIScreen mainScreen].bounds.size.height
// 播放器的几种状态
typedef NS_ENUM(NSInteger, FYPlayerState) {
    FYPlayerStateFailed,     // 播放失败
    FYPlayerStateBuffering,  // 缓冲中
    FYPlayerStatePlaying,    // 播放中
    FYPlayerStateStopped,    // 停止播放
    FYPlayerStatePause       // 暂停播放
};
@interface FYPlayerView()<FYPlayerToolViewDelegate>
@property (nonatomic, assign) FYPlayerState state;
/**播放器*/
@property(nonatomic,strong)AVPlayer * player;
/**播放器item*/
@property(nonatomic,strong)AVPlayerItem * playerItem;
/**播放器layer图层*/
@property(nonatomic,strong)AVPlayerLayer * playerLayer;
/**当前播放时间计时*/
@property(nonatomic,strong)NSTimer * stackTimer;
/**是否是全屏*/
@property(nonatomic,assign)BOOL isFullScreen;
/**是否是点击按钮进去全屏*/
@property(nonatomic,assign)BOOL isFullScreenButton;
/**获取播放器所在的父视图*/
@property(nonatomic,strong)UIView * playerSuperView;
/**播放器原始大小*/
@property(nonatomic,assign)CGRect orginalFrame;
/**状态栏*/
@property (nonatomic, strong) UIView *statusBar;
/**工具条消失*/
@property(nonatomic,strong)NSTimer * toolTimer;
/**工具条是否消失*/
@property(nonatomic,assign)BOOL isDisAppear;
/**视频播放进度*/
@property(nonatomic,assign)CGFloat startVideoRate;
/**系统音量或亮度*/
@property(nonatomic,assign)CGFloat startVolume;
/**触摸起始点*/
@property(nonatomic,assign)CGPoint startPoint;

@property (strong, nonatomic) MPVolumeView *volumeView;//控制音量的view

@property (strong, nonatomic) UISlider* volumeViewSlider;//控制音量
@end

@implementation FYPlayerView

#pragma mark 懒加载
#pragma mark 系统音量
- (MPVolumeView *)volumeView {
    if (_volumeView == nil) {
        _volumeView  = [[MPVolumeView alloc] init];
        [_volumeView sizeToFit];
        for (UIView *view in [_volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                self.volumeViewSlider = (UISlider*)view;
                break;
            }
        }
    }
    return _volumeView;
}

-(FYPlayerToolView *)playToolView{
    if (_playToolView == nil) {
        _playToolView = [[FYPlayerToolView alloc]init];
        _playToolView.delegate = self;
        _playToolView.backButton.hidden = YES;
        _playToolView.direction = DirectionNone;
        //工具条消失
        _toolTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(playerToolDisappear) userInfo:nil repeats:NO];
    }
    return _playToolView;
}

- (UIView *) statusBar{
    if (_statusBar == nil){
        _statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    }
    return _statusBar;
}

- (void)setState:(FYPlayerState)state{
    _state = state;
    if (state == FYPlayerStateBuffering) {
        [self.playToolView showActivityView];
    }else if (state == FYPlayerStateFailed){
        [self.playToolView hideActivityView];
    }else{
        [self.playToolView hideActivityView];
    }
}

#pragma mark - 隐藏或者显示状态栏方法
- (void)setStatusBarHidden:(BOOL)hidden{
    //设置是否隐藏
    self.statusBar.hidden = hidden;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //初始化播放器参数
        self.progressBufferColor = [UIColor redColor];
        self.videoNameColor = [UIColor whiteColor];
        self.isAllowLandscape = NO;
        //初始化计时器
        _stackTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(stackTime) userInfo:nil repeats:YES];
        //开启
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        //屏幕旋转通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
        [self createUI];
    }
    return self;
}
#pragma mark 创建视图
-(void)createUI{
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.playToolView];
    self.volumeView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width * 9.0 / 16.0);
    [self.playToolView showActivityView];
}

#pragma mark 视频播放地址
-(void)setUrl:(NSURL *)url{
    _url = url;
    //播放器项目
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    //创建播放器
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    //创建视图层
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResize;
    //放到最下面，防止遮挡
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
-(void)setPlayerItem:(AVPlayerItem *)playerItem{
    _playerItem = playerItem;
    
    //播放完通知
    [[NSNotificationCenter defaultCenter] addObserver:self           selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];

    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监听视频缓冲数据
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //缓冲数据为空的
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
}


#pragma mark 监听视频缓冲进度
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    //播放状态
    if ([keyPath isEqualToString:@"status"]) {
        if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            self.state = FYPlayerStatePlaying;
        }
        else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
            self.state = FYPlayerStateFailed;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [self.playToolView.progressView setProgress:timeInterval / totalDuration animated:NO];
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        //当缓冲区是空的时候
        if (self.playerItem.isPlaybackBufferEmpty) {
            self.state = FYPlayerStateBuffering;
            [self bufferingSomeSecond];
        }
    }else if([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
        if (self.playerItem.isPlaybackLikelyToKeepUp&& self.state == FYPlayerStateBuffering) {
            self.state = FYPlayerStatePlaying;
            [self playVideo];
        }
    }
}
#pragma mark - 缓冲较差时候
//卡顿时会走这里
- (void)bufferingSomeSecond{
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self pausePlay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playVideo];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        if (!self.playerItem.isPlaybackLikelyToKeepUp) {
            [self bufferingSomeSecond];
        }
    });
}
#pragma mark 计算缓冲进度
-(NSTimeInterval)availableDuration{
    //当期已加载的视频时间
    NSArray * loadedTimeRange = [[self.player currentItem] loadedTimeRanges];
    //获取已加载的时间缓冲区
    CMTimeRange timeRange = [[loadedTimeRange firstObject] CMTimeRangeValue];
    CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
    CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
    //视频已经加载总时间
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}

#pragma mark timerAction
-(void)stackTime{
    if (self.playerItem.duration.timescale != 0) {
        self.playToolView.sliderView.maximumValue = 1;//总时长
        self.playToolView.sliderView.value =  CMTimeGetSeconds([_playerItem currentTime]) / (_playerItem.duration.value / self.playerItem.duration.timescale);
        NSLog(@"sliderValue == %f",self.playToolView.sliderView.value);
    
        //当前时长进度progress
        NSInteger proMin = (NSInteger)CMTimeGetSeconds([_player currentTime]) / 60;//当前秒
        NSInteger proSec = (NSInteger)CMTimeGetSeconds([_player currentTime]) % 60;//当前分
        
        //总时长
        NSInteger durMin = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale / 60;//总秒
        NSInteger durSec = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale % 60;//总分钟
        
        self.playToolView.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",proMin,proSec];
        self.playToolView.totalTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",durMin,durSec];
    }
}
#pragma mark FYPlayerToolViewDelegate
-(void)toolView:(FYPlayerToolView *)playToolView playVieo:(UIButton *)playButton{
    if (playButton.selected == YES) {
        //暂停播放
        [self pausePlay];
    }else{
        [self playVideo];
    }
}
#pragma mark 工具条消失
-(void)playerToolDisappear{
    [UIView animateWithDuration:0.5 animations:^{
        self.playToolView.topToolView.alpha    = 0;
        self.playToolView.bottomToolView.alpha = 0;
    } completion:^(BOOL finished) {
        [_toolTimer invalidate];
        _toolTimer = nil;
    }];
    _isDisAppear = YES;
}

/**播放视频*/
-(void)playVideo{
    self.playToolView.playButton.selected = YES;
    self.playToolView.videoNameLabel.text = self.videoName;
    [self.player play];
}
/** 暂停播放*/
-(void)pausePlay{
    self.playToolView.playButton.selected = NO;
    [self.player pause];
}

#pragma mark - 播放完成
-(void)playFinished:(id)sender{
    [self pausePlay];
}

#pragma mark 返回
-(void)toolView:(FYPlayerToolView *)playToolView backSelected:(UIButton *)backButton{
    [self portraitScreen];
}

#pragma mark 开始滑动
-(void)toolView:(FYPlayerToolView *)playToolView slideStartTouch:(UISlider *)slider{
    //[self pausePlay];
    [_toolTimer invalidate];
    _toolTimer = nil;
}
/**滑块拖动*/
-(void)toolView:(FYPlayerToolView *)playToolView slideValueChangeEvent:(UISlider *)slider{
    //拖动改变视频播放进度
    if (_player.status == AVPlayerStatusReadyToPlay) {
        
        //计算出拖动的当前秒数
        CGFloat total = _playerItem.duration.value/_playerItem.duration.timescale;
        
        NSInteger dragedSeconds = floorf(total * slider.value);
        
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        [self.player seekToTime:dragedCMTime];
    }
}

#pragma mark 滑块结束拖动
-(void)toolView:(FYPlayerToolView *)playToolView slideEndTouch:(UISlider *)slider{
    if (!self.playerItem.isPlaybackLikelyToKeepUp) {
        [self bufferingSomeSecond];
    }
}

#pragma mark 全屏按钮点击方法
-(void)toolView:(FYPlayerToolView *)playToolView fullScreenSelected:(UIButton *)fullScreenButton{
    if (fullScreenButton.selected == YES) {
        [self portraitScreen];
        return;
    }
    _isFullScreenButton = YES;
    self.playToolView.backButton.hidden = NO;
    [self fullScreenWithDirection:UIInterfaceOrientationLandscapeRight];
}

#pragma mark 全屏
-(void)fullScreenWithDirection:(UIInterfaceOrientation)direction{
    //记录播放器父视图
    _playerSuperView = self.superview;
    _orginalFrame = self.frame;
//    //添加到Window上
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [self setStatusBarHidden:YES];
    if (_isAllowLandscape == YES){
        //手动点击需要旋转方向
        if (_isFullScreenButton) {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
        }
        if (keyWindow.frame.size.width < keyWindow.frame.size.height) {
            self.frame = CGRectMake(0, 0, FYScreenHeight, FYScreenWidth);
        }else{
            self.frame = CGRectMake(0, 0, FYScreenWidth, FYScreenHeight);
        }
    }else{
        //播放器所在控制器不支持旋转，采用旋转view的方式实现
        if (direction == UIInterfaceOrientationLandscapeLeft){
            [UIView animateWithDuration:0.25 animations:^{
                self.transform = CGAffineTransformMakeRotation(M_PI / 2);
            }];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
        }else if (direction == UIInterfaceOrientationLandscapeRight) {
            [UIView animateWithDuration:0.25 animations:^{
                self.transform = CGAffineTransformMakeRotation( - M_PI / 2);
            }];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
        }
        self.frame = CGRectMake(0, 0, FYScreenHeight, FYScreenWidth);
    }
    
    _isFullScreen = YES;
    self.playToolView.fullScreenButton.selected = YES;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark 点击工具条出现
-(void)toolViewAppear:(FYPlayerToolView *)playToolView withIsDisAppear:(BOOL)isDisAppear{
    if (_isDisAppear) {
        [UIView animateWithDuration:0.5 animations:^{
            _toolTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(playerToolDisappear) userInfo:nil repeats:NO];

            playToolView.topToolView.alpha = 1.0;
            playToolView.bottomToolView.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
        playToolView.topToolView.alpha = 0;
        playToolView.bottomToolView.alpha = 0;
        } completion:^(BOOL finished) {
        }];
    }
    _isDisAppear = !_isDisAppear;
}

#pragma mark 手势代理方法
//开始触摸
-(void)touchesBeganWithPoint:(CGPoint)point{
    self.startPoint = point;
    if (self.startPoint.x <= self.playToolView.frame.size.width/2.0) {
        self.startVolume = [UIScreen mainScreen].brightness;
    }else{
        self.startVolume = self.volumeViewSlider.value;
    }
    //当前播放进度
    self.startVideoRate = self.playToolView.sliderView.value;
}

//手势移动
-(void)touchesMoveWithPoint:(CGPoint)point{
    CGPoint panPoint = CGPointMake(point.x-self.startPoint.x, point.y-self.startPoint.y);
    //判断用户的滑动方向
    if (self.playToolView.direction == DirectionNone) {
        if (panPoint.x >= 30 || panPoint.x <= -30 ) {
            //进度
            self.playToolView.direction = DirectionLeftOrRight;
        }else if (panPoint.y >= 20 || panPoint.y <= -20){
            //亮度和音量
            self.playToolView.direction = DirectionUpOrDown;
        }
    }
    
    if (self.playToolView.direction == DirectionNone) {
        return;
    }else if (self.playToolView.direction == DirectionUpOrDown){
        //音量和亮度
        if (self.startPoint.x <= self.playToolView.frame.size.width/2.0) {
            if (panPoint.y < 0) {
                //增加亮度
                [[UIScreen mainScreen] setBrightness:self.startVolume + (-panPoint.y / 20.0 / 10)];
            }else{
                //减少亮度
                [[UIScreen mainScreen] setBrightness:self.startVolume + (-panPoint.y / 20.0 / 10)];
            }
        }else{
            //设置音量
            if (panPoint.y < 0) {
                //增加音量
                [self.volumeViewSlider setValue:self.startVolume + (-panPoint.y/20.0/10) animated:YES];
            }else{
                //减少音量
                [self.volumeViewSlider setValue:self.startVolume - (panPoint.y/20.0/10) animated:YES];
            }
        }
    }else if (self.playToolView.direction == DirectionLeftOrRight){
        //[self pausePlay];
        CGFloat rate = self.startVideoRate + (panPoint.x/30.0/20.0);
        CGFloat total = _playerItem.duration.value/_playerItem.duration.timescale;
        
        NSInteger dragedSeconds = floorf(total * rate);
        
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        [self.player seekToTime:dragedCMTime];
        
        NSInteger proMin = dragedSeconds / 60;//当前秒
        NSInteger proSec = dragedSeconds % 60;//当前分
        
        self.playToolView.touchTitle = [NSString stringWithFormat:@"%02ld:%02ld",proMin,proSec];
        
        self.playToolView.touchProgressValue = rate;
    }
}

//触摸结束
-(void)touchesEndWithPoint:(CGPoint)point{
//    if (self.playToolView.direction == DirectionLeftOrRight) {
//        [self playVideo];
//    }
}

#pragma mark 竖屏
-(void)portraitScreen{
    _isFullScreen = NO;
    self.playToolView.backButton.hidden = YES;
    [self setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    if (_isAllowLandscape) {
        //还原为竖屏
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }else{
        //还原
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformMakeRotation(0);
        }];
    }
    self.frame = _orginalFrame;
    [_playerSuperView addSubview:self];
    _isFullScreenButton = NO;
    self.playToolView.fullScreenButton.selected = NO;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark 屏幕旋转通知
-(void)orientChange:(NSNotification *)noti{
     UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft){
        if (_isFullScreen == NO){
            if (_isAllowLandscape) {
                //播放器所在控制器页面支持旋转情况下，和正常情况是相反的
                [self fullScreenWithDirection:UIInterfaceOrientationLandscapeRight];
            }else{
                [self fullScreenWithDirection:UIInterfaceOrientationLandscapeLeft];
            }
        }
    }else if (orientation == UIDeviceOrientationLandscapeRight){
        if (_isFullScreen == NO){
            if (_isAllowLandscape) {
                [self fullScreenWithDirection:UIInterfaceOrientationLandscapeLeft];
            }else{
                [self fullScreenWithDirection:UIInterfaceOrientationLandscapeRight];
            }
        }
    }else if (orientation == UIDeviceOrientationPortrait){
        if (_isFullScreen == YES){
            [self portraitScreen];
        }
    }
}

-(void)setVideoNameColor:(UIColor *)videoNameColor{
    _videoNameColor = videoNameColor;
    self.playToolView.videoNameColor = videoNameColor;
}
-(void)setProgressBufferColor:(UIColor *)progressBufferColor{
    _progressBufferColor = progressBufferColor;
    self.playToolView.progressViewColor = progressBufferColor;
}
-(void)setVideoName:(NSString *)videoName{
    _videoName = videoName;
    self.playToolView.videoNameLabel.text = videoName;
}

#pragma mark - layoutSubviews
-(void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    self.playToolView.frame = self.bounds;
}
-(void)destoryAllTimer{
    [_stackTimer invalidate];
    _stackTimer = nil;
    [_toolTimer invalidate];
    _toolTimer = nil;
}

-(void)dealloc{
    [self destoryAllTimer];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //回到竖屏
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    //重置状态条
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    //恢复默认状态栏显示与否
    [self setStatusBarHidden:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
