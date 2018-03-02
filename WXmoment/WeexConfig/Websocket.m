//
// Created by sunhk on 2018/3/2.
// Copyright (c) 2018 DW. All rights reserved.
//

#import "Websocket.h"


@implementation Websocket
- (instancetype)init {
    NSString *wsUrl = @"ws://192.168.215.159:8083/";
    SRWebSocket *socket = [[SRWebSocket alloc] initWithURLRequest:
            [NSURLRequest requestWithURL:[NSURL URLWithString:wsUrl]]];
    socket.delegate = self;    // 实现这个 SRWebSocketDelegate 协议啊
    [socket open];    // open 就是直接连接了
    NSLog(@"-------------------------------Open!!!");
    return self;
}
#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"Hello");
}

@end