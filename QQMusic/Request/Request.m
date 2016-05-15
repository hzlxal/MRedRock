//
//  Request.m
//  QQMusic
//
//  Created by jiaojiao on 5/14/16.
//  Copyright © 2016 XGZ. All rights reserved.
//

#import "Request.h"
#import "ASIDataDecompressor.h"

#define kBaseUrl @"http://route.showapi.com/"

@implementation Request

+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlString params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod completeBlock:(RequestFinishBlock)block
{
    urlString = [kBaseUrl stringByAppendingString:urlString];
    
    // 系统级参数
    [params setObject:@"6091" forKey:@"showapi_appid"]; // 易源应用id
    [params setObject:@"a3b9cb3921c74e0ba31d2d7b2fbbed77" forKey:@"showapi_sign"]; // 数字签名
    
    // 处理GET请求方式的参数
    NSComparisonResult comparRet1 = [httpMethod caseInsensitiveCompare:@"GET"];
    if (comparRet1 == NSOrderedSame) {
        NSMutableString *paramsString = [NSMutableString string];
        NSArray *allKeys = [params allKeys];
        for (int i = 0; i < params.count; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            id value = [params objectForKey:key];
            
            [paramsString appendFormat:@"%@=%@", key, value];
            
            if (i < params.count -1) {
                [paramsString appendString:@"&"];
            }
        }
        
        if (paramsString.length > 0) {
            urlString = [urlString stringByAppendingFormat:@"%@",paramsString];
        }
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setTimeOutSeconds:60]; // 设置请求超时时间
    [request setRequestMethod:httpMethod]; // 设置请求方式
    [request setShouldWaitToInflateCompressedResponses:YES]; // 实时解压缩
    
    // 处理POST请求方式的参数
    NSComparisonResult comparRet = [httpMethod caseInsensitiveCompare:@"POST"];
    if (comparRet == NSOrderedSame) {
        NSArray *allKeys = [params allKeys];
        for (int i = 0; i < params.count; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            id value = [params objectForKey:key];
            
            // 判断是否上传文件(一个或多个)
            if ([value isKindOfClass:[NSArray class]]) {
                NSArray *arrPicture = [[NSArray alloc] initWithArray:value];
                for (int j = 0; j < arrPicture.count; j++) {
                    NSData *pictureData = UIImageJPEGRepresentation(arrPicture[j], 0.75);
                    NSString *pictureName = [NSString stringWithFormat:@"%@.jpg", kTimestamp];
                    [request addData:pictureData withFileName:pictureName andContentType:@"image/jpeg" forKey:[NSString stringWithFormat:@"img%d", j]];
                }
            } else {
                [request addPostValue:value forKey:key];
            }
        }
    }
    
    // 设置请求完成的block
    [request setCompletionBlock:^{
        id result = nil;
        result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if (block != nil) {
            block(result);
        }
    }];
    
    // 设置请求失败的block
    [request setFailedBlock:^{
        if (block != nil) {
            id result = nil;
            block(result);
        }
    }];
    
    [request startAsynchronous];
    
    return request;
}

@end
