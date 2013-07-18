//
//  CDAAppDelegate.m
//  ColemanCDA Server
//
//  Created by Alsey Coleman Miller on 7/17/13.
//  Copyright (c) 2013 ColemanCDA. All rights reserved.
//

#import "CDAAppDelegate.h"
#import "CDAServer.h"

@implementation CDAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    _server = [[CDAServer alloc] init];
    
    NSError *error = [_server startServerOnPort:8080];
    
    if (error) {
        
        [NSApp presentError:error];
        
        [NSApp terminate:self];
        
    }
    
}

@end
