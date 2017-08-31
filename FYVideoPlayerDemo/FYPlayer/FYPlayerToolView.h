//
//  FYPlayerToolView.h
//  FYVideoPlayerDemo
//
//  Created by 樊杨 on 2017/8/25.
//  Copyright © 2017年 YHCRT.FY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FYSlider;
@class FYPlayerToolView;
@class FYActivityView;
@class FYTouchMovedView;

typedef NS_ENUM(NSUInteger, Direction) {
    DirectionLeftOrRight,
    DirectionUpOrDown,
    DirectionNone
};
/**代理*/
@protocol FYPlayerToolViewDelegate <NSObject>

@optional
/**播放代理*/
-(void)toolView:(FYPlayerToolView *)playToolView playVieo:(UIButton *)playButton;

/**返回代理*/
-(void)toolView:(FYPlayerToolView *)playToolView backSelected:(UIButton *)backButton;

/**全屏代理*/
-(void)toolView:(FYPlayerToolView *)playToolView fullScreenSelected:(UIButton *)fullScreenButton;

/**开始滑动*/
-(void)toolView:(FYPlayerToolView *)playToolView slideStartTouch: (UISlider *)slider;

/**滑块拖动*/
-(void)toolView:(FYPlayerToolView *)playToolView slideValueChangeEvent: (UISlider *)slider;

/**结束滑动*/
-(void)toolView:(FYPlayerToolView *)playToolView slideEndTouch: (UISlider *)slider;

/**点击工具条出现*/
-(void)toolViewAppear:(FYPlayerToolView *)playToolView withIsDisAppear:(BOOL)isDisAppear;

/**触摸代理*/
/**
 * 开始触摸
 */
- (void)touchesBeganWithPoint:(CGPoint)point;

/**
 * 结束触摸
 */
- (void)touchesEndWithPoint:(CGPoint)point;

/**
 * 滑动手指
 */
- (void)touchesMoveWithPoint:(CGPoint)point;

@end

/**播放器工具视图*/
@interface FYPlayerToolView : UIView

/**顶部栏目视图*/
@property(nonatomic,strong)UIView * topToolView;
/**返回按钮*/
@property(nonatomic,strong)UIButton * backButton;
/**视频标题*/
@property(nonatomic,strong)UILabel * videoNameLabel;
/**底部工具条*/
@property(nonatomic,strong)UIView * bottomToolView;
/**播放按钮*/
@property(nonatomic,strong)UIButton * playButton;
/**当前播放时间*/
@property(nonatomic,strong)UILabel * currentTimeLabel;
/**视频总时间*/
@property(nonatomic,strong)UILabel * totalTimeLabel;
/**视频进度条*/
@property(nonatomic,strong)FYSlider * sliderView;
/**缓冲进度条*/
@property(nonatomic,strong)UIProgressView * progressView;
/**全屏按钮*/
@property(nonatomic,strong)UIButton * fullScreenButton;
/**数据加载等待视图*/
@property(nonatomic,strong)FYActivityView * activityView;
/**全屏拖拽是进度显示*/
@property(nonatomic,strong)FYTouchMovedView * movedView;

/**视频名称颜色*/
@property(nonatomic,strong)UIColor * videoNameColor;
/**缓冲进度条颜色*/
@property(nonatomic,strong)UIColor * progressViewColor;
/**工具条是否消失*/
@property(nonatomic,assign)BOOL isDisAppear;
/**滑动方向*/
@property (assign, nonatomic) Direction direction;

//拖拽显示视图
/**进度显示值*/
@property(nonatomic,copy)NSString * touchTitle;
/**显示字体颜色*/
@property(nonatomic,strong)UIColor * titleColor;
/**进度颜色*/
@property(nonatomic,strong)UIColor * touchProgressColor;
/**是否显示进度*/
@property(nonatomic,assign)BOOL isShowProgress;
/**进度条值*/
@property(nonatomic,assign)CGFloat touchProgressValue;


/**声明代理*/
@property(nonatomic,weak)id<FYPlayerToolViewDelegate> delegate;

-(void)showActivityView;
-(void)hideActivityView;

@end
