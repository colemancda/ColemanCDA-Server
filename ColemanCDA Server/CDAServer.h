//
//  CDAServer.h
//  ColemanCDA Server
//
//  Created by Alsey Coleman Miller on 7/17/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CDAServerErrorCode) {
  
    kCDAServerErrorNone = 0,
    kCDAServerErrorCouldNotCreateSocket = 1,
    kCDAServerErrorCouldNotSetPort = 100
    
};

static void SocketCallBack (CFSocketRef s,
                     CFSocketCallBackType callbackType,
                     CFDataRef address,
                     const void *data,
                     void *info);

@interface CDAServer : NSObject
{
    CFSocketRef _socketIPv4;
    CFSocketRef _socketIPv6;
}

@property (readonly) NSUInteger port;

@property (readonly) BOOL isRunning;

-(NSError *)startServerOnPort:(NSUInteger)port;

-(void)stopServer;

@end
