//
//  FYTouchMovedView.h
//  FYVideoPlayerDemo
//
//  Created by 樊杨 on 2017/8/30.
//  Copyright © 2017年 YHCRT.FY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYTouchMovedView : UIView

//拖拽时显示拖拽的进度视图
/**显示拖拽的时间*/
@property(nonatomic,strong)UILabel * titleLabel;
/**拖拽的进度显示*/
@property(nonatomic,strong)UIProgressView * touchProgress;
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

@end
