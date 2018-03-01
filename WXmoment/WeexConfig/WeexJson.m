//
// Created by sunhk on 2018/2/27.
// Copyright (c) 2018 DW. All rights reserved.
//

#import "WeexJson.h"

typedef void(^callbackBlock)(NSDictionary *dict, NSData *data);

@implementation WeexJson
+ (void)getWeexInfo:(NSString *)url cb:(callbackBlock)aCallback {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];

    // 基本网络请求
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode == 200) {
                // 把json解析成字符串
                // NSString *string = [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy];
                // 把json解析成对象
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                aCallback(dict, data);
            }
        }
    }];
//    [self compareVersion:@"user"];
    [dataTask resume];
}

/**
 * 初始化方法, 用于获取jsBundles文件
 */
+ (void)init {
    NSDictionary *localDict = [self getData:@"data122"];
    NSString *url = @"http://192.168.215.159:8196/getWeexInfo?";
    int random = arc4random();
    url = [url stringByAppendingFormat:@"%d", random];
    NSLog(@"请求的url为:%@", url);
    [self getWeexInfo:url cb:^(NSDictionary *webDict, NSData *data) {
        [self compare:localDict webDict:webDict];
    }];
}

/**
 * 下载所有文件
 * @param dict json对象
 */
+ (void)downloadAllFile:(NSDictionary *)dict {
    for (NSString *key in dict) {
        NSDictionary *jsonData = [dict objectForKey:key];
        NSString *jsUrl = [jsonData objectForKey:@"jsUrl"];
        NSString *fileName = key;
        [self downloadFile:jsUrl fileName:fileName];
    }
}

/**
 * 下载单个文件
 * @param jsUrl js的网络url
 * @param fileName 文件名称, 如:user, 最终会拼成user.js
 */
+ (void)downloadFile:(NSString *)jsUrl fileName:(NSString *)name {
    NSString *filePath = [name stringByAppendingString:@".js"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:filePath];
    NSLog(@"File is Download to: %@", path);
    [self getWeexInfo:jsUrl cb:^(NSDictionary *dict, NSData *data) {
        [data writeToFile:path atomically:YES];
    }];
}

/**
 * 比较网络和本地
 * @param localDict
 * @param webDict
 */
+ (void)compare:(NSDictionary *)localDict webDict:(NSDictionary *)webDict {
    if (localDict == nil) {
        NSLog(@"No Data");
        [self downloadAllFile:webDict];
    } else {
        for (NSString *key in localDict) {
            NSDictionary *localObj = [localDict objectForKey:key];
            NSDictionary *webObj = [webDict objectForKey:key];
            NSString *localVersion = [localObj objectForKey:@"version"];
            NSString *webVersion = [webObj objectForKey:@"version"];
            NSString *jsUrl = [webObj objectForKey:@"jsUrl"];
            NSLog(@"local %@ web %@", localVersion, webVersion);
//            if([webVersion intValue] > [localVersion intValue]) {
            NSLog(@"download url is %@", jsUrl);
            [self downloadFile:jsUrl fileName:key];
//            }
        }
    }
    // 把本地的字典重置
    [self setData:@"data122" dict:webDict];
}

+ (void)compareVersion:(NSString *)name {
    NSDictionary *data = [self getData:@"data"];
    if (data == nil) {
        NSLog(@"--------Empty");
    } else {
        NSLog(@"--------Not Empty");
        for (NSString *key in data) {
            NSLog(@"key=%@, name=%@", key, name);
            if ([key isEqualToString:name]) {
                NSDictionary *jsonData = [data objectForKey:key];
                NSString *jsUrl = [jsonData objectForKey:@"jsUrl"];
                NSString *isWeex = [jsonData objectForKey:@"isWeex"];
                NSString *webUrl = [jsonData objectForKey:@"webUrl"];
                NSString *version = [jsonData objectForKey:@"version"];
                NSLog(@"jsUrl=%@, isWeex=%@, webUrl=%@, version=%@", jsUrl, isWeex, webUrl, version);
            }
        }
    }
}

+ (void)parseJSON:(NSDictionary *)dict {
    for (id key in dict) {
        NSLog(@"key :%@ value: %@", key, [dict objectForKey:key]);
    }
}

/**
 * 添加本地数据
 * @param key
 * @param dict
 */
+ (void)setData:(NSString *)key dict:(NSDictionary *)dict {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dict forKey:key];
}

/**
 * 在本地获取数据
 * @param key
 * @return
 */
+ (NSDictionary *)getData:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *val = [defaults objectForKey:key];
    return val;
}

@end