//
//  FYNetWorkingManager.m
//  FYVideoPlayerDemo
//
//  Created by 樊杨 on 2017/8/30.
//  Copyright © 2017年 YHCRT.FY. All rights reserved.
//

#import "FYNetWorkingManager.h"

@implementation FYNetWorkingManager

+(void)fy_netWorkingManager:(void (^)(AFNetworkReachabilityStatus))netWorkStatue{
    
    //创建网络监听对象
    AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager sharedManager];
    //开始监听
    [manager startMonitoring];
    
    //监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        netWorkStatue(status);
    }];
    //结束监听
}

@end
