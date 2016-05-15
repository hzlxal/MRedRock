//
//  Request.h
//  QQMusic
//
//  Created by jiaojiao on 5/14/16.
//  Copyright © 2016 XGZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef void(^RequestFinishBlock)(id result);

@interface Request : NSObject

+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlString params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod completeBlock:(RequestFinishBlock)block;

@end
