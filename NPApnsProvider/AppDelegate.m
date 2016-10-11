//
//  AppDelegate.m
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/19.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import "NPMacro.h"
#import "AppDelegate.h"
#import "ViewController.h"
//#import "NPGernalPacket.h"
#import "NPApnsErrorPacket.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        NPLog(@"did");
        //_serverEngine=[[NPMyTCPServerEngine alloc] initWithPort:SERVER_PORT];
        _clientEngine=[NPApnsClientEngine new];
        //_clientEngine.serverDomain=APNS_SERVERDOMAIN;
        _clientEngine.serverPort=APNS_SERVERPORT;
        /*[_clientEngine setDelegate:_firstViewController];
        [_serverEngine setDegelate:_firstViewController];*/
        //[_serverEngine setPacketClass:[NPGernalPacket class]];
        [_clientEngine setPacketType:[NPApnsErrorPacket class]];
        _servers=@[APNS_SERVERDOMAIN1,APNS_SERVERDOMAIN2];
        
    }
    return self;
}

-(void)applicationWillFinishLaunching:(NSNotification *)notification
{
    NPLog(@"will");
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
