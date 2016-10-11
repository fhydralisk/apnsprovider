//
//  NPApnsClientEngine.h
//  NPApnsProvider
//
//  Created by 樊航宇 on 15/3/19.
//  Copyright (c) 2015年 樊航宇. All rights reserved.
//

#import <NopqzipLib/NopqzipLib.h>
@class NPApnsClientEngine;

@protocol NPApnsClientDelegate <NPClientDelegate>

@optional
-(void)clientEngineSSLHandshakeSucceed:(NPApnsClientEngine *)engine;

@end

@interface NPApnsClientEngine : NPTCPClientEngine

@property (nonatomic) NSData *certData;
@property (weak) id<NPApnsClientDelegate> delegate;


@end
