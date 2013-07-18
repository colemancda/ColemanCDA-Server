//
//  CDAAppDelegate.h
//  ColemanCDA Server
//
//  Created by Alsey Coleman Miller on 7/17/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CDAServer;

@interface CDAAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly) CDAServer *server;

@end
