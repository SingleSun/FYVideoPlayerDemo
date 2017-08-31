//
//  FYSlider.m
//  FYVideoPlayerDemo
//
//  Created by 樊杨 on 2017/8/27.
//  Copyright © 2017年 YHCRT.FY. All rights reserved.
//

#import "FYSlider.h"
#define thumbBound_x 10
#define thumbBound_y 20

@interface FYSlider()
{
    CGRect lastBounds;
}
@end

@implementation FYSlider

// 控制slider的宽和高，这个方法才是真正的改变slider滑道的高的
- (CGRect)trackRectForBounds:(CGRect)bounds{
    [super trackRectForBounds:bounds];
    return CGRectMake(bounds.origin.x, bounds.origin.y, CGRectGetWidth(bounds), 2);
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    
    rect.origin.x = rect.origin.x;
    rect.size.width = rect.size.width ;
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    
    lastBounds = result;
    return result;
}

//增加滑块的触摸范围
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *result = [super hitTest:point withEvent:event];
    if ((point.y >= -thumbBound_y) && (point.y < lastBounds.size.height + thumbBound_y)&&
        (point.x >= 0 && point.x < CGRectGetWidth(self.bounds))) {
        result = self;
    }
    return result;
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL result = [super pointInside:point withEvent:event];
    if (!result && point.y > -10) {
        if ((point.x >= lastBounds.origin.x - thumbBound_x) && (point.x <= (lastBounds.origin.x + lastBounds.size.width + thumbBound_x)) && (point.y < (lastBounds.size.height + thumbBound_y))) {
            result = YES;
        }
        
    }
    return result;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
