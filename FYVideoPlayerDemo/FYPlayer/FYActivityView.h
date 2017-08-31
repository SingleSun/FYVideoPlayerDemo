//
//  FYActivityView.h
//  FYVideoPlayerDemo
//
//  Created by 樊杨 on 2017/8/28.
//  Copyright © 2017年 YHCRT.FY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYActivityView : UIView

/**背景颜色*/
@property(nonatomic,strong)UIColor * backgroundLayerColor;

/**指示器颜色*/
@property(nonatomic,strong)UIColor * indicatorColor;

/**显示活动指示器*/
-(void)showAnimation;

/**隐藏*/
-(void)hideAnimation;

@end
