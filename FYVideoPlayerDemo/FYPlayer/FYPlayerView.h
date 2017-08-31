//
//  FYPlayerView.h
//  FYVideoPlayerDemo
//
//  Created by 樊杨 on 2017/8/25.
//  Copyright © 2017年 YHCRT.FY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYPlayerToolView;
@interface FYPlayerView : UIView

/**工具条*/
@property(nonatomic,strong)FYPlayerToolView * playToolView;
/** 视频播放地址 */
@property(nonatomic,strong)NSURL * url;
/** 进度条的颜色*/
@property(nonatomic,strong)UIColor * sliderColor;
/** 进度条背景颜色*/
@property(nonatomic,strong)UIColor * sliderBackgroundColor;
/** 缓冲条颜色*/
@property(nonatomic,strong)UIColor * progressBufferColor;
/**视频名称*/
@property(nonatomic,copy)NSString * videoName;
/**视频名称颜色*/
@property(nonatomic,strong)UIColor * videoNameColor;
/**是否允许横屏*/
@property(nonatomic,assign)BOOL isAllowLandscape;
/**播放视频*/
-(void)playVideo;
/**暂停播放*/
-(void)pausePlay;


@end
