//
//  Interface.h
//  QQMusic
//
//  Created by jiaojiao on 5/14/16.
//  Copyright © 2016 XGZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResultBlock)(id result);

@interface Interface : NSObject

//热门榜单
+ (void)getHotList:(NSString *)topId resultBlock:(ResultBlock)resultBlock;

//查询歌曲
+ (void)querySong:(NSString *)keyword resultBlock:(ResultBlock)resultBlock;

@end
