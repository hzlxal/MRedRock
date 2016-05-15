//
//  Interface.m
//  QQMusic
//
//  Created by jiaojiao on 5/14/16.
//  Copyright © 2016 XGZ. All rights reserved.
//

#import "Interface.h"
#import "Request.h"

@implementation Interface

//获取热门榜单
+ (void)getHotList:(NSString *)topId resultBlock:(ResultBlock)resultBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:topId forKey:@"topid"];
    
    [Request requestWithURL:@"213-4" params:parameters httpMethod:@"post" completeBlock:^(id result) {
        if (resultBlock != nil) {
            resultBlock(result);
        }
    }];
}

//查询歌曲
+ (void)querySong:(NSString *)keyword resultBlock:(ResultBlock)resultBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:keyword forKey:@"keyword"];
    
    [Request requestWithURL:@"213-1" params:parameters httpMethod:@"post" completeBlock:^(id result) {
        if (resultBlock != nil) {
            resultBlock(result);
        }
    }];
}

@end
