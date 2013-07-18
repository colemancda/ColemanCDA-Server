//
//  CDAServer.m
//  ColemanCDA Server
//
//  Created by Alsey Coleman Miller on 7/17/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "CDAServer.h"
#include <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netinet/in.h>

NSString *const CDAServerErrorDomain = @"com.ColemanCDA.CDAServer";

@implementation CDAServer (SocketSetup)

-(CDAServerErrorCode)setupIPv4SocketForPort:(NSUInteger)port
{
    // create context
    CFSocketContext socketContext = { 0, (__bridge void *)(self), NULL, NULL, NULL };
    
    // create ip4 socket
    _socketIPv4 = CFSocketCreate(kCFAllocatorDefault,
                                 PF_INET,
                                 SOCK_STREAM,
                                 IPPROTO_TCP,
                                 kCFSocketAcceptCallBack,
                                 SocketCallBack,
                                 &socketContext);
    
    if (!_socketIPv4) {
        return kCDAServerErrorCouldNotCreateSocket;
    }
    
    // set port...
    
    // create IPv4 socket address
    struct sockaddr_in sin;
    
    memset(&sin, 0, sizeof(sin));
    sin.sin_len = sizeof(sin);
    sin.sin_family = AF_INET; /* Address family */
    sin.sin_port = htons(port); /* Or a specific port */
    sin.sin_addr.s_addr= INADDR_ANY;
    
    CFDataRef sincfd = CFDataCreate(
                                    kCFAllocatorDefault,
                                    (UInt8 *)&sin,
                                    sizeof(sin));
    
    // set IPv4 address
    CFSocketError setIPv4Error = CFSocketSetAddress(_socketIPv4, sincfd);
    CFRelease(sincfd);
    
    if (setIPv4Error) {
        return kCDAServerErrorCouldNotSetPort;
    }
    
    // have socket run in run loop
    CFRunLoopSourceRef runLoopSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault,
                                                                   _socketIPv4, 0);
    
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    CFRelease(runLoopSource);
    
    return kCDAServerErrorNone;
}

-(CDAServerErrorCode)setupIPv6SocketForPort:(NSUInteger)port
{
    // create context
    CFSocketContext socketContext = { 0, (__bridge void *)(self), NULL, NULL, NULL };
    
    // create IPv6 socket
    _socketIPv6 = CFSocketCreate(kCFAllocatorDefault,
                                 PF_INET6,
                                 SOCK_STREAM,
                                 IPPROTO_TCP,
                                 kCFSocketAcceptCallBack,
                                 SocketCallBack,
                                 &socketContext);
    
    if (!_socketIPv6) {
        return kCDAServerErrorCouldNotCreateSocket;
    }
    
    // set port...
    
    struct sockaddr_in6 sin6;
    
    memset(&sin6, 0, sizeof(sin6));
    sin6.sin6_len = sizeof(sin6);
    sin6.sin6_family = AF_INET6; /* Address family */
    sin6.sin6_port = htons(port); /* Or a specific port */
    sin6.sin6_addr = in6addr_any;
    
    CFDataRef sin6cfd = CFDataCreate(
                                     kCFAllocatorDefault,
                                     (UInt8 *)&sin6,
                                     sizeof(sin6));
    
    CFSocketError setIPv6Error = CFSocketSetAddress(_socketIPv6, sin6cfd);
    CFRelease(sin6cfd);
    
    if (setIPv6Error) {
        return kCDAServerErrorCouldNotSetPort;
    }
    
    // have socket run in run loop
    CFRunLoopSourceRef runLoopSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault,
                                                                   _socketIPv6, 0);
    
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    CFRelease(runLoopSource);
    
    return kCDAServerErrorNone;
}

@end

@implementation CDAServer

-(void)dealloc
{
    if (self.isRunning) {
        
        [self stopServer];
    }
}

-(NSError *)startServerOnPort:(NSUInteger)port
{
    
    CDAServerErrorCode ipv4Error = [self setupIPv4SocketForPort:port];
    CDAServerErrorCode ipv6Error = [self setupIPv6SocketForPort:port];
    
    if (ipv4Error && ipv6Error) {
        
        NSString *errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Could not bind server to port %ld", @"Could not bind server to port <port>"), port];
        
        NSError *error = [NSError errorWithDomain:CDAServerErrorDomain
                                             code:kCDAServerErrorCouldNotSetPort
                                         userInfo:@{NSLocalizedDescriptionKey: errorDescription}];
        
        return error;
    }
    
    _isRunning = YES;
    
    return nil;
}

-(void)stopServer
{
    // close sockets
    
    if (_socketIPv4) {
        
        CFSocketInvalidate(_socketIPv4);
    }
    
    if (_socketIPv6) {
        
        CFSocketInvalidate(_socketIPv6);
    }
    
    _isRunning = NO;
}

#pragma mark - CFSocket CallBack

static void SocketCallBack (CFSocketRef s, CFSocketCallBackType callbackType, CFDataRef address, const void *data, void *info)
{
    
    if (data) {
        
        
    }
    
}

@end