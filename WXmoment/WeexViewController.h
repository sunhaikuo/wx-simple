//
//  ViewController.h
//  WXmoment
//
//  Created by 孙海阔 on 18/2/14.
//  Copyright © 2018年 DW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketRocket/SRWebSocket.h"

@interface WeexViewController : UIViewController<SRWebSocketDelegate> {
    SRWebSocket *webSocket;
}
- (instancetype) initWithJs:(NSString * )filePath;
@end
