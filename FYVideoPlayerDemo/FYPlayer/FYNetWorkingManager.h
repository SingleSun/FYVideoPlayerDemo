//
//  FYNetWorkingManager.h
//  FYVideoPlayerDemo
//
//  Created by 樊杨 on 2017/8/30.
//  Copyright © 2017年 YHCRT.FY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface FYNetWorkingManager : NSObject

+(void)fy_netWorkingManager:(void(^)(AFNetworkReachabilityStatus status))netWorkStatue;

@end
