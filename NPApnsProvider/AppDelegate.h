//
//  AppDelegate.h
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/19.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NopqzipLib/NopqzipLib.h>
//#import "NPMyTCPServerEngine.h"
#import "NPApnsClientEngine.h"

@class ViewController;

#define SERVER_PORT 2466
#define APNS_SERVERDOMAIN1 @"gateway.sandbox.push.apple.com"
#define APNS_SERVERDOMAIN2 @"gateway.push.apple.com"
#define APNS_SERVERPORT 2195

#define UDEFKEY_TOKEN @"lastToken"
#define UDEFKEY_CERT  @"certFile"
#define UDEFKEY_CERTDATA @"certData"
//#define UDEFKEY_

#define PLT_PLISTNAME @"PayloadTemplates"

#define TOKENSTORENAME @"tokens"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, readonly, nonatomic) NPApnsClientEngine* clientEngine;
//@property (strong, readonly, nonatomic) NPMyTCPServerEngine *serverEngine;
@property (weak, nonatomic) ViewController *firstViewController;
@property (readonly) NSArray *servers;
@end

