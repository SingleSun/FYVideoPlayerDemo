//
//  FYActivityView.m
//  FYVideoPlayerDemo
//
//  Created by 樊杨 on 2017/8/28.
//  Copyright © 2017年 YHCRT.FY. All rights reserved.
//

#import "FYActivityView.h"

@interface FYActivityView()

@property(nonatomic,strong)CAReplicatorLayer * replicatorLayer;

@property(nonatomic,strong)CALayer * dotLayer;

@end

@implementation FYActivityView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupActivityLayer];
    }
    return self;
}

-(void)setupActivityLayer{
    _replicatorLayer = [CAReplicatorLayer layer];
    _replicatorLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _replicatorLayer.cornerRadius = 10.0;
    _replicatorLayer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor blackColor]);
    [self.layer addSublayer:_replicatorLayer];
    _replicatorLayer.instanceCount = 3;
    _replicatorLayer.instanceTransform = CATransform3DMakeTranslation(_replicatorLayer.frame.size.width/3, 0, 0);
    //添加旋转地点
    _dotLayer = [CALayer layer];
    _dotLayer.bounds = CGRectMake(0, 0, 15, 15);
    _dotLayer.position = CGPointMake(15, _replicatorLayer.frame.size.height/2.0-7.5);
    _dotLayer.backgroundColor = [UIColor whiteColor].CGColor;
    _dotLayer.cornerRadius = 7.5;
    [_replicatorLayer addSublayer:_dotLayer];
}

-(void)setBackgroundLayerColor:(UIColor *)backgroundLayerColor{
    _backgroundLayerColor = backgroundLayerColor;
    _replicatorLayer.backgroundColor = (__bridge CGColorRef _Nullable)(backgroundLayerColor);
}

#pragma mark 显示
-(void)showAnimation{
    self.hidden = NO;
    _dotLayer.transform = CATransform3DMakeScale(0, 0, 0);
    _replicatorLayer.instanceDelay = 1.0/3.0;
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1.0;
    animation.fromValue = @1;
    animation.toValue  = @0;
    animation.repeatCount = MAXFLOAT;
    [_dotLayer addAnimation:animation forKey:nil];
    
}

-(void)hideAnimation{
    [_dotLayer removeAllAnimations];
    self.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
